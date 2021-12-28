import 'package:audio_recorder_sample/api/SoundPlayer.dart';
import 'package:audio_recorder_sample/api/SoundRecorder.dart';
import 'package:audio_recorder_sample/widget/TimerWidget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Recorder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final timerController = TimerController();
  final recorder = SoundRecorder();
  final player = SoundPlayer();

  @override
  void initState() {
    super.initState();

    recorder.init();
    player.init();
  }

  @override
  void dispose() {
    player.dispose();
    recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Recoder"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            buildPlayer(),
            SizedBox(
              height: 16,
            ),
            buildStart(),
            SizedBox(
              height: 8,
            ),
            buildPlay()
          ],
        ),
      ),
    );
  }

  Widget buildPlay() {
    final isPlaying = player.isPlaying;
    final icon = isPlaying ? Icons.stop : Icons.play_arrow;
    final text = isPlaying ? 'Stop Playing' : 'Play Recording';

    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(175, 50),
            primary: Colors.white,
            onPrimary: Colors.black),
        onPressed: () async {
          await player.togglePlaying(whenFinished: () => setState(() {}));
          setState(() {});
        },
        icon: Icon(icon),
        label: Text(text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
  }

  Widget buildStart() {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red : Colors.yellow;
    final onPrimary = isRecording ? Colors.blue : Colors.red;

    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(175, 50), primary: primary, onPrimary: onPrimary),
        onPressed: () async {
          await recorder.toggleRecording();
          final isRecording = recorder.isRecording;

          setState(() {
            if (isRecording) {
              timerController.startTimer();
            } else {
              timerController.stopTimer();
            }
          });
        },
        icon: Icon(icon),
        label: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
  }

  Widget buildPlayer() {
    final text = recorder.isRecording ? 'Now Recording' : 'Press Start';
    final animate = recorder.isRecording;

    return AvatarGlow(
      endRadius: 140,
      animate: animate,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: CircleAvatar(
        radius: 100,
        backgroundColor: Colors.green,
        child: CircleAvatar(
          radius: 92,
          backgroundColor: Colors.indigo.shade900.withBlue(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mic,
                size: 32,
              ),
              TimerWidget(controller: timerController),
              SizedBox(
                height: 8,
              ),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
