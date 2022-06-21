import 'dart:math';

import 'package:flutter/material.dart';

/// @Author super5723
/// @Description
/// @Date 2022/6/13
class RoundedRectProgressPainter extends CustomPainter {
  double radius;
  //范围从0-1
  double progress;
  double strokeWidth;
  Color color;

  RoundedRectProgressPainter(
      {required this.radius, required this.strokeWidth, this.progress = 0, this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    radius = radius > size.shortestSide / 2 ? size.shortestSide / 2 : radius;
    progress = progress > 1 ? 1 : progress;
    final double width = size.width;
    final double height = size.height;
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (progress > 0) {
      Path path = Path();
      double length = progress * (width + height) * 2;
      path.moveTo(width / 2, 0);
      if (length <= width / 2 - radius) {
        addTopRightLine(path, width / 2 + length, 0);
      } else if (length <= width / 2 + radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi * (length - (width / 2 - radius)) / (2 * radius));
      } else if (length <= width / 2 + height - radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, length - width / 2);
      } else if (length <= width / 2 + height + radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(
            path, width - radius, height - radius, 0.5 * pi * (length - width / 2 - (height - radius)) / (2 * radius));
      } else if (length <= width / 2 + height + width - radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(path, width - radius, height - radius, 0.5 * pi);
        addBottomLine(path, width - (length - width / 2 - height), height);
      } else if (length <= 1.5 * width + height + radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(path, width - radius, height - radius, 0.5 * pi);
        addBottomLine(path, radius, height);
        addBottomLeftArc(
            path, radius, height - radius, 0.5 * pi * (length - (width / 2 + height + width - radius)) / (radius * 2));
      } else if (length <= 1.5 * width + 2 * height - radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(path, width - radius, height - radius, 0.5 * pi);
        addBottomLine(path, radius, height);
        addBottomLeftArc(path, radius, height - radius, 0.5 * pi);
        addLeftLine(path, 0, height - (length - (1.5 * width + height)));
      } else if (length <= height * 2 + 1.5 * width + radius) {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(path, width - radius, height - radius, 0.5 * pi);
        addBottomLine(path, radius, height);
        addBottomLeftArc(path, radius, height - radius, 0.5 * pi);
        addLeftLine(path, 0, radius);
        addTopLeftArc(path, radius, radius, 0.5 * pi * (length - (1.5 * width + 2 * height - radius)) / (radius * 2));
      } else {
        double rightTopArcX = width - radius;
        double rightTopArcY = radius;
        addTopRightLine(path, rightTopArcX, 0);
        addTopRightArc(path, rightTopArcX, rightTopArcY, 0.5 * pi);
        addRightLine(path, width, height - radius);
        addBottomRightArc(path, width - radius, height - radius, 0.5 * pi);
        addBottomLine(path, radius, height);
        addBottomLeftArc(path, radius, height - radius, 0.5 * pi);
        addLeftLine(path, 0, radius);
        addTopLeftArc(path, radius, radius, 0.5 * pi);
        addTopLeftLine(path, width / 2 - ((width + height) * 2 - length), 0);
      }
      canvas.drawPath(path, paint);
    }
  }

  addTopRightLine(Path path, double x, double y) {
    path.lineTo(x, y);
  }

  addTopRightArc(Path path, double arcX, double arcY, double angle) {
    path.arcTo(Rect.fromCircle(center: Offset(arcX, arcY), radius: radius), 1.5 * pi, angle, true);
  }

  addRightLine(Path path, double x, double y) {
    path.lineTo(x, y);
  }

  addBottomRightArc(Path path, double arcX, double arcY, double angle) {
    path.arcTo(Rect.fromCircle(center: Offset(arcX, arcY), radius: radius), 0, angle, true);
  }

  addBottomLine(Path path, double x, double y) {
    path.lineTo(x, y);
  }

  addBottomLeftArc(Path path, double arcX, double arcY, double angle) {
    path.arcTo(Rect.fromCircle(center: Offset(arcX, arcY), radius: radius), 0.5 * pi, angle, true);
  }

  addLeftLine(Path path, double x, double y) {
    path.lineTo(x, y);
  }

  addTopLeftArc(Path path, double arcX, double arcY, double angle) {
    path.arcTo(Rect.fromCircle(center: Offset(arcX, arcY), radius: radius), pi, angle, true);
  }

  addTopLeftLine(Path path, double x, double y) {
    path.lineTo(x, y);
  }

  @override
  bool shouldRepaint(RoundedRectProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
