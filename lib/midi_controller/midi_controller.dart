import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import './event_details/event_details.dart';

class MidiController extends StatefulWidget {
  const MidiController({
    required this.midiDataStream,
    required this.openDevicesTab,
    Key? key,
  }) : super(key: key);

  final Stream<MidiPacket>? midiDataStream;
  final Function(int) openDevicesTab;

  @override
  State<MidiController> createState() => _MidiControllerState();
}

class _MidiControllerState extends State<MidiController> {
  late StreamSubscription<MidiPacket>? _midiEventSubscription;
  final List<MidiPacket> packetList = [];

  @override
  void initState() {
    super.initState();
    _midiEventSubscription = widget.midiDataStream?.listen((packet) {
      print(packet);
      setState(() {
        if (packetList.length > 30) {
          packetList.removeLast();
        }
        if ((packet.data.elementAt(0) > 127 &&
                packet.data.elementAt(0) < 160) ||
            packet.data.elementAt(0) == 176) {
          packetList.insert(0, packet);
        }
      });
    });
  }

  @override
  void dispose() {
    _midiEventSubscription?.cancel();
    super.dispose();
  }

  Widget selectIcon(int eventType) {
    if (eventType < 144 && eventType > 127) {
      return const Icon(Icons.music_off_rounded);
    } else if (eventType < 160 && eventType > 143) {
      return const Icon(Icons.music_note_rounded);
    } else {
      return const Icon(Icons.question_mark_rounded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return packetList.isEmpty
        ? Card(
            semanticContainer: true,
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
              ),
              leading: const CircularProgressIndicator(),
              isThreeLine: true,
              title: Text(
                'Waiting for MIDI events',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: const Text(
                  'Connect to a MIDI device if top right corner shows no devices are connected'),
            ),
          )
        : Column(
            children: [
              ListTile(
                iconColor: Colors.red,
                leading: const Icon(Icons.delete),
                title: const Text('Tap to empty the messages stream'),
                onTap: () {
                  setState(() {
                    packetList.clear();
                  });
                },
                tileColor: const Color.fromARGB(255, 247, 245, 245),
              ),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    var midiEvent = packetList.elementAt(index);
                    return ListTile(
                      leading: selectIcon(midiEvent.data.elementAt(0)),
                      title: Text(midiEvent.data.toString()),
                      trailing: Text(midiEvent.device.name),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EventDetails(
                            source: midiEvent.device,
                            timestamp: midiEvent.timestamp,
                            data: midiEvent.data,
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: packetList.length,
                  shrinkWrap: true,
                ),
              ),
            ],
          );
  }
}
