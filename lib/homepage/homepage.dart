import 'package:flutter/material.dart';
import 'package:flutter_midi_demo/settings/settings.dart';
import '../midi_controller/midi_controller.dart';
import './bottom_nav_bar/bottom_nav_bar.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentTabIndex = 0;
  final List<Widget> _tabs = const [
    MidiController(),
    Placeholder(
      color: Colors.pink,
    ),
    Settings(),
  ];

  void _changeTabView(int changedTabIndex) {
    setState(() {
      _currentTabIndex = changedTabIndex;
    });
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
      ),
      body: _tabs.elementAt(_currentTabIndex),
      bottomNavigationBar: BottomNavBar(
        updateView: _changeTabView,
      ),
    );
  }
}
