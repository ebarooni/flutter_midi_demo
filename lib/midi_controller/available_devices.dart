import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class AvailableDevices extends StatefulWidget {
  const AvailableDevices({Key? key}) : super(key: key);

  @override
  State<AvailableDevices> createState() => _AvailableDevicesState();
}

class _AvailableDevicesState extends State<AvailableDevices> {
  Future<List<MidiDevice>?> _availableDevices = MidiCommand().devices;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _availableDevices = MidiCommand().devices;
              });
            },
            child: const Text('Show available MIDI devices'),
          ),
          FutureBuilder(
            future: _availableDevices,
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
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text((snapshot.data as List<MidiDevice?>)
                            .elementAt(0)!
                            .name)),
                        DataCell(Text((snapshot.data as List<MidiDevice?>)
                            .elementAt(0)!
                            .id)),
                        DataCell(Text((snapshot.data as List<MidiDevice?>)
                            .elementAt(0)!
                            .type)),
                      ],
                    ),
                  ],
                );
              } else {
                children = const Text('No info');
              }
              return children;
            },
          ),
        ],
      ),
    );
  }
}
