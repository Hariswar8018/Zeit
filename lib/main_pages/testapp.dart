import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/model/time.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}
class _TestState extends State<Test> {
  int people = 0;
  int prc = 0;
  late final StreamDuration _streamDuration;
  bool ont = false;
  bool _isTimerRunning = false; // Boolean flag to track timer state
  final defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
  double elapsedTime = 0.0;
  @override
  void initState() {
    super.initState();

    _streamDuration = StreamDuration(
      config: const StreamDurationConfig(
        countUpConfig: CountUpConfig(
          initialDuration: Duration.zero,
          maxDuration: Duration(hours: 20),
        ),
        isCountUp: true,
        countDownConfig: CountDownConfig(
          duration: Duration(days: 2),
        ),
      ),
    );
    _streamDuration.pause();

    _checkAndStartTimer();
  }

  void _checkAndStartTimer() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Attendance")
          .doc(formattedDate)
          .get();

      if (doc.exists) {
        TimeModel existingData = TimeModel.fromJson(doc.data() as Map<String, dynamic>);

        if (existingData.started == true) {
          print("Timer was running");

          // Timer was started but not ended
          DateTime startTime = DateTime.fromMillisecondsSinceEpoch(int.parse(existingData.millisecondstos));
          DateTime currentTime = DateTime.now();

          // Calculate the difference between current time and start time
          Duration difference = currentTime.difference(startTime);

          // Add the previous duration to the current difference
          double previousDuration = existingData.duration.toDouble();
          elapsedTime = difference.inSeconds.toDouble() + previousDuration;

          if (!_isTimerRunning) {
            setState(() {
              _streamDuration.add(Duration(seconds: elapsedTime.toInt()));
              _startTimer();
              ont = true;
              _isTimerRunning = true; // Update flag when timer starts
            });
          }
        }
        else {
          print("Timer was ended");
          // Timer was ended, just add the existing duration to the current timer
          double existingDuration = existingData.duration.toDouble();
          print("Elapsed time to add: $existingDuration seconds");

          setState(() {
            // Add existing duration without starting the timer
            elapsedTime = existingDuration;
            _streamDuration.add(Duration(seconds: elapsedTime.toInt()));
            ont = true;
            _startTimer();
            _isTimerRunning = true;
          });
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _stopTimer();
              ont = false;
              _isTimerRunning = false;
            });
          });
          print("Elapsed time after addition: $elapsedTime seconds");
        }
      } else {
        print("No previous session found.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }




  void _stopTimer() {
    if (_isTimerRunning) {
      _streamDuration.pause();
      _isTimerRunning = false; // Update flag when timer stops
    }
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _streamDuration.play();
      _isTimerRunning = true; // Update flag when timer starts
    }
  }

  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.width - 30;
    return Scaffold(
      appBar: AppBar(
        title: Text("Check IN"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: d,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                w(),
                SlideCountdownSeparated(
                  padding: defaultPadding,
                  separatorType: SeparatorType.symbol,
                  infinityCountUp: true,
                  duration: const Duration(days: 2), // This is irrelevant for count up
                  showZeroValue: true,
                  streamDuration: _streamDuration,
                  countUp: true,
                ),
                w(),
                Text("9 Am to 7 Pm"),
                w(),
                w(),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      PageTransition(
                        child: Google_F(lat: 56, lon: 55),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 50),
                      ),
                    );

                    if (result is Map<String, Object>) {
                      Map<String, double> locationData = {
                        'lat': result['lat'] as double? ?? 0.0,
                        'lng': result['lng'] as double? ?? 0.0,
                      };

                      double lat = locationData['lat']!;
                      double lon = locationData['lng']!;

                      String address = result['address'] as String? ?? '';

                      print('Latitude: $lat, Longitude: $lon, Address: $address');

                      if (ont) {
                        // Check Out logic
                        setState(() {
                          _stopTimer();
                          ont = false;
                        });

                        DateTime currentDate = DateTime.now();
                        String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
                        String st = DateTime.now().millisecondsSinceEpoch.toString();
                        String su = DateTime.now().toString();

                        TimeModel uio = TimeModel(
                          time: formattedDate,
                          date: "${currentDate.day}",
                          month: "${currentDate.month}",
                          year: "${currentDate.year}",
                          duration: elapsedTime.toInt(),
                          x: 9,
                          lastupdate: su,
                          started: false,
                          millisecondstos: st,
                          startaddress: '',
                          endaddress: '',
                          stlan: 0.0,
                          stlon: 0.0,
                          endlan: lat,
                          endlong: lon,
                          color: Colors.blue.value,
                        );

                        try {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Attendance")
                              .doc(formattedDate)
                              .update(uio.toJson());
                        } catch (e) {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Attendance")
                              .doc(formattedDate)
                              .set(uio.toJson());
                        }
                      } else {
                        // Check In logic
                        DateTime currentDate = DateTime.now();
                        String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';

                        // Fetch the existing document to get the previous duration if any
                        DocumentSnapshot doc = await FirebaseFirestore.instance
                            .collection("Users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("Attendance")
                            .doc(formattedDate)
                            .get();

                        double previousElapsedTime = 0;

                        if (doc.exists) {
                          TimeModel existingData = TimeModel.fromJson(doc.data() as Map<String, dynamic>);
                          previousElapsedTime = existingData.duration.toDouble();
                        }

                        setState(() {
                          _startTimer();
                          elapsedTime = previousElapsedTime;
                          ont = true;
                        });

                        String st = DateTime.now().millisecondsSinceEpoch.toString();
                        String su = DateTime.now().toString();

                        TimeModel uio = TimeModel(
                          time: formattedDate,
                          date: "${currentDate.day}",
                          month: "${currentDate.month}",
                          year: "${currentDate.year}",
                          duration: previousElapsedTime.toInt(), // Store the previous duration
                          x: 9,
                          lastupdate: su,
                          started: true,
                          millisecondstos: st,
                          startaddress: '',
                          endaddress: '',
                          stlan: lat,
                          stlon: lon,
                          endlan: 0.0,
                          endlong: 0.0,
                          color: Colors.blue.value,
                        );

                        try {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Attendance")
                              .doc(formattedDate)
                              .update(uio.toJson());
                        } catch (e) {
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection("Attendance")
                              .doc(formattedDate)
                              .set(uio.toJson());
                        }
                      }

                    }
                  },
                  child: Container(
                    height: 45,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.indigoAccent.shade400,
                    ),
                    child: Center(
                      child: Text(
                        ont ? "Check Out" : "Check In",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget w() => SizedBox(height: 10);
}

