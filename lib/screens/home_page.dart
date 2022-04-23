import 'package:bluetooth_control_path/screens/control_pad_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  static const String name = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];

  Future<Map<Permission, PermissionStatus>> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
    return statuses;
  }

  Future<bool> _isBluetoothAvailable() async {
    var blueSta = await Permission.bluetooth.status;
    var blueScan = await Permission.bluetoothScan.status;
    var blueConn = await Permission.bluetoothConnect.status;
    if (blueSta.isDenied && (blueScan.isDenied || blueConn.isDenied)) {
      return false;
    }
    return true;
  }

  Future<void> _scanBluetoothDevices() async {
    bool bluetoothAvailable = await _isBluetoothAvailable();
    if (!bluetoothAvailable) {
      await _requestPermissions();
      bluetoothAvailable = await _isBluetoothAvailable();
      if (!bluetoothAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission not granted!'),
          ),
        );
      }
    }
    setState(() {
      devicesList = [];
    });
    flutterBlue.startScan(
      timeout: const Duration(seconds: 10),
      allowDuplicates: false,
      scanMode: ScanMode.lowPower,
    );
    flutterBlue.scanResults.listen((event) {
      for (ScanResult r in event) {
        if (!devicesList.contains(r.device) &&
            r.device.type != BluetoothDeviceType.unknown) {
          setState(() {
            devicesList = [...devicesList, r.device];
          });
        }
      }
    });
    flutterBlue.stopScan();
  }

  Widget _buildList(List<BluetoothDevice> devices) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, idx) => ListTile(
        title: Text(
          '${devices[idx].id} - ${devices[idx].name} - ${devices[idx].type.name}',
        ),
        onTap: () => Navigator.pushNamed(
          context,
          ControlPadPage.name,
          arguments: devices[idx],
        ),
      ),
    );
  }

  @override
  void initState() {
    _scanBluetoothDevices();
    super.initState();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth control pad'),
      ),
      body: RefreshIndicator(
        onRefresh: _scanBluetoothDevices,
        child: _buildList(devicesList),
      ),
    );
  }
}
