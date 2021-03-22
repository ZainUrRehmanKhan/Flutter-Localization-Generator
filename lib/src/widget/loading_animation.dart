import 'package:flutter/material.dart';

enum LoadingAnimationType{
  simple,
  heavy
}

class LoadingAnimation extends StatefulWidget {
  final Duration duration;
  final double size;
  final Color color;
  final bool reverse;
  final LoadingAnimationType type;

  LoadingAnimation({this.duration = const Duration(milliseconds: 1000), @required this.size, @required this.color, this.reverse = false, this.type = LoadingAnimationType.simple});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: widget.reverse);
  }

  @override
  Widget build(BuildContext context) {
    _scaleAnimation = Tween(end: 1.0, begin: 0.0).animate(
      CurvedAnimation(curve: Curves.easeInOut, parent: _controller),
    );
    _rotateAnimation = Tween(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(curve: Curves.linear, parent: _controller),
    );

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
              child: Container(
            height: widget.size,
            width: widget.size,
            child: Transform.rotate(
              angle: _rotateAnimation.value * 0.0174533,
              child: Stack(
                children: [
                  Positioned(
                      top: 0.0,
                      child: customCircle(
                          scaleAnimationValue: 1.0 - _scaleAnimation.value)),
                  Positioned(
                      bottom: 0.0,
                      child: customCircle(
                          scaleAnimationValue: _scaleAnimation.value)),
                  if(widget.type == LoadingAnimationType.heavy)
                    Positioned(
                        left: 0.0,
                        child: customCircle(
                            scaleAnimationValue: 1.0 - _scaleAnimation.value))
                  ,
                  if(widget.type == LoadingAnimationType.heavy)
                  Positioned(
                      right: 0.0,
                      child: customCircle(
                          scaleAnimationValue: _scaleAnimation.value)),
                ],
              ),
            ),
          ));
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget customCircle({double scaleAnimationValue}) {
    return Container(
        height: widget.size * scaleAnimationValue,
        width: widget.size * scaleAnimationValue,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
        ));
  }
}
