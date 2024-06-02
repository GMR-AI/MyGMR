import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../globals.dart';
import '../functions/job_requests.dart';
import 'package:o3d/o3d.dart';


class ActualJobPage extends StatefulWidget {
  const ActualJobPage({Key? key}) : super(key: key);

  @override
  _ActualJobPageState createState() => _ActualJobPageState();
}

class _ActualJobPageState extends State<ActualJobPage> {
  late Timer _timer;
  late DateTime _initialTime;
  Duration _elapsedTime = Duration.zero;
  O3DController controller = O3DController();


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
    }
  }

  @override
  void dispose() {
    if (globalJob != null) {
      _timer.cancel();
      globalJob = null;
    }
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
        title: const Text("Actual Job"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Cutting grass',
                  style: TextStyle(fontSize: 24),
                ),
                AnimatedDotDotDot(),
              ]
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _formatDuration(_elapsedTime),
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Image.asset(
                      _imagePaths[globalJob!.cutting_height!]!,
                      height: 100.0, width: 100.0,
                    ),
                    Text(globalJob!.cutting_height!.toString() + "cm"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.green, Colors.white],
                      ),
                    ),
                  ),
                  O3D.network(
                    src: globalRobot!.reconstruction_path!,
                    controller: controller,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => _stopJob(context),
              child: const Text("Cancel Job"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
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
          actions: <Widget> [
            ElevatedButton(
              onPressed: () async {
                if (globalRobot != null) {
                  await finish_active_job(globalRobot!.id);
                  globalRobot!.id_active_job = null;
                }
                // Navega a la pantalla principal
                if (context.mounted) {
                  context.goNamed("main_robot");
                }
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