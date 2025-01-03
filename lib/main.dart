import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // For rootBundle

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatefulWidget {
  @override
  _XylophoneAppState createState() => _XylophoneAppState();
}

class _XylophoneAppState extends State<XylophoneApp> {
  final List<int> _playedNotes = []; // Stores the sequence of played notes

  void playSound(int soundNumber) async {
    final player = AudioPlayer();
    await player.play(AssetSource('note$soundNumber.wav'));
    _savePlayedNoteToMemory(soundNumber);
  }

  void _savePlayedNoteToMemory(int soundNumber) {
    setState(() {
      _playedNotes.add(soundNumber); // Add the note to the sequence
    });
  }

  void handlePlayback() {
    if (_playedNotes.isEmpty) {
      print("No tune recorded.");
      return;
    }
    _playBackSequence();
  }

  Future<void> _playBackSequence() async {
    final player = AudioPlayer();
    for (int note in _playedNotes) {
      await player.play(AssetSource('note$note.wav'));
      await Future.delayed(
          const Duration(milliseconds: 500)); // Delay between notes
    }
  }

  void resetSequence() {
    setState(() {
      _playedNotes.clear(); // Clear the sequence
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Valentina Sounds')),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Xylophone keys
              ...List.generate(6, (index) {
                return Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.primaries[index % Colors.primaries.length],
                      ),
                    ),
                    onPressed: () => playSound(index + 1),
                  ),
                );
              }),
              // Playback and reset buttons
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: handlePlayback,
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: const Text(
                        "Play Tune",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: resetSequence,
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text(
                        "Reset Tune",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
