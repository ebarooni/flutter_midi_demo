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
  int _currentTabIndex = 0;
  Future<List<MidiDevice>?> _availableDevices = MidiCommand().devices;
  late List<Widget> _tabs;

  void _changeTabView(int changedTabIndex) {
    setState(() {
      _currentTabIndex = changedTabIndex;
    });
  }

  void _refreshListOfMidiDevices() {
    setState(() {
      _availableDevices = MidiCommand().devices;
    });
  }

  @override
  void initState() {
    super.initState();
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
        title: const Text('Flutter Midi Demo'),
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
