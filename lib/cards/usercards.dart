import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/emp_history.dart';
import 'package:zeit/cards/emphistory.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/fee_performance/transaction.dart';
import 'package:zeit/model/emp_history.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/update/update_user.dart';

import '../model/usermodel.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:zeit/model/time.dart';
import 'dart:async';

import '../services/attendance.dart';


class UserC extends StatefulWidget {
  UserModel user ; bool b;
  UserC({super.key, required this.user, this.b=false});

  @override
  State<UserC> createState() => _UserCState();
}

class _UserCState extends State<UserC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 18,)),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt)),
          SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width : MediaQuery.of(context).size.width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.user.pic),
                    fit: BoxFit.cover
                  )
                ),
            ),
            SizedBox(height: 20,),
            myuser()?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child : t(widget.user.Name)
                ),
                myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                  Navigator.push(
                      context, PageTransition(
                      child: Update(Name: 'Name', doc: FirebaseAuth.instance.currentUser!.uid, Firebasevalue: 'name', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                }):SizedBox(),
              ],
            ):
            Center(
              child : t(widget.user.Name)
            ),
            Center(
                child : th(widget.user.Email)
            ),
            SizedBox(height: 10,),
             Container(
               height: 51, width: MediaQuery.of(context).size.width,
               child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount:widget.b? 3:8,scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int qIndex) {
                    return InkWell(
                      onTap: (){
                        setState((){
                          active = qIndex ;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ayu(qIndex)
                      ),
                    );
                  },
                ),
             ),
            Padding(
              padding: const EdgeInsets.only( left : 9.0, right : 9),
              child: Divider(thickness: 0.5,),
            ),
           mwnu(active),
          ],
        ),
      ),
    );
  }
  Widget other(){
    String s = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      height: 400,width: MediaQuery.of(context).size.width,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         Text("  My Resume",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          InkWell(
            onTap:(){
              Navigator.push(
                  context,
                  PageTransition(
                      child: MyPdf(str: widget.user.resumelink,),
                      type: PageTransitionType.leftToRight,
                      duration: Duration(milliseconds: 400)));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:50,width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                  border:Border.all(color:Colors.blue,width:2),
                  borderRadius: BorderRadius.circular(8)
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width:13),
                    Text("See Resume   ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
                    Icon(Icons.picture_as_pdf,color:Colors.red),
                    Spacer(),

                    Icon(Icons.open_in_new),
                    SizedBox(width:13),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Text("  My Links",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
          InkWell(
            onTap:() async {
              final Uri _url = Uri.parse(widget.user.link1);
              if (!await launchUrl(_url)) {
              throw Exception('Could not launch $_url');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:50,width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                    border:Border.all(color:Colors.blue,width:2),
                    borderRadius: BorderRadius.circular(8)
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width:13),
                    Text("My Portfolio   ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
                    myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                      Navigator.push(
                          context, PageTransition(
                          child: Update(Name: 'Portfolio Link', doc: s, Firebasevalue: 'link1', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                      ));
                    }):SizedBox(),
                    Spacer(),
                    Icon(Icons.open_in_new),
                    SizedBox(width:13),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap:() async {
              final Uri _url = Uri.parse(widget.user.link2);
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:50,width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                    border:Border.all(color:Colors.blue,width:2),
                    borderRadius: BorderRadius.circular(8)
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width:13),
                    Text("My Portfolio 2  ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
                    myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                      Navigator.push(
                          context, PageTransition(
                          child: Update(Name: 'Portfolio Link 2', doc: s, Firebasevalue: 'link2', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                      ));
                    }):SizedBox(),
                    Spacer(),
                    Icon(Icons.open_in_new),
                    SizedBox(width:13),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap:() async {
              final Uri _url = Uri.parse(widget.user.link3);
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height:50,width: MediaQuery.of(context).size.width,
                decoration:BoxDecoration(
                    border:Border.all(color:Colors.blue,width:2),
                    borderRadius: BorderRadius.circular(8)
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width:13),
                    Text("My Portfolio 3  ",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w700)),
                    myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                      Navigator.push(
                          context, PageTransition(
                          child: Update(Name: 'Portfolio Link 3', doc: s, Firebasevalue: 'link3', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                      ));
                    }):SizedBox(),
                    Spacer(),
                    Icon(Icons.open_in_new),
                    SizedBox(width:13),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
  Widget mwnu(int i){
    if(widget.b&&i==0){
      return r1();
    }else if(widget.b&&i==1){
      return emphistory();
    } else if(widget.b){
      return other();
    }else if(i==0){
      return r1();
    }else if(i==1){
      return attendance(false);
    }else if(i==2) {
      setState(() {
        calculateDurationSumAndAverage(
            _singleDatePickerValueWithDefaultValue[0]!,
            _singleDatePickerValueWithDefaultValue[1]!);
      });
      return attendance(true);
    }else if(i==3){
      return leave();
  } else if(i==4){
      return emphistory();
    }else if(i==5){
      List<PayModel> _list = [];
      return  Container(
        height : 200,
        child: widget.user.source==""?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, color : Colors.red),
              SizedBox(height: 7),
              Text(
                "You are not Attached to Company",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                "Try attaching yourself to company than come again to view Payroll",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
            ],
          ),
        ):StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Company')
              .doc(widget.user.source).collection("Payroll").where("type",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                      "No Templates found",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Looks likes Company haven't any Templates",
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
                PayModel.fromJson(e.data())).toList() ?? []);
            return ListView.builder(
              itemCount: _list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Per(user: _list[index],id:"NO" );
              },
            );
          },
        ),
      );
  } else if(i==6){
      List<PayModel> _list = [];
      return  Container(
        height : 200,
        child: widget.user.source==""?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, color : Colors.red),
              SizedBox(height: 7),
              Text(
                "You are not Attached to Company",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                "Try attaching yourself to company than come again to view Payroll",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
            ],
          ),
        ):StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Company')
              .doc(widget.user.source).collection("Payroll").where("type",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                      "No Templates found",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Looks likes Company haven't any Templates",
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
                PayModel.fromJson(e.data())).toList() ?? []);
            return ListView.builder(
              itemCount: _list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Per(user: _list[index],id:"NO" );
              },
            );
          },
        ),
      );
    } else if(i==7){
      return other();
    }else{
      return Container(
        child: Text("Hi"),
      );
    }
  }

  bool myuser(){
    String gh = FirebaseAuth.instance.currentUser!.uid;
    if(gh==widget.user.uid){
      return true;
    }else{
      return false;
    }
  }

  Widget emphistory(){
    List<EmploymentHistory> _list = [];
    return  Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
          child: Container(
            height: 40,width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black,
                ),color: Colors.white
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width:9),
                Text("Add Employment History",style:TextStyle(fontWeight: FontWeight.w500)),
                Spacer(),
                InkWell(
                    onTap:(){
                      Navigator.push(
                          context,
                          PageTransition(
                              child: EmploymentHistoryForm(),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 600)));
                    },
                    child: Icon(Icons.add)),
                SizedBox(width:9),
              ],
            ),
          ),
        ),
        Container(
          height: 400,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser!.uid).collection("History")
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
                        "No Employment History found",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Looks likes User didn't add any Employment History",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }
              final data = snapshot.data?.docs;
              _list.clear();
              _list.addAll(data?.map((e) => EmploymentHistory.fromJson(e.data())).toList() ?? []);
              return ListView.builder(
                itemCount: _list.length,
                padding: EdgeInsets.only(top: 10),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Emphistory(user: _list[index], );
                },
              );
            },
          ),
        ),
      ],
    );
  }


  String local = 'en';
  List<TimeModel> _list = [];

  Widget attendance(bool time){
    return Container(
      height:400,
      width:MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarDialogButton(),
          time? Padding(
            padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
            child: Container(
              height: 180,width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.black,
                  ),color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 9,),
                  Padding(
                    padding: const EdgeInsets.only(left:14.0),
                    child: Icon(Icons.timer_rounded,color:Colors.blue),
                  ),
                  io("Total Days",daysc,false),
                  io("Your Total Time",sumAll,true),
                  io("Your Average Time", averageDuration.toInt(),true),
                  SizedBox(height: 9,),
                  Padding(
                    padding: const EdgeInsets.only(left:14.0),
                    child: Icon(Icons.timeline_sharp,color:Colors.red),
                  ),
                  io("This Month Average", averageDuration1.toInt(),true),
                  SizedBox(width: 9,),
                ],
              ),
            ),
          ):
          Expanded(
            child:StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid).collection("Attendance")
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
                          "No Attendance found",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Looks likes either you are not gone to atleast 1 day in office or not attached to Company or may have been deleted",textAlign:TextAlign.center,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
                final data = snapshot.data?.docs;
                _list.clear();
                data?.forEach((doc) {
                  DateTime dateTime = DateTime.parse(doc['lastupdate']);
                  if (dateTime.isAfter(_singleDatePickerValueWithDefaultValue[0]!) && dateTime.isBefore(_singleDatePickerValueWithDefaultValue[1]!)) {
                    _list.add(TimeModel.fromJson(doc.data()));
                    print(_list);
                  }
                });
                return ListView.builder(
                  itemCount: _list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AttenUser(user: _list[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget leave(){
    return Container(
      height:400,
      width:MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCalendarDialogButton(),
          Expanded(
            child:StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser!.uid).collection("Attendance").where("color",isEqualTo: Colors.yellow.value)
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
                          "No Leave Application found",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Looks likes you didn't applied to any Leave Application",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }
                final data = snapshot.data?.docs;
                _list.clear();
                data?.forEach((doc) {
                  DateTime dateTime = DateTime.parse(doc['lastupdate']);
                  if (dateTime.isAfter(_singleDatePickerValueWithDefaultValue[0]!) && dateTime.isBefore(_singleDatePickerValueWithDefaultValue[1]!)) {
                    _list.add(TimeModel.fromJson(doc.data()));
                    print(_list);
                  }
                });
                return ListView.builder(
                  itemCount: _list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AttenUser(user: _list[index]);
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  int active = 0 ;
  late Timer _timer;
  double averageDuration1=0.0;
  @override
  void dispose() {
    // Dispose the timer when the screen is disposed

    super.dispose();
  }
  int sumAll = 0;
  double averageDuration = 0.0;

  Widget ayu(int i ){
    return Container(
      child :  Column(
        children: [
        Text(ga(i), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color : Colors.black),),
          active == i ? Container(
            height: 5,  width: 24, decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(70)
          ),
          ) : SizedBox(width : 2)
        ],
      ),
    );
  }

  String ga(int i){
    if(widget.b&&i==0){
      return "Profile";
    } else if(widget.b&&i==1){
      return "Employment History";
    }else if(widget.b){
      return "Others";
    }else if ( i == 0 ){
      return "Profile";
    }else if ( i == 1){
      return "Attendance";
    }else if ( i == 2){
      return "Time Tracker";
    }else if ( i == 3){
      return "Leave Tracker";
    }else if ( i == 4){
      return "Employment History";
    }else if ( i == 5){
      return "Payroll";
    }else if ( i == 6){
      return "Files";
    }else {
      return "Other";
    }
  }

  Widget t(String s){
    return Text(s, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),);
  }

  Widget th(String s){
    return Text(s, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color : Colors.grey),);
  }

  Widget u(String s){
    return Text(s, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),);
  }

  Widget uu(String s){
    return Padding(
      padding: const EdgeInsets.only( top : 14.0),
      child: Text(s, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
    );
  }

  Widget uuu(String s){
    return Text(s, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color : Colors.grey),);
  }

  Widget r1(){
    String s = FirebaseAuth.instance.currentUser!.uid;
    return Padding(
      padding: const EdgeInsets.only(left : 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          u("About"),
          Row(
            children: [
              uu("Designation"),
              myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                Navigator.push(
                    context, PageTransition(
                    child: Update(Name: 'Designation', doc: s, Firebasevalue: 'education', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              }):SizedBox(),
            ],
          ),
          uuu(widget.user.education),
          uu("Employee type"),
          uuu(widget.user.type),

          uu("Email"),
          uuu(widget.user.Email),
          Row(
            children: [
              uu("Gender"),
              myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                Navigator.push(
                    context, PageTransition(
                    child: Update(Name: 'Gender', doc: s, Firebasevalue: 'gender', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              }):SizedBox(),
            ],
          ),
          uuu(widget.user.gender),
          Row(
            children: [
              uu("Bio"),
              myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                Navigator.push(
                    context, PageTransition(
                    child: Update(Name: 'Bio', doc: s, Firebasevalue: 'bio', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              }):SizedBox(),
            ],
          ),
          uuu(widget.user.bio),
          uu("Gender"),
          uuu(widget.user.gender),
          SizedBox(height: 50,),
          u("Basic Information"),
          uu("Employee ID"),
          uuu("ZEIT"+widget.user.uid),
          uu("Date of Birth"),
          uuu(widget.user.bday),
          SizedBox(height: 50,),

          u("Identity Information"),
          Row(
            children: [
              uu("Pan Card"),
              myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                Navigator.push(
                    context, PageTransition(
                    child: Update(Name: 'Pan Card Number', doc: s, Firebasevalue: 'pan', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              }):SizedBox(),
            ],
          ),
          uuu(""),
          Row(
            children: [
              uu("Adhaar Card"),
              myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                Navigator.push(
                    context, PageTransition(
                    child: Update(Name: 'Adhaar Card', doc: s, Firebasevalue: 'adhaar', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                ));
              }):SizedBox(),
            ],
          ),
          uuu(widget.user.adhaar),
          SizedBox(height: 70,),
        ],
      ),
    );
  }
  String formatElapsedTime(int elapsedTime) {
    int elapsedSeconds = elapsedTime.toInt();
    if (elapsedSeconds < 60) {
      return "$elapsedSeconds sec";
    } else if (elapsedSeconds < 3600) {
      int minutes = elapsedSeconds ~/ 60;
      int seconds = elapsedSeconds % 60;
      return seconds > 0 ? "$minutes min" : "$minutes min";
    } else if (elapsedSeconds < 72000) {
      int hours = elapsedSeconds ~/ 3600;
      int minutes = (elapsedSeconds % 3600) ~/ 60;
      return minutes > 0 ? "$hours hr, $minutes min" : "$hours hr";
    } else {
      return "20+ hr";
    }
  }
  Widget io(String h, int h2, bool fneeded){
    late String de;
    if(fneeded){
      de=formatElapsedTime(h2);
    }else{
      de=h2.toString()+ " Days";
    }
    return Padding(
      padding: const EdgeInsets.only(bottom:9.0,left:15,right:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$h : "),
          Text(de),
        ],
      ),
    );
  }
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().subtract(Duration(days: 4)),
    DateTime.now().add(Duration(days: 3)),
  ];

  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return InkWell(
      onTap: () async {
        final values = await showCalendarDatePicker2Dialog(
          context: context,
          config: config,
          dialogSize: const Size(325, 400),
          borderRadius: BorderRadius.circular(15),
          value: _singleDatePickerValueWithDefaultValue ,
          dialogBackgroundColor: Colors.white,
        );
        if (values != null) {
          // ignore: avoid_print
          print(_getValueText(
            config.calendarType,
            values,
          ));
          // Format the DateTime in the desired format (DD/MM/YYYY)
          setState(() {
            _singleDatePickerValueWithDefaultValue  = values;
            DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
            String dateTimeString = date.toString();

            // Convert DateTime string to DateTime
            DateTime dateTime = DateTime.parse(dateTimeString);

            // Format the DateTime in the desired format (DD/MM/YYYY)
            String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

            setState((){
              calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
            });
          });
        }
      },
      child:  Padding(
        padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
        child: Container(
          height: 50,width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),color: Colors.white
          ),
          child: Row(
            children: [
              SizedBox(width: 9,),
              InkWell(
                  onTap: (){
                    setState(() {
                      _singleDatePickerValueWithDefaultValue[0]= _singleDatePickerValueWithDefaultValue[0]!.subtract(Duration(days: 7));
                      _singleDatePickerValueWithDefaultValue[1]= _singleDatePickerValueWithDefaultValue[1]!.subtract(Duration(days: 7));
                      calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
                    });

                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(width: 4,),
              Text(s1(_singleDatePickerValueWithDefaultValue[0]!)),
              Spacer(),
              Text(s1(_singleDatePickerValueWithDefaultValue[1]!)),
              SizedBox(width: 4,),
              InkWell(
                  onTap: (){
                    setState(() {
                      _singleDatePickerValueWithDefaultValue[0]=  _singleDatePickerValueWithDefaultValue[0]!.add(Duration(days: 7));
                      _singleDatePickerValueWithDefaultValue[1]=_singleDatePickerValueWithDefaultValue[1]!.add(Duration(days: 7));
                      calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
                    });
                  },
                  child: Icon(Icons.arrow_forward)),
              SizedBox(width: 9,),
            ],
          ),
        ),
      ),
    );
  }
  String s1(DateTime dateTime){
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }
  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
  void calculateDurationSumAndAverage(DateTime d1, DateTime d2) async {
    int totalDuration = 0;
    int daysDifference = d2
        .difference(d1)
        .inDays + 1; // to include both start and end days
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("Attendance")
            .get();

        querySnapshot.docs.forEach((doc) {
          // Check if the document data is not null and is of type Map<String, dynamic>
          if (doc.data() != null && doc.data() is Map<String, dynamic>) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            // Parse the datetime field
            DateTime docDateTime = DateTime.parse(data['lastupdate']);
            // Check if the document date is within the specified range
            if (docDateTime.isAfter(d1.subtract(Duration(days: 1))) &&
                docDateTime.isBefore(d2.add(Duration(days: 1)))) {
              // Check if the document contains the 'duration' field
              if (data.containsKey('duration')) {
                dynamic durationValue = data['duration'];
                if (durationValue is int) {
                  totalDuration += durationValue;
                } else if (durationValue is double) {
                  totalDuration += durationValue.toInt();
                }
              }
            }
          }
        });

        // Calculate the average duration per day
        double average = totalDuration / daysDifference;

        setState(() {
          sumAll = totalDuration;
          averageDuration = average;
          daysc = daysDifference;
        });
        calculateDurationSumAndAverageForMonth(d1);
        print("Total duration: $totalDuration");
        print("Average duration per day: $average");
      } catch (error) {
        print("Error calculating duration: $error");
      }

  }
  int  daysc=0;
  void calculateDurationSumAndAverageForMonth(DateTime d1) async {
    int totalDurationd = 0;

    // Get the first and last days of the month for d1
    DateTime firstDayOfMonth = DateTime(d1.year, d1.month, 1);
    DateTime lastDayOfMonth = DateTime(d1.year, d1.month + 1, 0);

    // Number of days in the month
    int daysInMonth = lastDayOfMonth.difference(firstDayOfMonth).inDays + 1;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("Attendance")
          .get();

      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Parse the datetime field
          DateTime docDateTime = DateTime.parse(data['datetime']);

          // Check if the document date is within the specified month
          if (docDateTime.isAfter(firstDayOfMonth.subtract(Duration(days: 1))) && docDateTime.isBefore(lastDayOfMonth.add(Duration(days: 1)))) {
            // Check if the document contains the 'duration' field
            if (data.containsKey('duration')) {
              dynamic durationValue = data['duration'];
              if (durationValue is int) {
                totalDurationd += durationValue;
              } else if (durationValue is double) {
                totalDurationd += durationValue.toInt();
              }
            }
          }
        }
      });

      // Calculate the average duration per day
      double averaged = totalDurationd / daysInMonth;

      setState(() {
        averageDuration1 = averaged;
      });

      print("Total duration for the month: $totalDurationd");
      print("Average duration per day for the month: $average");
    } catch (error) {
      print("Error calculating duration: $error");
    }
  }
}
