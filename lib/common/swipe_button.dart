import 'package:flutter/material.dart';

class SwipeOnOffButton extends StatefulWidget {
  final String timer;
  final double timerSize;
  final TextStyle timerStyle;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color disableBackgroundColor;
  final Color replaceBackgroundColor;
  final Color foregroundColor;
  final Color iconColor;
  final IconData leftIcon;
  final IconData rightIcon;
  final double iconSize;
  final String text;
  final TextStyle textStyle;
  final VoidCallback onConfirmation;
  final BorderRadius foregroundRadius;
  final BorderRadius backgroundRadius;
  final bool disable;

  const SwipeOnOffButton({
    Key? key,
    required this.timer,
    required this.timerSize,
    required this.timerStyle,
    this.height = 48.0,
    this.width = 300,
    required this.backgroundColor,
    required  this.disableBackgroundColor,
    required this.foregroundColor,
    required this.iconColor,
    required this.leftIcon,
    required this.text,
    required this.textStyle,
    required this.onConfirmation,
    required  this.foregroundRadius,
    required this.backgroundRadius,
    required this.rightIcon,
    required this.iconSize,
    required this.replaceBackgroundColor,
    this.disable = false,
  });

  @override
  State<StatefulWidget> createState() {
    return SwipeOnOffButtonState();
  }
}

class SwipeOnOffButtonState extends State<SwipeOnOffButton> {
  double _position = 0;
  int _duration = 0;
  bool _isSwipe = false;

  double getPosition() {
    if (widget.disable) _position = 0;
    if (_position < 0) {
      return 0;
    } else if (_position > widget.width - widget.height) {
      return widget.width - widget.height;
    } else {
      return _position;
    }
  }

  Color getColor() {
    if (!widget.disable) {
      if (_position > 0) {
        return widget.replaceBackgroundColor ;
      } else {
        return widget.backgroundColor;
      }
    } else {
      return widget.disableBackgroundColor ;
    }
  }

  void updatePosition(details) {
    if (!widget.disable) {
      if (details is DragEndDetails) {
        setState(() {
          _duration = 100;
          _position = _isSwipe ? widget.width : 0;
        });
      } else if (details is DragUpdateDetails) {
        setState(() {
          _duration = 0;
          _position = _isSwipe
              ? _position
              : details.localPosition.dx - (widget.height / 2);
        });
      }
    } else {
      _position = 0;
    }
  }

  void swipeReleased(details) {
    if (_position > widget.width - widget.height) {
      widget.onConfirmation();
      _isSwipe = true;
    }
    updatePosition(details);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.backgroundRadius ,
        color: !widget.disable
            ? widget.backgroundColor
            : Colors.black,
      ),
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            height: widget.height,
            width: getPosition() + widget.height,
            duration: Duration(milliseconds: _duration),
            curve: Curves.bounceOut,
            decoration: BoxDecoration(
                borderRadius: widget.backgroundRadius ,
                color: getColor()),
          ),
          Center(
            child: Text(
              widget.text ,
              style: widget.textStyle
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: _duration),
            curve: Curves.bounceOut,
            left: getPosition(),
            child: GestureDetector(
              onPanUpdate: (details) => updatePosition(details),
              onPanEnd: (details) => swipeReleased(details),
              child: !_isSwipe
                  ? Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  borderRadius: widget.foregroundRadius ,
                  color: widget.foregroundColor
                ),
                child: Icon(
                  widget.leftIcon,
                  color: widget.iconColor,
                  size: widget.iconSize ,
                ),
              )
                  : Container(
                height: widget.height,
                width: widget.height,
                decoration: BoxDecoration(
                  borderRadius: widget.foregroundRadius ,
                  color: widget.foregroundColor ,
                ),
                child: Icon(
                  widget.rightIcon ,
                  color: widget.iconColor,
                  size: widget.iconSize
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}