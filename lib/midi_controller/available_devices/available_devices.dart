import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class AvailableDevices extends StatelessWidget {
  final Future<List<MidiDevice>?> availableDevices;

  const AvailableDevices({required this.availableDevices, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availableDevices,
      builder: (context, snapshot) {
        Widget children;
        if (snapshot.hasData) {
          children = DataTable(
            columns: const [
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'ID',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
              DataColumn(
                label: Expanded(
                  child: Text(
                    'Type',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ],
            rows: (snapshot.data as List<MidiDevice>).map((device) {
              return DataRow(cells: [
                DataCell(Text(device.name)),
                DataCell(Text(device.id)),
                DataCell(Text(device.type))
              ]);
            }).toList(),
          );
        } else {
          children = const Text('No info');
        }
        return children;
      },
    );
  }
}
