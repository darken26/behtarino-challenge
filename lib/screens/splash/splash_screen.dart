import 'dart:async';

import 'package:behtarino/core/sqflite/auth_db.dart';
import 'package:behtarino/core/sqflite/events_db.dart';
import 'package:behtarino/models/events_model.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String location = '/login';

  @override
  void initState() {
    AuthenticationDBHelper.instance.getAuth().then((value) {
      if(value.isNotEmpty && value.first.token != '') {
        location = '/calendar';
      }
    });

    EventsDBHelper.instance.getEvents().then((value) {

      final DateTime now = DateTime.now();
      for(EventsModel e in value) {
        if(now.day != DateTime.parse(e.start).day) {
          EventsDBHelper.instance.remove(e.id);
        }
      }

    });

    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
        location,
        ModalRoute.withName(location),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/pictures/logo.png',
                width: 200,
              ),
              const SizedBox(height: 100),
              const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
