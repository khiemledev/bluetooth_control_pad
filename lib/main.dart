import 'package:bluetooth_control_path/screens/control_pad_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.name,
      routes: {
        HomePage.name: (context) => const HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ControlPadPage.name) {
          final device = settings.arguments as BluetoothDevice;
          return MaterialPageRoute(
            builder: (context) {
              return ControlPadPage(device: device);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
