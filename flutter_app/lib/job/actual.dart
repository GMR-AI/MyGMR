import 'dart:async';
import 'package:flutter/material.dart';
import 'job_class.dart';
import '../main_robot.dart';
import '../globals.dart';
import '../functions/job_requests.dart';
import '../robots/robot_class.dart';

class ActualJobPage extends StatefulWidget {
  const ActualJobPage({Key? key}) : super(key: key);

  @override
  _ActualJobPageState createState() => _ActualJobPageState();
}

class _ActualJobPageState extends State<ActualJobPage> {
  late DateTime _startTime;
  late Stream<int> _tickerStream;
  late StreamSubscription<int> _tickerSubscription;
  Duration _elapsedTime = Duration.zero;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    Job? job = globalJob;
    if (job != null) {
      _startTime = job.start_time;
      _tickerStream = _ticker();
      _tickerSubscription = _tickerStream.listen((_) {
        setState(() {
          _elapsedTime = _calculateDuration(_startTime);
        });
      });
    }
  }

  @override
  void dispose() {
    _tickerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Job? job = globalJob;

    if (job == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Actual Job'),
        ),
        body: Center(
          child: Text('No job available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Actual Job'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_elapsedTime),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () => _stopJob(context),
                  icon: Icon(Icons.stop),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainRobot(),
                  ),
                );
              },
              child: Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _tickerSubscription.pause();
      } else {
        _tickerSubscription.resume();
      }
    });
  }

  void _stopJob(BuildContext context) {
    _tickerSubscription.cancel();
    Job? job = globalJob;
    if (job != null) {
      job.end_time = DateTime.now();
      globalJob = job;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Job Finished"),
          content: Text("The job has been finished."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Robot? robot = globalRobot;
                if (robot != null) {
                  int id_robot = robot.id;
                  await finish_active_job(id_robot);
                  globalJob = null;
                  robot.id_active_job = null;
                  globalRobot = robot;
                }
                Navigator.pop(context); // Cierra el diálogo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainRobot(),
                  ),
                ); // Navega a la pantalla principal
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Stream<int> _ticker() {
    return Stream.periodic(Duration(seconds: 1), (x) => x);
  }

  Duration _calculateDuration(DateTime startTime) {
    final currentTime = DateTime.now();
    return currentTime.difference(startTime);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
