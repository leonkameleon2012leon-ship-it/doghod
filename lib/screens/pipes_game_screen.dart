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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  I18n.tr('pipesHint'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(I18n.tr('target')),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      height: 120,
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
                          return _PipePiece(orientation: _target[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _gridSize,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _gridSize * _gridSize,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _rotatePipe(index),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFCED4DA)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x11000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _PipePiece(orientation: _current[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_completed)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(I18n.tr('gameOver')),
                  const SizedBox(height: 6),
                  Text(I18n.trf('rewardClean', {
                    'amount': '$_reward',
                  })),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(I18n.tr('backHome')),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PipePiece extends StatelessWidget {
  const _PipePiece({required this.orientation});

  final int orientation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: orientation * pi / 2,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 2,
              bottom: 16,
              child: Container(
                width: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4EA8DE),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              right: 2,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4EA8DE),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
