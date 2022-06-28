import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

/// @Author super5723
/// @Description
/// @Date 2022/6/13
class RoundedRectProgressPage extends StatefulWidget {
  const RoundedRectProgressPage({Key? key}) : super(key: key);

  @override
  State<RoundedRectProgressPage> createState() => _RoundedRectProgressPageState();

  static open(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return const RoundedRectProgressPage();
    }));
  }
}

class _RoundedRectProgressPageState extends State<RoundedRectProgressPage> {
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer(){
    _progress=0;
    _timer= Timer.periodic(const Duration(milliseconds: 500), (timer) {
      _progress += 0.01;
      if (_progress > 1) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RoundedRectProgressPage'),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  _timer?.cancel();
                  _startTimer();
                },
                child: Container(
                  padding: EdgeInsetsDirectional.all(15),
                  decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(6)),
                  child: Text('reset'),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                height: 300,
                width: 200,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(200, 300),
                      painter:
                      RoundedRectProgressPainter(radius: 20, strokeWidth: 8, progress: _progress, color: Colors.yellow),
                    ),
                    Text((_progress * 100.0).toStringAsFixed(2)),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }
}


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
