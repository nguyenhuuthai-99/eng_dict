import 'package:eng_dict/model/quiz/word_matching.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/widgets/practice/quiz/quiz_feedback.dart';
import 'package:flutter/material.dart';

class WordMatchingScreen extends StatefulWidget {
  WordMatchingScreen({
    required this.wordMatchingLesson,
    required this.onSubmit,
    required this.timeLimit,
    required this.onNextPressed,
    super.key,
  });
  WordMatchingLesson wordMatchingLesson;
  Function(List<Vocabulary> correctWords, List<Vocabulary> incorrectWords)
      onSubmit;
  Function() onNextPressed;
  int timeLimit;

  @override
  State<WordMatchingScreen> createState() => _WordMatchingScreenState();
}

class _WordMatchingScreenState extends State<WordMatchingScreen> {
  bool isSubmitted = false;

  // Track the current drag position
  Offset? dragPosition;
  Offset? startPosition;

  int? currentWordIndex;

  // GlobalKeys to get the positions of word title widgets
  final List<GlobalKey> wordTitleKeys =
      List.generate(4, (index) => GlobalKey());

  final List<GlobalKey> definitionKeys =
      List.generate(4, (index) => GlobalKey());

  final GlobalKey stackKey = GlobalKey();

  final Map<int, Color?> activeWidgets = {};

  //Widget Colors
  final List<Color> activeColors = [
    Constant.kBlue,
    Constant.kOrange,
    Constant.kYellowIndicatorColor,
    Constant.kSecondaryColor
  ];

  // Helper method to get the center of a widget using its GlobalKey
  Offset _getWidgetCenter(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(renderBox.size.centerRight(Offset.zero));
  }

  late List<Vocabulary> words;
  List<String> shuffledDefinition = [];
  late Map<int, int> connections;
  late MapEntry<int, int>? currentConnection;

  List<Vocabulary> incorrectWords = [];
  List<Vocabulary> correctWords = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    words = widget.wordMatchingLesson.words;
    connections = widget.wordMatchingLesson.connections;
    currentConnection = widget.wordMatchingLesson.currentConnection;

    for (var element in words) {
      shuffledDefinition.add(element.definition);

      shuffledDefinition.shuffle();
    }

