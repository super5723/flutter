import 'dart:math';

import 'package:flutter/material.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/27
class TransformTestPage extends StatefulWidget {
  const TransformTestPage({Key? key}) : super(key: key);

  @override
  State<TransformTestPage> createState() => _TransformTestPageState();

  static open(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const TransformTestPage();
    }));
  }
}

class _TransformTestPageState extends State<TransformTestPage> with TickerProviderStateMixin {
  Matrix4 _matrix4One = Matrix4.identity();
  Matrix4 _matrix4Two = Matrix4.identity();
  late AnimationController _controller1;
  late Animation _animation1;
  late AnimationController _controller2;
  late Animation _animation2;
  int animCount = 3;

  @override
  void initState() {
    super.initState();
    _matrix4One.translate(150.0, 250.0);
    _matrix4Two.translate(150.0, 250.0);
    _controller1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller1, curve: Curves.easeOut));
    _animation1.addListener(() {
      _refreshTransform(_matrix4One, _animation1.value);
      if (_animation1.value > 0.4) {
        if (!_controller2.isAnimating) {
          _controller2.reset();
          _controller2.forward();
        }
        setState(() {});
      }
    });

    _controller2 = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeOut));
    _animation2.addListener(() {
      _refreshTransform(_matrix4Two, _animation2.value);
      setState(() {});
    });
    _animation2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (animCount > 0) {
          _controller1.reset();
          _controller1.forward();
        }
      }
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      animCount--;
      _controller1.forward();
    });
  }

  _refreshTransform(Matrix4 matrix4, double t) {
    double offsetX = pow(1 - t, 2) * _getP0().dx + 2 * t * (1 - t) * _getP1().dx + pow(t, 2) * _getP2().dx;
    double offsetY = pow(1 - t, 2) * _getP0().dy + 2 * t * (1 - t) * _getP1().dy + pow(t, 2) * _getP2().dy;

    matrix4
      ..setTranslationRaw(offsetX, offsetY, 0)
      ..setRotationZ(pi / 4 * t)
      ..scale(1.0 - t, 1.0 - t);
  }

  Offset _getP0() {
    double x = 150;
    double y = 250;
    return Offset(x, y);
  }

  Offset _getP1() {
    double x = 160;
    double y = 60;
    return Offset(x, y);
  }

  Offset _getP2() {
    double x = 250;
    double y = 50;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('TransformTestPage'),
        ),
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            color: Colors.lightGreenAccent,
            child: Stack(
              children: [
                Opacity(
                  opacity: 1.0 - _animation1.value,
                  child: Transform(
                    transform: _matrix4One,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1.0 - _animation2.value,
                  child: Transform(
                    transform: _matrix4Two,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
