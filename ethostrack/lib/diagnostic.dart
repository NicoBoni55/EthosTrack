import 'package:flutter/material.dart';

class DebugSizeWidget extends StatelessWidget {
  final Widget child;

  const DebugSizeWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: MediaQuery.of(context).padding.top,
          left: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Widht: ${MediaQuery.of(context).size.width.toStringAsFixed(1)}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'PixelRatio: ${MediaQuery.of(context).devicePixelRatio}',
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}