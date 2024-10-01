import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/training.dart';
import 'package:zeit/cards/training.dart';
import 'package:zeit/fee_performance/performance_user.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/main_pages/empty.dart';
import 'package:zeit/main_pages/testapp.dart';
import 'package:zeit/model/training.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_jobs.dart';
import 'package:zeit/cards/jobcard.dart';
import 'package:zeit/cards/profile_organisation.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/model/events.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/task_class.dart';
import 'package:zeit/model/time.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/organisation/kpi.dart';
import 'package:zeit/provider/declare.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:zeit/services/chats.dart';
import 'package:zeit/services/files_see.dart';
import 'package:zeit/services/job.dart';
import 'package:zeit/services/sticky.dart';
import 'package:zeit/services/task.dart';

import '../add/add_hospital.dart';
import '../add/add_task.dart';
import '../cards/eventuser.dart';
import '../cards/hospital.dart';
import '../cards/task.dart';
import '../model/hospital.dart';
import '../model/organisation.dart';
import '../services/attendance.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  void countDocumentsWithPresent() async {
    int count = 0; int i=0;
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    await FirebaseFirestore.instance
        .collection('Company')
        .doc(_user!.source).collection("Tasks")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      prc = i;
    });
  }

  void adddate() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid).update({
      "jobfollower1":FieldValue.arrayUnion([formattedDate]),
    });
  }

  void countp() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Users').where("source",isEqualTo: _user!.source)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      people = i;
    });
  }
  void countp1() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    DateTime currentDate = DateTime.now();
    String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Users').where("jobfollower1",arrayContains: formattedDate).where("source",isEqualTo: _user!.source)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      people1 = i;
    });
  }

  void countt() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      taskk = i;
    });
  }

  int trainingp=0;

  void counttrain() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Training")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      trainingp = i;
    });
  }

  int taskk=0;
  int taskk1=0;
  void countt1() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks").where("status",isEqualTo: "Active")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      taskk1 = i;
    });
  }
  void counth() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Health")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      healthcount = i;
    });
  }
  int healthcount = 0;
  int people=0;
  int people1=0;
  int prc = 0;
  late final StreamDuration _streamDuration;
  bool ont = false;
  final defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
  double elapsedTime = 0.0; // Store elapsed time in double

  bool _isTimerRunning = false; // Boolean flag to track timer state
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
    countp();countp1();
    countt();countt1();counth();
    _checkAndStartTimer();
    counttrain();
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
  void dispose() {
    _streamDuration.dispose();
    super.dispose();
    _stopTimer();
  }
  
  Color tyuu(int kk){
    if(kk==0){
      return Colors.purpleAccent;
    }else if(kk==1){
      return Colors.green;
    }else if(kk==2){
      return Colors.deepOrange;
    }else {
      return Colors.blueAccent;
    }
  }

  Widget c(double d,String str,String uiop,Widget tyu,int  kk){
    return Container(
        width: ((d+30)/2)-40,
        height:60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:tyuu(kk),
        ),
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                  children:[
                   tyu,
                    Text(str,style:TextStyle(fontSize: d/29,fontWeight: FontWeight.w500,color:Colors.white)),
                  ]
              ),
              Text(uiop.toString(),style:TextStyle(fontSize: d/17,fontWeight: FontWeight.w800,color:Colors.white)),
            ],
          ),
        )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.width - 30;
    double h = MediaQuery.of(context).size.width - 20 ;
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    if(_user!.source.isEmpty){
      if(_user!.type=="Individual"){
        return emplty(d, _user!);
      }else{
        return Empty2();
      }
    }else{
      if(_user!.type=="Individual"){
        return employee(d, _user);
      }else{
        return organisation(d, _user!);
      }

    }
  }


  Widget organisation(double d,UserModel _user){
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            w(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                    onTap: () async {
                    },
                    child: c(d," Total Employee"," $people1 / $people ", Icon(Icons.person,size:d/22,color:Colors.white,),0)),
                c(d," Active Task"," $taskk1 / $taskk ", Icon(Icons.task,size:d/22,color:Colors.white,),1),
              ],
            ),
            SizedBox(height:9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c(d," Training",trainingp.toString(), Icon(Icons.pan_tool_rounded,size:d/22,color:Colors.white),2),
                c(d," Health Benefits","$healthcount", Icon(Icons.health_and_safety,size:d/22,color:Colors.white),3),
              ],
            ),
            SizedBox(height:5),
            TextButton(onPressed: () async {

              String  uid = FirebaseAuth.instance.currentUser!.uid ;
              try {
                // Reference to the 'users' collection
                CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
                // Query the collection based on uid
                QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
                // Check if a document with the given uid exists
                if (querySnapshot.docs.isNotEmpty) {
                  // Convert the document snapshot to a UserModel
                  OrganisationModel user = OrganisationModel.fromSnap(querySnapshot.docs.first);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Kpi(user: user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                } else {
                  // No document found with the given uid
                  return null;
                }
              } catch (e) {
                print("Error fetching user by uid: $e");
                return null;
              }

            }, child: Text("View All KPIs >",style:TextStyle(fontSize: d/25,fontWeight: FontWeight.w500,color:Colors.blue)),),
            SizedBox(height:5),
            Center(
              child: InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UserC(user: _user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/office-chair-svgrepo-com.svg","My Profile", true,2),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_user!.pic),
                                radius: 25,
                              ),
                              title: Text(_user.Name,style :TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
                              subtitle: Text(_user.education,style :TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                              trailing: Text(_user.type,style :TextStyle(fontWeight: FontWeight.w400,)),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            ),
            w(),
            // Recruitment
            InkWell(
              onTap:(){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Jobh(hr: true,),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 600)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: d,
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
                          a( "assets/office-worker-svgrepo-com.svg", "Recruitment", true,7),
                          jobs(200),
                        ],
                      ),
                    )),
              ),
            ),
            w(),
            //Tasks
            InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Taskk(hr: false,),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 600)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: d,
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
                          a( "assets/office-school-ecommerce-svgrepo-com.svg","My Tasks", true,3),
                          task(),
                        ],
                      ),
                    )),
              ),
            ),
            w(),

            //Health
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: d,
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
                        a( "assets/hospital-chart-style-s-svgrepo-com.svg","Health Services", true,5),
                        hospital(),
                      ],
                    ),
                  )),
            ),
            w(),
            // Events
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: d,
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
                        a( "assets/event-calender-date-note-svgrepo-com (1).svg","Training", true,4),
                        training(),
                      ],
                    ),
                  )),
            ),
            w(),
          ],
        ),
      ),
    );
  }

  Widget individual(){
    return Column(
      children: [
        Text("mbbnm"),
      ],
    );
  }

 Widget yuup(){
   DateTime now = DateTime.now();
   int currentHour = now.hour;

   if (currentHour >= 13 && currentHour < 15) {
     // Show your widget here
     return Text("LUNCH BREAK",style: TextStyle(color: Colors.brown,fontWeight: FontWeight.w800),);
   } else {
     // Return empty container or nothing
     return Text("Shedule 9 AM to 8 PM",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),);
   }
 }

  bool isWithinOneHour(String st) {
    try {
      int currentTimeMillis = DateTime
          .now()
          .millisecondsSinceEpoch;
      int savedTimeMillis = int.parse(st);
      // Calculate the difference in time
      int differenceInMillis = currentTimeMillis - savedTimeMillis;

      // Check if the difference is less than 1 hour (3600000 milliseconds)
      return differenceInMillis < 3600000;
    }catch(e){
      return false;
    }
  }

  Widget employee(double d,UserModel _user){
    return Scaffold(
      body : SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              isWithinOneHour(_user.meetid)? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: d,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.ondemand_video_sharp,color: Colors.white,size: 30,),
                        Text("Invitation !",style: TextStyle(color: Colors.white,fontSize: 17),),
                        Text(_user.meetby+" (${_user.meetdesc}) invited you to Google/Zoom meet",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 15,),
                        InkWell(
                          onTap: () async {
                            final Uri _url = Uri.parse(_user.meetlink);
                            try{
                              await launchUrl(_url,mode:LaunchMode.externalApplication,);
                            }catch(e){
                              final Uri _urrl = Uri.parse("https://"+_user.meetlink);
                              try{
                                await launchUrl(_urrl,mode:LaunchMode.externalApplication,);
                              }catch(e){
                                Send.message(context, "$e", false);
                              }
                            }
                          },
                          child: Container(
                            height: 45,
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                "Join Now",
                                style: TextStyle(color: Colors.blue, fontSize: 18),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ):SizedBox(),
              Padding(
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
                        Text("Shift : "+_user.shit,style: TextStyle(fontSize: 18),),
                        yuup(),
                        w(),
                        w(),
                        InkWell(
                          onTap: () async {
                            try{
                              adddate();
                            }catch(e){
                              print(e);
                            }
                            try{
                              final result = await Navigator.push(
                                context,
                                PageTransition(
                                  child: Google_F(lat: 56, lon: 55),
                                  type: PageTransitionType.rightToLeft,
                                  duration: Duration(milliseconds: 50),
                                ),
                              );
                              print(result);
                              if (result is Map<String, Object>) {
                                Map<String, double> locationData = {
                                  'lat': result['lat'] as double? ?? 0.0,
                                  'lng': result['lng'] as double? ?? 0.0,
                                };
                                double lat = locationData['lat']!;
                                double lon = locationData['lng']!;
                                String address = result['address'] as String? ?? '';
                                print(ont);
                                print(elapsedTime);
                                print('Latitude: $lat, Longitude: $lon, Address: $address');
                                print(ont);
                                if (ont) {
                                  // Check Out logic
                                  setState(() {
                                    _stopTimer();
                                    ont = false;
                                    print(ont);
                                    print(elapsedTime);
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
                                    print(ont);
                                    print(elapsedTime);
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
                              }}catch(e){
                              print(e);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Sticky(str: _user.uid,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 60)));
                    },
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.purpleAccent.shade400,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.notes,color: Colors.white,),
                            Text(
                              " Sticky Notes",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Chats(user: _user),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 60)));
                    },
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.redAccent.shade400,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.message,color: Colors.white,),
                            Text(
                              " Chats",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: File_See(str: _user.uid,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 60)));
                    },
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blueAccent.shade400,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.file_copy,color: Colors.white,),
                            Text(
                              " Files",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: PerformanceU(user: _user!,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 80)));
                    },
                    child: Container(
                      height: 45,
                      width: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange.shade400,
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.adb_outlined,color: Colors.white,),
                            Text(
                              "Performance",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              w(),
              InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Attendance(time: false,uid: FirebaseAuth.instance.currentUser!.uid),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/time-hourglass-svgrepo-com.svg","Attendance", false,0),
                            attend(),
                          ],
                        ),
                      )),
                ),
              ),
              w(),
              //MyProfile
              InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UserC(user: _user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/office-chair-svgrepo-com.svg","My Profile", false,0),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_user!.pic),
                                radius: 25,
                              ),
                              title: Text(_user.Name,style :TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
                              subtitle: Text(_user.education,style :TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                              trailing: Text(_user.type,style :TextStyle(fontWeight: FontWeight.w400,)),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              w(),
              //Tasks
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Taskk(hr:true,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/office-school-ecommerce-svgrepo-com.svg","My Tasks", true,3),
                            task(),
                          ],
                        ),
                      )),
                ),
              ),
              w(),
              // Events
              InkWell(
                onTap : (){

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/event-calender-date-note-svgrepo-com (1).svg","Trainings", false,0),
                            event(),
                          ],
                        ),
                      )),
                ),
              ),
              w(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: d,
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
                          a( "assets/hospital-chart-style-s-svgrepo-com.svg","Health Services", false,0),
                          hospital(),
                        ],
                      ),
                    )),
              ),
              w(),
            ]
        ),
      ),
    );
  }

  Widget emplty(double d,UserModel _user){
    return  Scaffold(
      body : SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children : [
              InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UserC(user: _user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                      width: d,
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
                            a( "assets/office-chair-svgrepo-com.svg","My Profile", false,0),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_user!.pic),
                                radius: 25,
                              ),
                              title: Text(_user.Name,style :TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
                              subtitle: Text(_user.education,style :TextStyle(fontWeight: FontWeight.w600,fontSize: 12)),
                              trailing: Text(_user.type,style :TextStyle(fontWeight: FontWeight.w400,)),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              w(),
              //Tasks
              // Recruitment
              InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Jobh(hr: false,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: d,
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
                            a( "assets/office-worker-svgrepo-com.svg", "Recruitment", true,0),
                            jobs(500),
                          ],
                        ),
                      )),
                ),
              ),

            ]
        ),
      ),
    );
  }

  Widget admin(){
    return Column(
      children: [
        Text("gvgh"),
      ],
    );
  }

  bool emp(){
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    if(_user!.type!= "Organisation"){
      return true;
    }else{
      return false;
    }
    return false;
  }

  Future<void> t(int   v ) async {
    if ( v == 0){

    }else if(v==1){

    }else if(v == 2){

    }else if(v==3){
      Task hj = Task(
        name: "hgg",
        id: "1",
        hrid: "hr123",
        hrname: "HR Name",
        comid: "com456",
        followers: [],  // List of followers, empty for now
        benefit: [],    // List of benefits, empty for now
        description: "Sample description",
        startdate: "2024-09-23",
        enddate: "2024-09-30",
        priority: "High",
        status: "Pending",
        pic: "pic_url",
        assigndate: "2024-09-22",
        lat: 12.34,
        lon: 56.78,
        client_name: "Client Name",
        client_id: "client123",
        category: "Category",
        invited: 10,
        complete: 5,
        progress: 50,
        Pending: [],        // List of pending tasks
        Completed: [],      // List of completed tasks
        Ignored: [],        // List of ignored tasks
        Incompleted: [],    // List of incompleted tasks
        hr: true,           // Boolean value for hr
        nameol: "nameol",
        namepicol: "namepicol",
        etol: "etol",
      );
      Navigator.push(
          context,
          PageTransition(
              child: AddTask(hj: hj, on: false,),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 600)));
    }else if( v == 4){
      Navigator.push(
          context,
          PageTransition(
              child:TrainingProgramForm(),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 600)));
    }else if(v==5){
      Navigator.push(
          context,
          PageTransition(
              child: AddH(),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 600)));
    }else if(v==7){
      String  uid = FirebaseAuth.instance.currentUser!.uid ;
      try {
        // Reference to the 'users' collection
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
        // Query the collection based on uid
        QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
        // Check if a document with the given uid exists
        if (querySnapshot.docs.isNotEmpty) {
          // Convert the document snapshot to a UserModel
          OrganisationModel user = OrganisationModel.fromSnap(querySnapshot.docs.first);
          Job gh=Job(name: "j", comn: "h", comi: "h", rating:4.8, address: "", type: [], 
              description: "jj", respon: "gg", key: "h", about: "j", experience: "j", 
              qualification: "jh", follower: [], saved: [], benefit: [], hrname: "j", hrid: "j", comlogo: "h",
              hrlogo:"h", status: false, time: "k", jem: "j", jtype:"h", shift: "h", 
              work1:"j", follower1: [], payment:100, Intaddress: '', lat: 23.66, lon: 54.3, phone: '', mail: '', note: '', link: '', meet: false, time2: '');
          Navigator.push(
              context,
              PageTransition(
                  child: AddJ(user: user, change: false, job: gh,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        } else {

          return null;
        }
      } catch (e) {
        print("Error fetching user by uid: $e");
        return null;
      }


    }
  }
  
  Widget a(String asset, String str, bool f,int i ){
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor : Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                asset,
                height: 35, width : 35,
              ),
            ),
          ),
          SizedBox( width: 15),
          Text(str, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21)),Spacer(),

          f && i>2 ? InkWell(
            onTap : (){
              t(i);
    },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              child:Icon(Icons.add)
            ),
          ) : SizedBox(width: 1)
        ]);
  }

  Widget attend(){
    List<TimeModel> _list = [];
    return Container(
      height : 200,
      child:  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid).collection("Attendance").orderBy("millisecondstos",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Events found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes Company haven't any Events",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => TimeModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return AttenUser(user: _list[index], );
            },
          );
        },
      ),
    );
  }

  Widget event(){
    List<TrainingProgram> _list = [];
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height : 300,
      child:  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Training").orderBy("id",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Task found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes you are Free for Today",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              TrainingProgram.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return TrainU(user: _list[index], );
            },
          );
        },
      ),
    );
  }
  
  Widget task(){
    List<Task> _list = [];
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      height : 400,
      child:  StreamBuilder(
        stream: _user!.type!= "Organisation"? FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Tasks").orderBy("id",descending: true)
            .snapshots(): FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Tasks").orderBy("id",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Task found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes you are Free for Today",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              Task.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return TaskU(user: _list[index], );
            },
          );
        },
      ),
    );
  }

  Widget training(){
    List<TrainingProgram> _list = [];
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height : 300,
      child:  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Training").orderBy("id",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Task found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes you are Free for Today",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              TrainingProgram.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return TrainU(user: _list[index], );
            },
          );
        },
      ),
    );
  }

  Widget jobs(double y){
    List<Job> _list = [];
    return Container(
      height : 400,
      child:  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Jobs').orderBy("time",descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Jobs found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes company are still busy",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              Job.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return JobU(user: _list[index], checking: false, );
            },
          );
        },
      ),
    );
  }

  Widget hospital(){
    List<Hospital> _list = [];
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      height : 300,
      color: Colors.white,
      child:  FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Health").orderBy("id",descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hourglass_empty, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Health Services found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes Company haven't any Health Events",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              Hospital.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return HUser(user: _list[index], );
            },
          );
        },
      ),
    );
  }

  Widget w (){
    return SizedBox(height : 15);
  }
}





class TrainU extends StatelessWidget {
  TrainingProgram user;
  TrainU({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 4),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: TrainMe(user:user),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200)));
        },
        child: Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.blue,
                    width: 1.5
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width-130,
                          child: Text(user.company, style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color:Colors.black),)),
                      Spacer(),
                      Icon(Icons.bookmark_add_outlined),
                    ],
                  ),
                  SizedBox(height:10),
                  Text("By : " +user.name, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.black),),
                  Text("Type : "+user.type, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                  SizedBox(height:7),
                  Container(
                    width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                    decoration: BoxDecoration(
                      // Background color of the container
                      border: Border.all(
                          color: Colors.red,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(5.0), // Rounded corners
                    ),
                    child : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(child: Text(user.status,style: TextStyle(fontWeight: FontWeight.w700),)),
                    ),
                  ),
                  SizedBox(height:4),
                  Text("Posted on "+formatElapsedTime(int.parse(user.id)), style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                ],
              ),
            )),
      ),
    );
  }
  String formatElapsedTime(int elapsedTime) {
    try{
      DateTime h=DateTime.fromMicrosecondsSinceEpoch(elapsedTime);
      return "${h.day} / ${h.month} / ${h.year}";
    }catch(e){
      return "Now";
    }
  }

}

