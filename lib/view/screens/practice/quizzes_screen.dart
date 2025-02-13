import 'dart:math';

import 'package:eng_dict/model/quiz/multiple_choice.dart';
import 'package:eng_dict/model/quiz/spelling.dart';
import 'package:eng_dict/model/quiz/word_matching.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/model/word.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:eng_dict/view/component/count_down_timer.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Vocabulary> vocabList = [
  Vocabulary()
    ..id = 1
    ..wordTitle = "Eloquent"
    ..wordForm = "Adjective"
    ..phraseTitle = "He gave an eloquent speech."
    ..wordDefinition = "Fluent or persuasive in speaking or writing."
    ..fluencyLevel = 3
    ..URL = "https://example.com/eloquent"
    ..soundUrl = "https://example.com/sounds/eloquent.mp3",
  Vocabulary()
    ..id = 2
    ..wordTitle = "Resilient"
    ..wordForm = "Adjective"
    ..phraseTitle = "She is resilient in tough situations."
    ..wordDefinition = "Able to recover quickly from difficulties."
    ..fluencyLevel = 2
    ..URL = "https://example.com/resilient"
    ..soundUrl = "https://example.com/sounds/resilient.mp3",
  Vocabulary()
    ..id = 3
    ..wordTitle = "Meticulous"
    ..wordForm = "Adjective"
    ..phraseTitle = "He is meticulous about details."
    ..wordDefinition = "Showing great attention to detail."
    ..fluencyLevel = 1
    ..URL = "https://example.com/meticulous"
    ..soundUrl = "https://example.com/sounds/meticulous.mp3",
  Vocabulary()
    ..id = 4
    ..wordTitle = "Candid"
    ..wordForm = "Adjective"
    ..phraseTitle = "She was candid about her mistakes."
    ..wordDefinition = "Truthful and straightforward."
    ..fluencyLevel = 10
    ..URL = "https://example.com/candid"
    ..soundUrl = "https://example.com/sounds/candid.mp3",
];

const level1Count = 6;
const level2Count = 3;
const level3Count = 1;

const wordMatchingTimeLimit = 10;
const multipleChoiceTimeLimit = 30;
const spellingTimeLimit = 30;

class QuizzesScreen extends StatefulWidget {
  const QuizzesScreen({super.key});

  @override
  State<QuizzesScreen> createState() => _QuizzesScreenState();
}

class _QuizzesScreenState extends State<QuizzesScreen> {
  bool _isQuizReady = false;
  Random random = Random();

  late List<Vocabulary> wordList;

  List<MultipleChoiceLesson> multipleChoiceLessons = [];
  List<WordMatchingLesson> wordMatchingLessons = [];
  List<SpellingLesson> spellingLessons = [];
  List<Object> finalLessons = [];

  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    //todo dummy object
    WordMatchingLesson wordMatchingLesson = WordMatchingLesson();
    wordMatchingLesson.words = vocabList;
    wordMatchingLessons.add(wordMatchingLesson);

    // TODO: implement initState
    super.initState();
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    initQuizzes();
  }

  void initQuizzes() {
    //todo get practice word, user need to get at least 4 added word to continue
    //todo create lesson for each word maximum 10 words

    //todo initiate practice lesson for each game,
    //todo make a list for each game, may be nested list
    //List [multipleChoiceLessons]

    //when the quiz is ready, start the quiz screen
    setState(() {
      _isQuizReady = true;
    });
  }

  void initLesson() {
    for (int i = 0; i < 4; i++) {
      if (i == 3) {
        initQuiz();
        continue;
      }
      initQuiz();
      initWordMatching();
      initSpelling();
    }
  }

  void initQuiz() {}

  void initWordMatching() {}

  void initSpelling() {}

  List<Vocabulary> pickRandom(List<Vocabulary> source, int count) {
    List<Vocabulary> picked = [];
    for (int i = 0; i < count && source.isNotEmpty; i++) {
      int index = random.nextInt(source.length);
      picked.add(source.removeAt(index));
    }
    return picked;
  }

  Future<void> initWords() async {
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    Random random = Random();

    // Function to randomly pick `count` elements from a list
    List<Vocabulary> pickRandom(List<Vocabulary> source, int count) {
      List<Vocabulary> picked = [];
      for (int i = 0; i < count && source.isNotEmpty; i++) {
        int index = random.nextInt(source.length);
        picked.add(source.removeAt(index));
      }
      return picked;
    }

    List<Vocabulary> level1Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.unfamiliar);
    List<Vocabulary> level2Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.familiar);
    List<Vocabulary> level3Words =
        await databaseHelper.getVocabularyOnLevel(VocabularyLevel.mastered);

    wordList.addAll(pickRandom(level1Words, level1Count));
    wordList.addAll(pickRandom(level2Words, level2Count));
    wordList.addAll(pickRandom(level3Words, level3Count));

    int remaining = 10 - wordList.length;
    if (remaining > 0) {
      List<Vocabulary> extraElements = [
        ...level2Words,
        ...level3Words,
        ...level1Words
      ];
      wordList.addAll(pickRandom(extraElements, remaining));
    }
  }

  void onTimesUp() {
    //todo move to the next question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3/10"),
        actions: [Text("Skip   ")],
      ),
      body: WordMatchingWidget(
        onSubmit: (correctWords, incorrectWords) {
          //todo add result list
        },
        wordMatchingLesson: wordMatchingLessons[0],
      ),
    );
  }
}

