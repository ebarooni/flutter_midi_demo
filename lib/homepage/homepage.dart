import 'package:flutter/material.dart';
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
  late Future<List<MidiDevice>?> _availableDevices;
  late List<Widget> _tabs;
  int _currentTabIndex = 0;
  bool _didAskForBluetoothPermission = false;

  void _changeTabView(int changedTabIndex) {
    setState(() {
      _currentTabIndex = changedTabIndex;
    });
  }

  void _refreshListOfMidiDevices() async {
    await _informUserAboutBluetoothPermissions(context);
    if (_midiCommand.bluetoothState == BluetoothState.poweredOn) {
      _midiCommand.startScanningForBluetoothDevices().catchError((err) {
        print("Error $err");
      });
    } else {
      await _midiCommand.startBluetoothCentral();
      await _midiCommand.waitUntilBluetoothIsInitialized();
    }
    setState(() {
      _availableDevices = _midiCommand.devices;
    });
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
      _didAskForBluetoothPermission = true;
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

  @override
  void initState() {
    super.initState();
    _availableDevices = _midiCommand.devices;
    _tabs = [
      const MidiController(),
      Devices(availableDevices: _availableDevices),
      Settings(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _updateAppBarTitle(),
        centerTitle: false,
        leading: const FlutterLogo(
          style: FlutterLogoStyle.markOnly,
          curve: Curves.easeIn,
        ),
        actions: _currentTabIndex == 1
            ? [
                IconButton(
                  onPressed: () => _refreshListOfMidiDevices(),
                  icon: const Icon(Icons.refresh),
                )
              ]
            : [],
      ),
      body: _tabs.elementAt(_currentTabIndex),
      bottomNavigationBar: BottomNavBar(
        updateView: _changeTabView,
      ),
    );
  }
}
