import 'dart:math';

import 'package:flutter/material.dart';

import '../doghog_controller.dart';
import '../i18n.dart';

class PipesGameScreen extends StatefulWidget {
  const PipesGameScreen({super.key, required this.controller});

  final DogHogController controller;

  @override
  State<PipesGameScreen> createState() => _PipesGameScreenState();
}

class _PipesGameScreenState extends State<PipesGameScreen> {
  static const int _gridSize = 4;
  final Random _random = Random();
  late List<int> _current;
  late List<int> _target;
  bool _completed = false;
  int _reward = 0;

  @override
  void initState() {
    super.initState();
    _target = List<int>.generate(
      _gridSize * _gridSize,
      (_) => _random.nextInt(4),
    );
    _current = List<int>.generate(_gridSize * _gridSize, (index) {
      var orientation = _random.nextInt(4);
      if (orientation == _target[index]) {
        orientation = (orientation + 1) % 4;
      }
      return orientation;
    });
  }

  void _rotatePipe(int index) {
    if (_completed) {
      return;
    }
    setState(() {
      _current[index] = (_current[index] + 1) % 4;
    });
    if (_isComplete()) {
      setState(() {
        _completed = true;
        _reward = 15;
      });
      widget.controller.fixPipes(_reward);
    }
  }

  bool _isComplete() {
    for (var i = 0; i < _current.length; i++) {
      if (_current[i] != _target[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.tr('pipesTitle')),
        backgroundColor: const Color(0xFF457B9D),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate optimal grid size
            final maxSize = min(constraints.maxWidth, constraints.maxHeight - 200);
            final gridSize = min(maxSize * 0.85, 400.0);
            final tileSize = (gridSize - 24) / _gridSize;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instructions
                      Text(
                        I18n.tr('pipesHint'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      // Target preview
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                I18n.tr('target'),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 160,
                                height: 160,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _gridSize,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                  ),
                                  itemCount: _target.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: _PipePiece(
                                          orientation: _target[index],
                                          size: 28,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Main game grid
                      Center(
                        child: SizedBox(
                          width: gridSize,
                          height: gridSize,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _gridSize,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemCount: _gridSize * _gridSize,
                            itemBuilder: (context, index) {
                              final isCorrect = _current[index] == _target[index];
                              return GestureDetector(
                                onTap: () => _rotatePipe(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? Colors.green[50]
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isCorrect
                                          ? Colors.green
                                          : const Color(0xFFCED4DA),
                                      width: 2,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x11000000),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _PipePiece(
                                      orientation: _current[index],
                                      size: tileSize * 0.7,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (_completed) ...[
                        const SizedBox(height: 24),
                        Card(
                          color: Colors.green[50],
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 64,
                                  color: Colors.green,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  I18n.tr('gameOver'),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  I18n.trf('rewardClean', {'amount': '$_reward'}),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      backgroundColor: const Color(0xFF457B9D),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(I18n.tr('backHome')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PipePiece extends StatelessWidget {
  const _PipePiece({
    required this.orientation,
    required this.size,
  });

  final int orientation;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: orientation * pi / 2,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PipePainter(),
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4EA8DE)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = const Color(0xFF1E6F9F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final pipeWidth = size.width * 0.35;
    final center = size.width / 2;

    // Vertical pipe segment
    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2,
        0,
        pipeWidth,
        center + pipeWidth / 2,
      ),
      Radius.circular(pipeWidth / 4),
    );
    canvas.drawRRect(verticalRect, paint);
    canvas.drawRRect(verticalRect, strokePaint);

    // Horizontal pipe segment
    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2,
        center - pipeWidth / 2,
        center + pipeWidth / 2,
        pipeWidth,
      ),
      Radius.circular(pipeWidth / 4),
    );
    canvas.drawRRect(horizontalRect, paint);
    canvas.drawRRect(horizontalRect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
