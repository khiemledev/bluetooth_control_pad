import 'dart:convert';

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
    }
  }

  void _disconnectBluetooth() async {
    await widget.device.disconnect();
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
          return Center(
            child: Text(snapshot.data.toString()),
          );
        },
      ),
    );
  }
}
