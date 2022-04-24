import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonControlType {
  abxy,
  arrow,
}

enum ButtonControlData {
  a,
  b,
  x,
  y,
  left,
  right,
  up,
  down,
}

class ButtonControl extends StatelessWidget {
  final ButtonControlType type;
  final void Function(String)? onPress;

  const ButtonControl({
    Key? key,
    this.type = ButtonControlType.abxy,
    required this.onPress,
  }) : super(key: key);

  Widget _buildButton({required IconData icon, void Function()? onPress}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade300,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: FaIcon(
          icon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildButton(
                icon: type == ButtonControlType.abxy
                    ? FontAwesomeIcons.y
                    : FontAwesomeIcons.angleUp,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.abxy
                              ? ButtonControlData.y
                              : ButtonControlData.up)
                          .index
                          .toString(),
                    );
                  }
                },
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                icon: type == ButtonControlType.abxy
                    ? FontAwesomeIcons.x
                    : FontAwesomeIcons.angleLeft,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.abxy
                              ? ButtonControlData.x
                              : ButtonControlData.left)
                          .index
                          .toString(),
                    );
                  }
                },
              ),
              Container(),
              _buildButton(
                icon: type == ButtonControlType.abxy
                    ? FontAwesomeIcons.b
                    : FontAwesomeIcons.angleRight,
                onPress: () {
                  if (onPress != null) {
                    onPress!(
                      (type == ButtonControlType.abxy
                              ? ButtonControlData.b
                              : ButtonControlData.right)
                          .index
                          .toString(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildButton(
                  icon: type == ButtonControlType.abxy
                      ? FontAwesomeIcons.a
                      : FontAwesomeIcons.angleDown,
                  onPress: () {
                    if (onPress != null) {
                      onPress!(
                        (type == ButtonControlType.abxy
                                ? ButtonControlData.a
                                : ButtonControlData.down)
                            .index
                            .toString(),
                      );
                    }
                  })
            ],
          ),
        ),
      ],
    );
  }
}
