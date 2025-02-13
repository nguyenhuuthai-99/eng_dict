import 'package:flutter/material.dart';

void main() {
  runApp(MatchingGameApp());
}

class MatchingGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Matching Word Game')),
        body: SafeArea(child: MatchingGame()),
      ),
    );
  }
}

class MatchingGame extends StatefulWidget {
  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<MatchingGame> {
  // Track connections between word titles and definitions
  Map<int, int> connections = {};
  // Track the current drag position
  Offset? dragPosition;
  Offset? startPosition;
  MapEntry<int, int>? currentConnection;

  // Word titles and definitions
  final List<String> wordTitles = ['Word1', 'Word2', 'Word3', 'Word4'];
  final List<String> definitions = ['Def1', 'Def2', 'Def3', 'Def4'];

  // GlobalKeys to get the positions of word title widgets
  final List<GlobalKey> wordTitleKeys =
      List.generate(4, (index) => GlobalKey());

  final List<GlobalKey> definitionKeys =
      List.generate(4, (index) => GlobalKey());

  final GlobalKey stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: stackKey,
      children: [
        // Draw connecting lines
        CustomPaint(
          painter: LinePainter(
              connections: connections,
              stackKey: stackKey,
              startPosition: startPosition,
              dragPosition: dragPosition,
              wordTitles: wordTitles,
              definitions: definitions,
              wordTitleKeys: wordTitleKeys,
              definitionKeys: definitionKeys),
        ),
        // Word titles (draggable)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: wordTitles.asMap().entries.map((entry) {
                int index = entry.key;
                String word = entry.value;
                return Draggable<int>(
                  data: index,
                  feedback: SizedBox(),
                  onDragStarted: () {
                    setState(() {
                      startPosition = _getWidgetCenter(wordTitleKeys[index]);
                      dragPosition = _getWidgetCenter(wordTitleKeys[index]);

                      int existingConnection = connections.keys.firstWhere(
                        (element) => element == index,
                        orElse: () => -1,
                      );
                      print(existingConnection);
                      if (existingConnection != -1) {
                        currentConnection = MapEntry(existingConnection,
                            connections.remove(existingConnection)!);
                      }
                    });
                  },
                  onDragUpdate: (details) {
                    setState(() {
                      dragPosition = details.globalPosition;
                    });
                  },
                  onDraggableCanceled: (velocity, offset) {
                    if (currentConnection == null) {
                      return;
                    }
                    connections.addEntries([currentConnection!]);
                    currentConnection = null;
                  },
                  onDragEnd: (details) {
                    setState(() {
                      dragPosition = null;
                      startPosition = null;
                    });
                  },
                  child: Container(
                    key: wordTitleKeys[index],
                    padding: EdgeInsets.all(8),
                    color: Colors.blue,
                    child: Text(word),
                  ),
                );
              }).toList(),
            ),
            Expanded(child: SizedBox()),
            // Definitions (drag targets)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: definitions.asMap().entries.map((entry) {
                int index = entry.key;
                String definition = entry.value;
                return DragTarget<int>(
                  onAcceptWithDetails: (data) {
                    setState(() {
                      int? existingWord = connections.entries
                          .firstWhere(
                            (entry) => entry.value == index,
                            orElse: () =>
                                const MapEntry(-1, -1), // Default invalid entry
                          )
                          .key;

                      if (existingWord != -1) {
                        connections.remove(existingWord);
                      }

                      connections[data.data] = index;
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.green,
                      key: definitionKeys[index],
                      child: Text(definition),
                    );
                  },
                );
              }).toList(),
            ),
          ],
        )
      ],
    );
  }

  // Helper method to get the center of a widget using its GlobalKey
  Offset _getWidgetCenter(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(renderBox.size.centerRight(Offset.zero));
  }
}

class LinePainter extends CustomPainter {
  final Map<int, int> connections;
  final Offset? startPosition;
  final Offset? dragPosition;
  final List<String> wordTitles;
  final List<String> definitions;
  final List<GlobalKey> wordTitleKeys;
  final List<GlobalKey> definitionKeys;
  final GlobalKey stackKey;
  LinePainter(
      {required this.connections,
      this.startPosition,
      this.dragPosition,
      required this.stackKey,
      required this.wordTitles,
      required this.definitions,
      required this.wordTitleKeys,
      required this.definitionKeys});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

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
      canvas.drawLine(startPoint, endPoint, paint);
    });

    // Draw the line during drag
    if (dragPosition != null && startPosition != null) {
      final Offset startLocal = getLocalOffset(box, startPosition!);
      final Offset endLocal = getLocalOffset(box, dragPosition!);
      canvas.drawLine(startLocal, endLocal, paint);
      // }
    }
  }

  Offset getLocalOffset(RenderBox box, Offset globalOffset) {
    return box.globalToLocal(globalOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
