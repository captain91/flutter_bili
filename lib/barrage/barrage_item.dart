import 'package:flutter/material.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  const BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
