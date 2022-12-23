import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({
    required this.source,
    required this.timestamp,
    required this.data,
    super.key,
  });

  final MidiDevice source;
  final int timestamp;
  final Uint8List data;

  @override
  Widget build(BuildContext context) {
    var detailsList = [
      ListTile(
        leading: const Icon(Icons.piano_off_rounded),
        title: Text(source.name),
        subtitle: Text('ID: $source.id'),
      ),
      ListTile(
        leading: const Icon(Icons.schedule_rounded),
        title: const Text('Timestamp'),
        subtitle: Text(timestamp.toString()),
      ),
      ListTile(
        leading: const Icon(Icons.music_note_rounded),
        title: const Text('Original event <type, key, velocity>'),
        subtitle: Text(data.toString()),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event details'),
      ),
      body: ListView.separated(
        itemBuilder: ((context, index) => detailsList.elementAt(index)),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: detailsList.length,
      ),
    );
  }
}
