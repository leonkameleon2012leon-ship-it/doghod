import 'dart:math';

import 'package:flutter/material.dart';

import '../core/managers/game_manager.dart';
import '../models/minigame_result.dart';
import '../i18n.dart';

class PipesGameScreen extends StatefulWidget {
  const PipesGameScreen({super.key, required this.gameManager});

  final GameManager gameManager;

  @override
  State<PipesGameScreen> createState() => _PipesGameScreenState();
}

class _PipesGameScreenState extends State<PipesGameScreen> {
  static const int _gridSize = 4;
  static const int _parMoves = 16;
  final Random _random = Random();
  late List<int> _current;
  late List<int> _target;
  bool _completed = false;
  int _moves = 0;
  final _startTime = DateTime.now();

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
      _moves++;
    });
    if (_isComplete()) {
      setState(() {
        _completed = true;
      });
      
      // Create minigame result
      final timePlayed = DateTime.now().difference(_startTime);
      final result = MinigameResult.pipeFix(
        moves: _moves,
        parMoves: _parMoves,
        timePlayed: timePlayed,
      );
      
      // Apply rewards through game manager
      widget.gameManager.applyMinigameResult(result);
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
      // Underwater gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF89CFF0),
              Color(0xFF5DADE2),
              Color(0xFF3498DB),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Back button
                    Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF3498DB)),
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Title
                    Expanded(
                      child: Text(
                        I18n.tr('pipesTitle'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Color(0x55000000),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate optimal grid size - fill more of the screen
                    final maxSize = min(constraints.maxWidth * 0.95, constraints.maxHeight * 0.7);
                    final gridSize = min(maxSize, 500.0);
                    final tileSize = (gridSize - 32) / _gridSize;

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Instructions
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  I18n.tr('pipesHint'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Target preview - bigger and more prominent
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.flag, color: Color(0xFF3498DB), size: 24),
                                        const SizedBox(width: 8),
                                        Text(
                                          I18n.tr('target'),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xFF3498DB),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: GridView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: _gridSize,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                        ),
                                        itemCount: _target.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8F4F8),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: _PipePiece(
                                                orientation: _target[index],
                                                size: 32,
                                                isTarget: true,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Main game grid - bigger and more colorful
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: SizedBox(
                                    width: gridSize,
                                    height: gridSize,
                                    child: GridView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _gridSize,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: _gridSize * _gridSize,
                                      itemBuilder: (context, index) {
                                        final isCorrect = _current[index] == _target[index];
                                        return GestureDetector(
                                          onTap: () => _rotatePipe(index),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: isCorrect
                                                    ? [const Color(0xFF66BB6A), const Color(0xFF43A047)]
                                                    : [Colors.white, const Color(0xFFF5F5F5)],
                                              ),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: isCorrect
                                                    ? const Color(0xFF2E7D32)
                                                    : const Color(0xFFB0BEC5),
                                                width: 3,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: _PipePiece(
                                                orientation: _current[index],
                                                size: tileSize * 0.65,
                                                isTarget: false,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              if (_completed) ...[
                                const SizedBox(height: 24),
                                // Success card
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFFFFFF), Color(0xFFE8F5E9)],
                                    ),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(28),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                                          ),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.4),
                                              blurRadius: 16,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          size: 48,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        I18n.tr('gameOver'),
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'Cleanliness +${15 + (_moves <= _parMoves ? 15 : _moves <= _parMoves + 5 ? 10 : 5)}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF43A047),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => Navigator.of(context).pop(),
                                          borderRadius: BorderRadius.circular(24),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                colors: [Color(0xFF5DADE2), Color(0xFF3498DB)],
                                              ),
                                              borderRadius: BorderRadius.circular(24),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue.withOpacity(0.4),
                                                  blurRadius: 12,
                                                  offset: const Offset(0, 6),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 48),
                                            child: Text(
                                              I18n.tr('backHome'),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}

class _PipePiece extends StatelessWidget {
  const _PipePiece({
    required this.orientation,
    required this.size,
    required this.isTarget,
  });

  final int orientation;
  final double size;
  final bool isTarget;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: orientation * pi / 2,
      child: CustomPaint(
        size: Size(size, size),
        painter: _PipePainter(isTarget: isTarget),
      ),
    );
  }
}

class _PipePainter extends CustomPainter {
  _PipePainter({required this.isTarget});
  
  final bool isTarget;

  @override
  void paint(Canvas canvas, Size size) {
    // Thicker pipes with gradient for depth
    final pipeWidth = size.width * 0.45;
    final center = size.width / 2;

    // Pipe colors - bright aqua/teal for game, muted for target
    final Color lightColor = isTarget 
        ? const Color(0xFF80DEEA) 
        : const Color(0xFF4DD0E1);
    final Color darkColor = isTarget 
        ? const Color(0xFF26C6DA) 
        : const Color(0xFF00ACC1);

    // Shadow/depth effect
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Vertical pipe segment with shadow
    final verticalShadow = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2 + 2,
        2,
        pipeWidth,
        center + pipeWidth / 2,
      ),
      Radius.circular(pipeWidth / 3),
    );
    canvas.drawRRect(verticalShadow, shadowPaint);

    // Vertical pipe segment with gradient
    final verticalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2,
        0,
        pipeWidth,
        center + pipeWidth / 2,
      ),
      Radius.circular(pipeWidth / 3),
    );
    
    final verticalGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [lightColor, darkColor],
      ).createShader(verticalRect.outerRect);
    canvas.drawRRect(verticalRect, verticalGradient);

    // Stroke outline for vertical
    final strokePaint = Paint()
      ..color = const Color(0xFF006064)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isTarget ? 2.0 : 3.0;
    canvas.drawRRect(verticalRect, strokePaint);

    // Horizontal pipe segment with shadow
    final horizontalShadow = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2 + 2,
        center - pipeWidth / 2 + 2,
        center + pipeWidth / 2,
        pipeWidth,
      ),
      Radius.circular(pipeWidth / 3),
    );
    canvas.drawRRect(horizontalShadow, shadowPaint);

    // Horizontal pipe segment with gradient
    final horizontalRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2,
        center - pipeWidth / 2,
        center + pipeWidth / 2,
        pipeWidth,
      ),
      Radius.circular(pipeWidth / 3),
    );
    
    final horizontalGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [lightColor, darkColor],
      ).createShader(horizontalRect.outerRect);
    canvas.drawRRect(horizontalRect, horizontalGradient);

    // Stroke outline for horizontal
    canvas.drawRRect(horizontalRect, strokePaint);

    // Add highlight for depth effect
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = pipeWidth * 0.12;

    // Vertical highlight
    final verticalHighlight = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2 + pipeWidth * 0.15,
        pipeWidth * 0.15,
        pipeWidth * 0.3,
        center + pipeWidth / 2 - pipeWidth * 0.3,
      ),
      Radius.circular(pipeWidth / 4),
    );
    canvas.drawRRect(verticalHighlight, highlightPaint);

    // Horizontal highlight
    final horizontalHighlight = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        center - pipeWidth / 2 + pipeWidth * 0.15,
        center - pipeWidth / 2 + pipeWidth * 0.15,
        center + pipeWidth / 2 - pipeWidth * 0.45,
        pipeWidth * 0.3,
      ),
      Radius.circular(pipeWidth / 4),
    );
    canvas.drawRRect(horizontalHighlight, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
