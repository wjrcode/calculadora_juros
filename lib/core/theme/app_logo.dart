import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: AppLogoPainter()),
    );
  }
}

class AppLogoPainter extends CustomPainter {
  const AppLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    canvas.save();
    canvas.translate((size.width - side) / 2, (size.height - side) / 2);
    canvas.scale(side);

    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 1, 1),
      Paint()..color = AppColors.lime,
    );

    final calculator = Paint()..color = AppColors.teal;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(.17, .09, .66, .82),
        const Radius.circular(.09),
      ),
      calculator,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(.27, .19, .46, .23),
        const Radius.circular(.035),
      ),
      Paint()..color = AppColors.background,
    );

    final graph = Paint()
      ..color = AppColors.pink
      ..strokeWidth = .027
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final graphPath = Path()
      ..moveTo(.34, .34)
      ..lineTo(.44, .30)
      ..lineTo(.53, .34)
      ..lineTo(.66, .25);
    canvas.drawPath(graphPath, graph);

    final keyColors = [
      AppColors.lime,
      AppColors.lime,
      AppColors.pink,
      AppColors.lime,
      AppColors.lime,
      AppColors.lime,
      AppColors.lime,
      AppColors.lime,
      AppColors.lime,
    ];
    for (var index = 0; index < keyColors.length; index++) {
      final column = index % 3;
      final row = index ~/ 3;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(.28 + column * .16, .50 + row * .13, .10, .075),
          const Radius.circular(.018),
        ),
        Paint()..color = keyColors[index],
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AppLogoPainter oldDelegate) => false;
}