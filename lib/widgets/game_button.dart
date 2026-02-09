import 'package:flutter/material.dart';
import '../core/constants/visual_constants.dart';

/// Big, colorful game button with gradient for actions
class GameButton extends StatelessWidget {
  const GameButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.startColor,
    required this.endColor,
    this.height,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color startColor;
  final Color endColor;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(GameSizes.borderRadius),
        child: Container(
          height: height ?? GameSizes.buttonHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
            borderRadius: BorderRadius.circular(GameSizes.borderRadius),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Color(0x55000000),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
