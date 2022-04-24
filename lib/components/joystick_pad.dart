import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JoystickPad extends StatefulWidget {
  final double iconSize;
  final double boundary;
  final void Function(String) onUpdate;

  const JoystickPad({
    Key? key,
    this.iconSize = 60,
    this.boundary = 255,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<JoystickPad> createState() => _JoystickPadState();
}

class _JoystickPadState extends State<JoystickPad> {
  final GlobalKey _containerKey = GlobalKey();

  Offset _calculateOffset(Offset localPosition) {
    final renderBox =
        _containerKey.currentContext?.findRenderObject()! as RenderBox;
    Size size = renderBox.size;
    Offset boxOffset = renderBox.localToGlobal(
      Offset(size.width / 2, size.height / 2),
    );
    Offset offset = localPosition - boxOffset;
    offset = Offset(
      min(1.0, max(-1, offset.dx / (size.width / 2))),
      min(1.0, max(-1, offset.dy / (size.height / 2))),
    );
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        key: _containerKey,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(),
          color: Colors.blue,
        ),
        width: widget.boundary,
        height: widget.boundary,
        child: Center(
          child: Draggable(
            dragAnchorStrategy: childDragAnchorStrategy,
            onDragUpdate: (details) {
              Offset offset = _calculateOffset(details.localPosition);
              String x = offset.dx.toStringAsFixed(1);
              String y = offset.dy.toStringAsFixed(1);
              widget.onUpdate('$x $y');
            },
            onDragEnd: (details) {
              Future.delayed(
                const Duration(milliseconds: 200),
                () => widget.onUpdate('0.0 0.0'),
              );
            },
            child: FaIcon(
              FontAwesomeIcons.circleDot,
              size: widget.iconSize,
            ),
            childWhenDragging: FaIcon(
              FontAwesomeIcons.circleStop,
              size: widget.iconSize,
            ),
            feedback: FaIcon(
              FontAwesomeIcons.solidCircleDot,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
