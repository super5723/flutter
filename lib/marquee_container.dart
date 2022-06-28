import 'package:flutter/material.dart';

class MarqueeContainerPage extends StatefulWidget {
  const MarqueeContainerPage({Key? key}) : super(key: key);

  @override
  _MarqueeContainerPageState createState() => _MarqueeContainerPageState();

  static open(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const MarqueeContainerPage();
    }));
  }
}

class _MarqueeContainerPageState extends State<MarqueeContainerPage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('title')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _controller.reset();
                  // _controller.forward();
                  _controller.repeat();
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.all(15),
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(6)),
                  child: const Text('start'),
                ),
              ),
              const SizedBox(
                width: 40,
              ),
              GestureDetector(
                onTap: () {
                  _controller.stop();
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.all(15),
                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(6)),
                  child: const Text('stop'),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.green,
            //SlideTransition 用于执行平移动画
            child: MarqueeContainer(
              controller: _controller,
              child: Container(
                width: 250,
                height: 50,
                color: Colors.red,
              ),
              // child: Row(
              //   mainAxisSize: MainAxisSize.min,
              //   children: const [
              //     Text('1111111'),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     Text('22222222'),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     Text('33333333'),
              //     SizedBox(
              //       width: 30,
              //     ),
              //     Text('4444444'),
              //   ],
              // ),
            ),
          )
        ],
      ),
    );
  }
}

class MarqueeContainer extends StatefulWidget {
  final Widget child;
  final AnimationController controller;
  final bool autoPlay;
  const MarqueeContainer({Key? key, required this.child, required this.controller, this.autoPlay = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MarqueeContainerState();
  }
}

class _MarqueeContainerState extends State<MarqueeContainer> with TickerProviderStateMixin {
  final GlobalKey _contentKey = GlobalKey();
  late Animation<Offset> _animation;
  double _parentWidth = 0;
  double _contentWidth = -1;

  @override
  void initState() {
    super.initState();
    _animation = Tween(begin: const Offset(-1, 0), end: Offset.zero).animate(widget.controller);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _parentWidth = constraints.maxWidth;
      if (_contentWidth == -1) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          RenderBox? renderBox = _contentKey.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            _contentWidth = renderBox!.size.width;
            _animation = Tween(begin: Offset(_parentWidth / _contentWidth, 0), end: const Offset(-1, 0))
                .animate(widget.controller);
            widget.controller.addListener(() {
              setState(() {});
            });
          }
          bool needPlay = widget.autoPlay || _contentWidth > _parentWidth;
          if (needPlay) {
            widget.controller.repeat();
          }
        });
      }
      return ClipRect(
        child: OverflowBox(
            alignment: AlignmentDirectional.topStart,
            maxWidth: double.infinity,
            minWidth: 0,
            maxHeight: double.infinity,
            minHeight: 0,
            child: SlideTransition(
              key: _contentKey,
              position: _animation,
              child: widget.child,
            )),
      );
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
