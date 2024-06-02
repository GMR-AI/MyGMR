import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// Pages
import 'package:my_gmr/job/actual.dart';
import 'package:my_gmr/job/configure_grass_height.dart';
import 'package:my_gmr/job/define_area.dart';
import 'package:my_gmr/job/info.dart';
import 'package:my_gmr/job/list_of_jobs.dart';
import 'package:my_gmr/job/resume.dart';
import 'package:my_gmr/robots/info_model.dart';
import 'package:my_gmr/robots/list_of_robots.dart';
import 'package:my_gmr/robots/no_robots.dart';
import 'package:my_gmr/main_robot.dart';
import 'package:my_gmr/sign_up.dart';
import 'package:my_gmr/welcome.dart';

import 'job/job_class.dart';

final GoRouter router = GoRouter(routes: <GoRoute>[
  GoRoute(
    name: "welcome",
    path: "/",
    builder: (BuildContext context, GoRouterState state) {
      return const Welcome(title: "MyGMR");
    },
    routes: [
      GoRoute(
        name: "signup",
        path: "signup",
        builder: (BuildContext context, GoRouterState state) {
          return const SignUp();
        },
      ), // Sign-Up
      GoRoute(
        name: "no_robots",
        path: "no_robots",
        builder: (BuildContext context, GoRouterState state) {
          return const NoRobots();
        },
      ), // No Robots
      GoRoute(
        name: "list_robots",
        path: "listrobots",
        builder: (BuildContext context, GoRouterState state) {
          return const ListOfRobots();
        },
        routes: [
          GoRoute(
            name: "main_robot",
            path: "mainrobot",
            builder: (BuildContext context, GoRouterState state) {
              return MainRobot();
            },
            routes: [
              GoRoute(
                name: "config_grass",
                path: "configgrassheight",
                builder: (BuildContext context, GoRouterState state) {
                  return ConfigureGrassHeightPage();
                },
                routes: [
                  GoRoute(
                    name: "define_area",
                    path: "definearea",
                    builder: (BuildContext context, GoRouterState state) {
                      return const DefineAreaPage();
                  },
                    routes: [
                      GoRoute(
                        name: "resume",
                        path: "resume",
                        builder: (BuildContext context, GoRouterState state) {
                          return ResumePage();
                        }
                      ) // Resume New Job
                    ]
                  ) // Define Area
                ]
              ), // Config Grass
              GoRoute(
                name: "actual",
                path: "actual",
                builder: (BuildContext context, GoRouterState state) {
                  return const ActualJobPage();
                },
              ), // Actual Job
              GoRoute(
                name: "list_previous",
                path: "listprevious",
                builder: (BuildContext context, GoRouterState state) {
                  List<Job>? jobs = state.extra as List<Job>?;
                  return ListOfJobs(jobs: jobs);
                },
                routes: [
                  GoRoute(
                      name: "job_info",
                      path: "jobinfo/:job",
                      builder: (BuildContext context, GoRouterState state) {
                        Job? job = state.extra as Job;
                        return JobInfo(job: job);
                      }
                  ) // Job Info
                ]
              ), // List Of Jobs
              GoRoute(
                  name: "model_info",
                  path: "model_info",
                  builder: (BuildContext context, GoRouterState state) {
                    return ModelInfoScreen();
                  }
              ) // Model Info
            ]
          ), // Home
        ]
      ) // List Robots
    ]
  ), // Welcome Page

]);