// TODO: Implement scale animation widget.
import 'package:flutter/material.dart';

class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final int duration;
  final double beginScale;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration = 600,
    this.beginScale = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: beginScale,
        end: 1,
      ),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }
}