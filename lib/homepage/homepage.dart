import 'dart:async';
import 'package:flutter/material.dart';
import './device_connection_indicator/device_connection_indicator.dart';
import '../devices/devices.dart';
import '../settings/settings.dart';
import '../midi_controller/midi_controller.dart';
import './bottom_nav_bar/bottom_nav_bar.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final MidiCommand _midiCommand = MidiCommand();
  late StreamSubscription<String>? _setupSubscription;
  late StreamSubscription<BluetoothState> _bluetoothStateSubscription;
  int _currentTabIndex = 0;
  bool _didAskForBluetoothPermission = false;

  @override
  void initState() {
    super.initState();

    _setupSubscription = _midiCommand.onMidiSetupChanged?.listen((data) async {
      print("setup changed $data");
      setState(() {});
    });

    _bluetoothStateSubscription =
        _midiCommand.onBluetoothStateChanged.listen((data) {
      print("bluetooth state change $data");
      setState(() {});
    });
  }

  @override
  void dispose() {
    _setupSubscription?.cancel();
    _bluetoothStateSubscription.cancel();
    super.dispose();
  }

  void _changeTabView(int changedTabIndex) {
    setState(() {
      _currentTabIndex = changedTabIndex;
    });
  }

  Future<void> connectToMidiDevice(MidiDevice device) async {
    await _midiCommand.connectToDevice(device);
    _midiCommand.stopScanningForBluetoothDevices();
    setState(() {});
  }

  void disconnectMidiDevice(MidiDevice device) {
    _midiCommand.disconnectDevice(device);
    _refreshListOfMidiDevices();
    setState(() {});
  }

  void _refreshListOfMidiDevices() async {
    await _informUserAboutBluetoothPermissions(context);
    if (_midiCommand.bluetoothState == BluetoothState.poweredOn) {
      await _midiCommand.startScanningForBluetoothDevices().catchError((err) {
        print("Error $err");
      });
    } else {
      await _midiCommand.startBluetoothCentral();
      await _midiCommand.waitUntilBluetoothIsInitialized();
    }
    setState(() {});
  }

  List<Widget> _updateAppBarIcon() {
    if (_currentTabIndex == 0) {
      return [
        DeviceConnectionIndicator(devices: _midiCommand.devices)
      ];
    } else if (_currentTabIndex == 1) {
      return [
        IconButton(
          onPressed: () => _refreshListOfMidiDevices(),
          icon: const Icon(Icons.refresh),
        )
      ];
    } else {
      return [];
    }
  }

  Future<void> _informUserAboutBluetoothPermissions(
    BuildContext context,
  ) async {
    if (_didAskForBluetoothPermission) {
      return;
    } else {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                  'Please grant bluetooth permissions to discover BLE MIDI devices'),
              content: const Text(
                  'Next dialog might ask you for bluetooth permissions. Please grant bluetooth permission to make bluetooth MIDI possible.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                )
              ],
            );
          });
      setState(() {
        _didAskForBluetoothPermission = true;
      });
      return;
    }
  }

  Widget _updateAppBarTitle() {
    if (_currentTabIndex == 0) {
      return const Text('MIDI Messages Stream');
    } else if (_currentTabIndex == 1) {
      return const Text('Available MIDI Devices');
    } else {
      return const Text('Settings');
    }
  }

  Widget renderTab() {
    Widget widgetToRender;
    if (_currentTabIndex == 0) {
      widgetToRender = MidiController(
        midiDataStream: _midiCommand.onMidiDataReceived,
        openDevicesTab: _changeTabView,
      );
    } else if (_currentTabIndex == 1) {
      widgetToRender = Devices(
        availableDevices: _midiCommand.devices,
        disconnectDevice: disconnectMidiDevice,
        connectToDevice: connectToMidiDevice,
        refreshDeviceList: _refreshListOfMidiDevices,
      );
    } else {
      widgetToRender = Settings();
    }
    return widgetToRender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _updateAppBarTitle(),
        centerTitle: false,
        actions: _updateAppBarIcon(),
      ),
      body: renderTab(),
      bottomNavigationBar: BottomNavBar(
        updateView: _changeTabView,
      ),
    );
  }
}
