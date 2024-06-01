import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late Timer _timer;
  late DateTime _initialTime;
  Duration _elapsedTime = Duration.zero;

  final Map<int, String> _imagePaths = {
    2: 'assets/grass/g_2.png',
    4: 'assets/grass/g_4.png',
    8: 'assets/grass/g_8.png',
    10: 'assets/grass/g_10.png',
  };

  @override
  void initState() {
    super.initState();
    if (globalJob != null) {
      _initialTime = globalJob!.start_time!;
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          _elapsedTime = _calculateDuration();
        });
      });
      /*_startTime = globalJob!.start_time!;
      _tickerStream = _ticker();
      _tickerSubscription = _tickerStream.listen((_) {
        setState(() {
          _elapsedTime = _calculateDuration(_startTime);
        });
      });*/
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (globalJob == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Actual Job'),
        ),
        body: const Center(
          child: Text('No job available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Actual Job"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cutting grass',
                  style: TextStyle(fontSize: 24),
                ),
                AnimatedDotDotDot(),
              ]
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _formatDuration(_elapsedTime),
                  style: const TextStyle(fontSize: 24),
                ),
                Column(
                  children: [
                    Image.asset(
                      _imagePaths[globalJob!.cutting_height!]!,
                      height: 50.0, width: 50.0,
                    ),
                    Text(globalJob!.cutting_height!.toString()),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const ElevatedButton(
              onPressed: null,
              child: Text("3D View")
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _stopJob(context),
              child: const Text("Cancel Job"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    if (globalJob == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Actual Job'),
        ),
        body: const Center(
          child: Text('No job available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actual Job'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalJob = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem("Cutting Height", globalJob!.cutting_height),
            _buildInfoItem("Area", globalJob!.area),
            _buildInfoItem("Initial time", globalJob!.start_time),
            _buildInfoItem("Elapsed Time", _formatDuration(_elapsedTime)),
            _buildInfoItem("Robot ID", globalJob!.id_robot),
            Center(
              child: ElevatedButton(
                  onPressed: () => _stopJob(context),
                  child: const Text("Cancel Job")
              ),
            )
          ],
        ),
      )
      *//*body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDuration(_elapsedTime),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _togglePause,
                  icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () => _stopJob(context),
                  icon: const Icon(Icons.stop),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                globalJob = null;
                context.goNamed("main_robot");
              },
              child: const Text('Go home'),
            ),
          ],
        ),
      ),*//*
    );
  }*/

  Widget _buildInfoItem(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _stopJob(BuildContext context) {
    _timer.cancel();
    if (globalJob != null) {
      globalJob!.end_time = DateTime.now();
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Job Finished"),
          content: const Text("The job has been finished."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (globalRobot != null) {
                  await finish_active_job(globalRobot!.id);
                  globalRobot!.id_active_job = null;
                }
                if (context.mounted) {
                  context.goNamed("main_robot");
                } // Navega a la pantalla principal
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Duration _calculateDuration() {
    return DateTime.now().difference(_initialTime);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class AnimatedDotDotDot extends StatefulWidget {
  @override
  _AnimatedDotDotDotState createState() => _AnimatedDotDotDotState();
}

class _AnimatedDotDotDotState extends State <AnimatedDotDotDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Text(
        "...",
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}