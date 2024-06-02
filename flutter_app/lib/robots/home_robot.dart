import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_gmr/job/actual.dart';
import '../job/job_class.dart';
import 'weather.dart';
import '../globals.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../functions/job_requests.dart';


class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home>  {
  //Home();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (globalRobot == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              globalRobot = null;
              Navigator.pop(context);
            },
          ),
        ),
        body: const Center(
          child: Text('No robot available'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalRobot = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: globalRobot!.img ?? '',
                fit: BoxFit.cover,
                height: 300.0,
                errorWidget: (context, error, stackTrace) =>
                    Image.asset(
                      'assets/robot_design.png',
                      fit: BoxFit.cover,
                      height: 300.0,
                    ),
              ),
              Positioned(
                bottom: 8.0,
                left: 8.0,
                child: Text(
                  '${globalRobot!.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Logo',
                  ),
                ),
              ),
            ],
          ),
          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  TabBar(
                    tabs: const [
                      Tab(text: 'Weather'),
                      Tab(text: 'Jobs'),
                      Tab(text: 'Settings'),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(child: WeatherWidget()),
                        SingleChildScrollView(
                        child: _isLoading
                            ? const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 40), // Add some spacing between the CircularProgressIndicator and the text
                                    Text(
                                      'Wait a minute, the reconstruction is being processed',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )
                              )
                            : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Job? active_job = await get_active_job(globalRobot!.id);
                                    if (active_job != null) {
                                      _stopJob(context);
                                    }
                                    else {
                                      globalJob = Job(
                                        id_robot: globalRobot!.id,
                                      );
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      // Update the robot status
                                      await request_new_job();
                                      if (context.mounted && globalJob!.top_image != null) {
                                        context.goNamed("config_grass");
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: Text(
                                    'New',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Job? actualJob = await get_active_job(globalRobot!.id);
                                    if (actualJob != null) {
                                      globalRobot!.id_active_job = actualJob.id;
                                      globalJob = actualJob;
                                      if (context.mounted) {
                                        context.goNamed("actual");
                                      }
                                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ActualJobPage(),
                                        ),
                                      );*/
                                    } else {
                                      globalJob = null;
                                      globalRobot!.id_active_job = null;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ActualJobPage(),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    'Actual',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    int rid = globalRobot!.id;
                                    List<Job>? jobs = await get_list_of_jobs(rid);
                                      if (context.mounted) {
                                        context.goNamed("list_previous", extra: jobs);
                                      }
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ListOfJobs(jobs: jobs ?? []),
                                      ),
                                    );*/
                                  },
                                  child: Text(
                                    'Previous',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigate to the new page
                                    context.goNamed("model_info");
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ModelInfoScreen()),
                                    );*/
                                  },
                                  child: Text(
                                    'Info',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _stopJob(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Current active job"),
          content: const Text("There is an ongoing job. Do you want to delete it first?"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (globalRobot != null) {
                  await finish_active_job(globalRobot!.id);
                  globalRobot!.id_active_job = null;
                  globalJob = Job(
                    id_robot: globalRobot!.id,
                  );
                  setState(() {
                    _isLoading = true;
                  });
                  // Update the robot status
                  await request_new_job();
                  if (context.mounted && globalJob!.top_image != null) {
                    Navigator.pop(context);
                    context.goNamed("config_grass");
                  }
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            )
          ],
        );
      },
    );
  }
}
