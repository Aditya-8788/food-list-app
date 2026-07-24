// TODO: Implement slide animation widget.
import 'package:flutter/material.dart';

class SlideAnimation extends StatelessWidget {
  final Widget child;
  final int duration;
  final Offset beginOffset;

  const SlideAnimation({
    super.key,
    required this.child,
    this.duration = 600,
    this.beginOffset = const Offset(0, 0.2),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      tween: Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ),
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            value.dx * MediaQuery.of(context).size.width,
            value.dy * MediaQuery.of(context).size.height,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}