    words.shuffle();
  }

  void checkAnswer() {
    isSubmitted = true;

    Set<int> unconnectedIndex = {0, 1, 2, 3};

    // go through the connection map, check
    connections.forEach(
      (key, value) {
        unconnectedIndex.remove(key);
        setState(() {
          //if correct
          if (words[key].definition == shuffledDefinition[value]) {
            activeWidgets[key] = Constant.kGreenIndicatorColor;
            activeColors[key] = Constant.kGreenIndicatorColor;
            correctWords.add(words[key]);
          } else {
            //if wrong
            activeWidgets[key] = Constant.kRedIndicatorColor;
            activeColors[key] = Constant.kRedIndicatorColor;
            incorrectWords.add(words[key]);
          }
        });
      },
    );

    if (unconnectedIndex.isNotEmpty) {
      for (int index in unconnectedIndex) {
        incorrectWords.add(words[index]);
        activeColors[index] = Constant.kRedIndicatorColor;
        activeWidgets[index] = Constant.kRedIndicatorColor;
      }
    }

    widget.onSubmit(correctWords, incorrectWords);
  }

  void onTimesUp() {
    if (isSubmitted) return;
    checkAnswer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.kMarginLarge),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: TimerWidget(
                        startTime: widget.timeLimit,
                        onTimesUp: () => onTimesUp()),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Stack(
                    key: stackKey,
                    children: [
                      // Draw connecting lines
                      CustomPaint(
                        painter: LinePainter(
                            connections: widget.wordMatchingLesson.connections,
                            stackKey: stackKey,
                            startPosition: startPosition,
                            dragPosition: dragPosition,
                            currentWordIndex: currentWordIndex,
                            wordTitleKeys: wordTitleKeys,
                            definitionKeys: definitionKeys,
                            getLineColor: (int index) => activeColors[index]),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: words.asMap().entries.map(
                                (e) {
                                  int i = e.key;
                                  return WordMatchingTitleWidget(
                                    onDragStarted: () {
                                      if (isSubmitted) {
                                        return;
                                      }
                                      setState(() {
                                        activeWidgets[i] = activeColors[i];

                                        currentWordIndex = i;

                                        startPosition =
                                            _getWidgetCenter(wordTitleKeys[i]);
                                        dragPosition =
                                            _getWidgetCenter(wordTitleKeys[i]);

                                        int existingConnection =
                                            connections.keys.firstWhere(
                                          (element) => element == i,
                                          orElse: () => -1,
                                        );
                                        if (existingConnection != -1) {
                                          currentConnection = MapEntry(
                                              existingConnection,
                                              connections
                                                  .remove(existingConnection)!);
                                        }
                                      });
                                    },
                                    onDragUpdate: (details) {
                                      if (isSubmitted) {
                                        return;
                                      }
                                      setState(() {
                                        dragPosition = details.globalPosition;
                                      });
                                    },
                                    onDraggableCanceled: () {
                                      if (isSubmitted) return;

                                      if (currentConnection == null) {
                                        activeWidgets[i] = null;
                                        return;
                                      }
                                      connections
                                          .addEntries([currentConnection!]);
                                      currentConnection = null;
                                    },
                                    onDragEnd: () {
                                      if (isSubmitted) return;
                                      setState(() {
                                        dragPosition = null;
                                        startPosition = null;
                                      });
                                    },
                                    activeColor: activeWidgets[i],
                                    wordIndex: i,
                                    title: words[i].wordTitle,
                                    key: wordTitleKeys[i],
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Flexible(
                            flex: 6,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0;
                                    i < shuffledDefinition.length;
                                    i++)
                                  WordMatchingDefinitionWidget(
                                    onAcceptWithDetails: (details) {
                                      if (isSubmitted) return;
                                      setState(() {
                                        int? existingWord = connections.entries
                                            .firstWhere(
                                              (entry) => entry.value == i,
                                              orElse: () => const MapEntry(-1,
                                                  -1), // Default invalid entry
                                            )
                                            .key;

                                        if (existingWord != -1) {
                                          connections.remove(existingWord);
                                          activeWidgets[existingWord] = null;
                                        }

                                        connections[details.data] = i;
                                        currentConnection = null;
                                      });
                                    },
                                    pickColor: () {
                                      int connectedWordIndex =
                                          connections.entries
                                              .firstWhere(
                                                (element) => element.value == i,
                                                orElse: () =>
                                                    const MapEntry(-1, -1),
                                              )
                                              .key;
                                      if (connectedWordIndex != -1) {
                                        return activeWidgets[
                                            connectedWordIndex]!;
                                      }
                                      if (isSubmitted) {
                                        return Constant.kRedIndicatorColor;
                                      }
                                      return Colors.black54;
                                    },
                                    definition: shuffledDefinition[i],
                                    key: definitionKeys[i],
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: connections.length == 4
                            ? Constant.kBlue
                            : Colors.black12,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Constant.kMarginExtraSmall),
                        )),
                    onPressed: connections.length == 4 ? checkAnswer : null,
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ),
        if (isSubmitted)
          Align(
            alignment: Alignment.bottomCenter,
            child: incorrectWords.isEmpty
                ? CorrectFeedback(
                    onNextPressed: widget.onNextPressed,
                  )
                : IncorrectFeedback(
                    onNextPressed: widget.onNextPressed,
                    incorrectWords: incorrectWords,
                  ),
          ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  final Map<int, int> connections;
  final Offset? startPosition;
  final Offset? dragPosition;
  final List<GlobalKey> wordTitleKeys;
  final List<GlobalKey> definitionKeys;
  final GlobalKey stackKey;
  Color Function(int index) getLineColor;
  int? currentWordIndex;
  LinePainter(
      {required this.connections,
      required this.getLineColor,
      this.currentWordIndex,
      this.startPosition,
      this.dragPosition,
      required this.stackKey,
      required this.wordTitleKeys,
      required this.definitionKeys});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2;

    final RenderBox box =
        stackKey.currentContext?.findRenderObject() as RenderBox;

    connections.forEach((wordIndex, defIndex) {
      // Get the center of the word title widget
      final RenderBox wordRenderBox = wordTitleKeys[wordIndex]
          .currentContext
          ?.findRenderObject() as RenderBox;
      final startPointGlobal = wordRenderBox
          .localToGlobal(wordRenderBox.size.centerRight(Offset.zero));

      final startPoint = getLocalOffset(box, startPointGlobal);

      // Get the center of the definition widget
      final RenderBox defRenderBox = definitionKeys[defIndex]
          .currentContext
          ?.findRenderObject() as RenderBox;
      final endPointGlobal =
          defRenderBox.localToGlobal(defRenderBox.size.centerLeft(Offset.zero));

      final endPoint = getLocalOffset(box, endPointGlobal);

      // Draw the correct line
      canvas.drawLine(
          startPoint, endPoint, paint..color = getLineColor(wordIndex));
    });

    // Draw the line during drag
    if (dragPosition != null &&
        startPosition != null &&
        currentWordIndex != null) {
      final Offset startLocal = getLocalOffset(box, startPosition!);
      final Offset endLocal = getLocalOffset(box, dragPosition!);
      canvas.drawLine(
          startLocal, endLocal, paint..color = getLineColor(currentWordIndex!));
      // }
    }
  }

  Offset getLocalOffset(RenderBox box, Offset globalOffset) {
    return box.globalToLocal(globalOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WordMatchingTitleWidget extends StatelessWidget {
  WordMatchingTitleWidget({
    required this.wordIndex,
    required this.title,
    required this.onDragStarted,
    required this.onDragUpdate,
    required this.onDraggableCanceled,
    required this.onDragEnd,
    this.activeColor,
    this.resultColor,
    super.key,
  });

  Function() onDragStarted;
  Function(DragUpdateDetails details) onDragUpdate;
  Function() onDraggableCanceled;
  Function() onDragEnd;

  String title;
  int wordIndex;

  Color? activeColor;
  Color? resultColor;

  Color borderColor = Constant.kGreyLine;

  Color textColor = Colors.black87;

  Color selectedColor = Constant.kBlue;

  Color pickColor() {
    if (resultColor != null) {
      return resultColor!;
    }
    if (activeColor != null) {
      return activeColor!;
    }
    return Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: wordIndex,
      feedback: const SizedBox(),
      onDragStarted: () {
        onDragStarted();
      },
      onDragUpdate: (details) {
        onDragUpdate(details);
      },
      onDraggableCanceled: (velocity, offset) {
        onDraggableCanceled();
      },
      onDragEnd: (details) {
        onDragEnd();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Constant.kMarginMedium),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(vertical: Constant.kMarginExtraSmall),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.kMarginExtraSmall),
            border: Border.all(color: pickColor(), width: 2)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w900, color: pickColor()),
          ),
        ),
      ),
    );
  }
}

class WordMatchingDefinitionWidget extends StatelessWidget {
  WordMatchingDefinitionWidget({
    required this.onAcceptWithDetails,
    required this.definition,
    required this.pickColor,
    super.key,
  });

  Function(DragTargetDetails details) onAcceptWithDetails;
  Color Function() pickColor;

  String definition;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
        onAcceptWithDetails: onAcceptWithDetails,
        builder: (BuildContext context, List<Object?> candidateData,
                List<dynamic> rejectedData) =>
            Container(
              margin: EdgeInsets.symmetric(vertical: Constant.kMarginMedium),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: Constant.kMarginSmall,
                  vertical: Constant.kMarginExtraSmall),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(Constant.kMarginExtraSmall),
                  border: Border.all(color: pickColor(), width: 2)),
              child: Text(
                definition,
                style:
                    TextStyle(fontWeight: FontWeight.w900, color: pickColor()),
              ),
            ));
  }
}
