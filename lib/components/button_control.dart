import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum ButtonControlType {
  abxy,
  arrow,
}

class ButtonControlData {
  final String? a;
  final String? b;
  final String? x;
  final String? y;
  final String? left;
  final String? right;
  final String? up;
  final String? down;

  ButtonControlData({
    this.a = "a",
    this.b = "b",
    this.x = "x",
    this.y = "y",
    this.left = "left",
    this.right = "right",
    this.up = "up",
    this.down = "down",
  });
}

class ButtonControl extends StatelessWidget {
  final ButtonControlType type;
  final void Function(String)? onPress;
  final ButtonControlData? buttonControlData;

  const ButtonControl({
    Key? key,
    this.type = ButtonControlType.abxy,
    required this.onPress,
    this.buttonControlData,
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
                              ? buttonControlData!.y
                              : buttonControlData!.up)
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
                              ? buttonControlData!.x
                              : buttonControlData!.left)
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
                              ? buttonControlData!.b
                              : buttonControlData!.right)
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
                                ? buttonControlData!.a
                                : buttonControlData!.down)
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
