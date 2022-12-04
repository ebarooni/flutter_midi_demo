import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final List<Widget> settingItems = [
    ListTile(
      leading: const Icon(Icons.computer),
      title: const Text('Operating System'),
      subtitle: Text(Platform.operatingSystem),
    ),
    ListTile(
      leading: const Icon(Icons.language),
      title: const Text('System Locale'),
      subtitle: Text(Platform.localeName),
    ),
    const ListTile(
      leading: Icon(Icons.tag),
      title: Text('App Version'),
      subtitle: Text('0.0.1'),
    ),
    const ListTile(
      leading: Icon(Icons.flutter_dash),
      title: Text('Flutter Version'),
      subtitle: Text('3.0.3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: ((context, index) => settingItems.elementAt(index)),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: settingItems.length,
    );
  }
}