class WordMatchingWidget extends StatefulWidget {
  WordMatchingWidget({
    required this.wordMatchingLesson,
    required this.onSubmit,
    super.key,
  });
  WordMatchingLesson wordMatchingLesson;
  Function(List<Vocabulary> correctWords, List<Vocabulary> incorrectWords)
      onSubmit;

  @override
  State<WordMatchingWidget> createState() => _WordMatchingWidgetState();
}

class _WordMatchingWidgetState extends State<WordMatchingWidget> {
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
                        startTime: wordMatchingTimeLimit,
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
                    onNextPressed: () {
                      //todo
                    },
                  )
                : IncorrectFeedback(
                    onNextPressed: () {
                      //todo
                    },
                    incorrectWords: incorrectWords,
                  ),
          ),
      ],
    );
  }
}

class IncorrectFeedback extends StatelessWidget {
  IncorrectFeedback({
    required this.onNextPressed,
    required this.incorrectWords,
    super.key,
  });

  List<Vocabulary> incorrectWords;

  Function() onNextPressed;

  String buildIncorrectWordText() {
    String result = 'You need to work more on:';
    for (var word in incorrectWords) {
      result += ' ${word.wordTitle},';
    }
    return result.substring(0, result.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Constant.kRedBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.kMarginSmall),
              topRight: Radius.circular(Constant.kMarginSmall))),
      padding: EdgeInsets.only(
          left: Constant.kMarginLarge,
          right: Constant.kMarginLarge,
          top: Constant.kMarginLarge),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.xmark_circle_fill,
                  color: Constant.kRedIndicatorColor,
                ),
                const SizedBox(
                  width: Constant.kMarginMedium,
                ),
                Text(
                  "Incorrect",
                  style: Constant.kPracticeFeedbackTitle
                      .apply(color: Constant.kRedIndicatorColor),
                )
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: Constant.kMarginMedium),
              child: Text(
                buildIncorrectWordText(),
                style: TextStyle(color: Constant.kRedIndicatorColor),
              ),
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: Constant.kMarginMedium),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constant.kMarginSmall)),
                    backgroundColor: Constant.kRedIndicatorColor),
                onPressed: onNextPressed,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}

class CorrectFeedback extends StatelessWidget {
  CorrectFeedback({
    required this.onNextPressed,
    super.key,
  });

  Function() onNextPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Constant.kGreenBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Constant.kMarginSmall),
              topRight: Radius.circular(Constant.kMarginSmall))),
      padding: const EdgeInsets.only(
          left: Constant.kMarginLarge,
          right: Constant.kMarginLarge,
          top: Constant.kMarginLarge),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: Constant.kGreenIndicatorColor,
                ),
                const SizedBox(
                  width: Constant.kMarginMedium,
                ),
                Text(
                  "Good Job",
                  style: Constant.kPracticeFeedbackTitle
                      .apply(color: Constant.kGreenIndicatorColor),
                )
              ],
            ),
            const SizedBox(
              height: Constant.kMarginMedium,
            ),
            TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: Constant.kMarginMedium),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constant.kMarginSmall)),
                    backgroundColor: Constant.kGreenIndicatorColor),
                onPressed: onNextPressed,
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
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
