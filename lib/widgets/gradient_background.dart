import 'package:flutter/material.dart';

/// Gradient background widget for screens
class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.gradient,
    required this.child,
  });

  final LinearGradient gradient;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient),
      child: child,
    );
  }
}
