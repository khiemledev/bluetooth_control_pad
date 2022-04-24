import 'dart:convert';
import 'dart:developer';

import 'package:bluetooth_control_path/components/button_control.dart';
import 'package:bluetooth_control_path/components/joystick_pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ControlPadPage extends StatefulWidget {
  static const String name = 'control_pad_page';

  final BluetoothDevice device;

  const ControlPadPage({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  State<ControlPadPage> createState() => _ControlPadPageState();
}

class _ControlPadPageState extends State<ControlPadPage> {
  BluetoothCharacteristic? writeChar;
  bool writing = false;

  void _setup() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  void _reset() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
  }

  void _connectBluetooth() async {
    await for (BluetoothDeviceState state in widget.device.state) {
      if (state != BluetoothDeviceState.connected) {
        await widget.device.connect();
      }
      var services = await widget.device.discoverServices();
      for (var blueService in services) {
        if (writeChar != null) break;
        for (var blueChar in blueService.characteristics) {
          if (blueChar.properties.write) {
            setState(() {
              writeChar = blueChar;
            });
            _showSnackBarMessage('Device connected!');
            break;
          }
        }
      }
    }
  }

  void _disconnectBluetooth() async {
    await widget.device.disconnect();
  }

  void _showSnackBarMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Widget _buildControlPad() {
    return Row(
      children: [
        Expanded(
          child: JoystickPad(
            onUpdate: (String data) async {
              if (writeChar != null && !writing) {
                try {
                  writing = true;
                  await writeChar!.write(utf8.encode(data));
                  writing = false;
                } catch (e) {
                  log(e.toString());
                }
              }
            },
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(38.0),
            child: ButtonControl(
              type: ButtonControlType.abxy,
              onPress: (String data) async {
                if (writeChar != null && !writing) {
                  try {
                    writing = true;
                    await writeChar!.write(utf8.encode(data));
                    writing = false;
                  } catch (e) {
                    log(e.toString());
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _setup();
    _connectBluetooth();
  }

  @override
  void dispose() {
    _disconnectBluetooth();
    _reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: widget.device.state,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            _showSnackBarMessage('Cannot read bluetooth connection state');
            return Container();
          }
          if (snapshot.hasData) {
            if (snapshot.data == BluetoothDeviceState.connected) {
              return _buildControlPad();
            }
          }
          return Center(
            child: Text('Connection state: ${snapshot.data.toString()}'),
          );
        },
      ),
    );
  }
}
