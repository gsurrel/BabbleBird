import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  final List<Color> _colors = List<Color>.generate(
    100,
    (index) => Color(
      (Random().nextDouble() * 0xFFFFFF).toInt(),
    ).withOpacity(1.0),
  );

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorScrollBar(controller: _controller, colors: _colors);
  }
}

class ColorScrollBar extends StatelessWidget {
  final ScrollController controller;
  final List<Color> colors;

  const ColorScrollBar({
    super.key,
    required this.controller,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _ScrollBarPainter(colors: colors),
      child: Scrollbar(
        controller: controller,
        child: ListView.builder(
          controller: controller,
          itemCount: colors.length,
          itemBuilder: (context, index) {
            return Container(
              height: 30.0 + Random().nextInt(270),
              color: colors[index],
            );
          },
        ),
      ),
    );
  }
}

class _ScrollBarPainter extends CustomPainter {
  final List<Color> colors;

  _ScrollBarPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double dy = 0;
    final paint = Paint();

    for (var color in colors) {
      paint.color = color;
      final rect = Rect.fromLTWH(
        size.width * 0.9,
        dy,
        size.width * 0.05,
        size.height / colors.length,
      );
      canvas.drawRect(rect, paint);
      dy += size.height / colors.length;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
