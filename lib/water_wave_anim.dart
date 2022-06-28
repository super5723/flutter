import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/24
class WaterWavePage extends StatefulWidget {
  const WaterWavePage({Key? key}) : super(key: key);

  @override
  _WaterWavePageState createState() => _WaterWavePageState();

  static open(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const WaterWavePage();
    }));
  }
}

class _WaterWavePageState extends State<WaterWavePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WaterWavePage'),
      ),
      body: Center(
        child: Container(
          width: 300,
          height: 300,
          color: Colors.blueAccent,
          child: WaveWidget(
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}

class WaveWidget extends StatefulWidget {
  final int waveAnimDuration;
  final double width;
  final double height;

  const WaveWidget({
    Key? key,
    this.waveAnimDuration = 3000,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WaveWidgetState();
  }
}

class _WaveWidgetState extends State<WaveWidget> with TickerProviderStateMixin {
  late Animation _waveAnimation1;
  late Animation _waveAnimation2;
  late AnimationController _waveController1;
  late AnimationController _waveController2;
  double _maxWaveRadius = 0;

  @override
  void initState() {
    super.initState();
    _initWaveAnim();
    _startWaveAnim();
  }

  _initWaveAnim() {
    _maxWaveRadius = min(widget.width, widget.height);
    _waveController1 = AnimationController(duration: Duration(milliseconds: widget.waveAnimDuration), vsync: this);
    _waveController2 = AnimationController(duration: Duration(milliseconds: widget.waveAnimDuration), vsync: this);
    _waveAnimation1 =
        Tween(begin: 0.0, end: _maxWaveRadius).animate(CurvedAnimation(parent: _waveController1, curve: Curves.linear));
    _waveAnimation2 =
        Tween(begin: 0.0, end: _maxWaveRadius).animate(CurvedAnimation(parent: _waveController2, curve: Curves.linear));
    _waveController1.addListener(() {
      if (_waveAnimation1.value > _maxWaveRadius / 2 && !_waveController2.isAnimating) {
        _waveController2.repeat();
      }
      _refresh.call();
    });
    _waveController2.addListener(_refresh);
  }

  _startWaveAnim() {
    _waveController1.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
        ),
        PositionedDirectional(
          end: -(_waveAnimation1.value),
          bottom: -(_waveAnimation1.value),
          child: ClipOval(
            child: Container(
              width: _waveAnimation1.value * 2,
              height: _waveAnimation1.value * 2,
              color: Colors.yellow.withOpacity((_maxWaveRadius - _waveAnimation1.value) / _maxWaveRadius),
            ),
          ),
        ),
        PositionedDirectional(
          end: -(_waveAnimation2.value),
          bottom: -(_waveAnimation2.value),
          child: ClipOval(
            child: Container(
              width: _waveAnimation2.value * 2,
              height: _waveAnimation2.value * 2,
              color: Colors.yellow.withOpacity((_maxWaveRadius - _waveAnimation2.value) / _maxWaveRadius),
            ),
          ),
        ),
        PositionedDirectional(
          top: 12,
          start: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3),
              Text(
                'hahaha',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _waveController1.dispose();
    _waveController2.dispose();
    super.dispose();
  }
}
