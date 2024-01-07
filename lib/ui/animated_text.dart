import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  const AnimatedText({
    required this.text,
    required this.gradient,
    required this.style,
    super.key,
    this.notAnimatedText,
  });
  final String text;
  final String? notAnimatedText;
  final Gradient gradient;
  final TextStyle style;
  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  String deviceID = '';
  String tempDeviceID = '';
  bool animatedOpacity = false;
  @override
  Widget build(BuildContext context) {
    if (widget.notAnimatedText != null) {
      if (mounted && deviceID == '') {
        setState(() {
          deviceID = widget.notAnimatedText!;
        });
      }
      if (widget.text != '' &&
          widget.text != tempDeviceID &&
          widget.text != widget.notAnimatedText) {
        tempDeviceID = widget.text;
        animatedOpacity = true;
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              deviceID = widget.text;
              animatedOpacity = false;
            });
          }
        });
      }
    } else {
      if (widget.text != '' && widget.text != tempDeviceID) {
        tempDeviceID = widget.text;
        animatedOpacity = true;
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              deviceID = widget.text;
              animatedOpacity = false;
            });
          }
        });
      }
    }
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: Text(
            widget.text,
            style: widget.style,
          ),
        ),
        Text(
          deviceID,
          style: widget.style,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: animatedOpacity == false ? 0 : 1,
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF9000FF),
                  Color(0xFFDA52FF),
                  Color(0xFF9000FF),
                ],
              ).createShader(
                Rect.fromLTWH(
                  0,
                  0,
                  bounds.width,
                  bounds.height,
                ),
              ),
              child: Text(widget.text, style: widget.style),
            ),
          ),
        ),
      ],
    );
  }
}
