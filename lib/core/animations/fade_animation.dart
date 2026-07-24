// TODO: Implement fade animation widget.
import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final Widget child;
  final int duration;
  final double beginOpacity;

  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = 600,
    this.beginOpacity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: beginOpacity,
        end: 1,
      ),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeIn,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}