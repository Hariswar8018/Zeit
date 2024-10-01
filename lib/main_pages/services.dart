import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/fee_performance/expense.dart';
import 'package:zeit/fee_performance/payroll.dart';
import 'package:zeit/main_pages/approval_clone.dart';
import 'package:zeit/main_pages/empty.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/organisation/all_shift.dart';
import 'package:zeit/organisation/kpi.dart';
import 'package:zeit/organisation/legal_compilance.dart';
import 'package:zeit/organisation/travel.dart';
import 'package:zeit/organisation/view_users_attendance.dart';
import 'package:zeit/services/company_leave.dart';
import 'package:zeit/services/complaints.dart';
import 'package:zeit/services/job.dart';
import 'package:zeit/services/my_payroll.dart';
import 'package:zeit/services/task.dart';
import 'package:zeit/fee_performance/performance_user.dart';
import '../cards/profile_organisation.dart';
import '../functions/notification.dart';
import '../provider/declare.dart';
import '../services/attendance.dart';
import '../services/hr_letters.dart';
import '../services/leave.dart';
import '../services/view_complaints.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  late OrganisationModel organ;
  void initState(){
    df();
  }

  Future<void> df() async {
    String  uid = FirebaseAuth.instance.currentUser!.uid ;
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
    QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      OrganisationModel user = OrganisationModel.fromSnap(querySnapshot.docs.first);
      setState(() {
        organ=user;
      });
    } else {
      organ = OrganisationModel(name: "bjh", logo: "",
          pan:" pan", tan: "tan", uid: uid, id: "id", type: "type", admin:[], hr: [],
          subadmin:[], phone: "phone", email: "email", address: "", incor: "incor",
          bday: "", pic1: "pic1", people:[], desc:" desc", labourlink: "",
          comcases:" comcases", compolicy: "compolicy", lawname: "lawname", lawphone: "lawphone",
          lawemail: "lawemail", status: "status", c1: 1, c2: 2, c3: 3, c4: 4, c5:5, c6: 8,
          c7: 0, c8: 0, c9:0, c10: 0, c11:0, c12: 12, budget:0, lat: 754.6, long: 77);
    }
  }


  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    if(_user!.source.isEmpty){
      if(_user!.type=="Individual"){
        return Empty();
      }else{
        return Empty2();
      }
    }else{
      if(_user!.type=="Individual"){
        return indiv(_user);
      }else if(_user!.type=="HR"){
        return organisation( _user!);
      }else{
        return admin( _user!);
      }
    }
  }
  Widget admin(UserModel _user){
    return  Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        print("rrukuli");
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Jobh(hr: true,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Job Applicant")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: false, performance: false, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/event-calender-date-note-svgrepo-com.svg", "Attendance")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        print("rrukuli");
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Holidays(uid: _user.source),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/complete-ok-accept-good-tick-svgrepo-com.svg", "Company Holiday")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Complaintss(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/identity-and-access-management-svgrepo-com.svg", "Complaints")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Shifts(id: 'shifts', user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/office-chair-svgrepo-com (1).svg", "Change Shifts")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: true, performance: false, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/time-hourglass-svgrepo-com.svg", "Time Tracking")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:() async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Expense(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/event-calender-date-note-svgrepo-com (1).svg", "Expense")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Payroll(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/accounting-svgrepo-com.svg", "Payroll")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProO(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/office-building-svgrepo-com.svg", "Organisation")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: TravelC(id: _user.source,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/airplane-svgrepo-com.svg", "Travel")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Notify(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/announcement-shout-svgrepo-com.svg", "Notifications")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: false, performance: true, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/competition-award-svgrepo-com.svg", "Employee Performance")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:() async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Kpi(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/factory-company-svgrepo-com.svg", "KPIs Metrics")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Taskk(hr: true,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/time-complexity-svgrepo-com.svg", "Task")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Approval(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Cases")),
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: LabourLaws(user: organ, hr: true,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/briefcase-svgrepo-com.svg", "Legal Compilance")),
                ]),
                w(),
              ]),
        ));
  }

  Widget organisation(UserModel _user){
    return  Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        print("rrukuli");
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Jobh(hr: true,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Job Applicant")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: false, performance: false, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/event-calender-date-note-svgrepo-com.svg", "Attendance")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Shifts(id: 'shifts', user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/office-chair-svgrepo-com (1).svg", "Change Shifts")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: true, performance: false, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/time-hourglass-svgrepo-com.svg", "Time Tracking")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:() async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Expense(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/event-calender-date-note-svgrepo-com (1).svg", "Expense")),
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Payroll(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/accounting-svgrepo-com.svg", "Payroll")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProO(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/office-building-svgrepo-com.svg", "Organisation")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: TravelC(id: _user.source,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/airplane-svgrepo-com.svg", "Travel")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Notify(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/announcement-shout-svgrepo-com.svg", "Notifications")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ViewUsersAttendance(id: '', b: false, performance: true, user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/competition-award-svgrepo-com.svg", "Employee Performance")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:() async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Kpi(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/factory-company-svgrepo-com.svg", "KPIs Metrics")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Taskk(hr: true,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/time-complexity-svgrepo-com.svg", "Task")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Approval(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Cases")),
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: LabourLaws(user: organ, hr: true,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/briefcase-svgrepo-com.svg", "Legal Compilance")),
                ]),
                w(),
              ]),
        ));
  }

  Widget indiv(UserModel _user){
    return   Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        print("rrukuli");
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Leave(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Leave Tracker")),
                  InkWell(
                      onTap:(){
                        print("rrukuli");
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Attendance(time: true,uid: FirebaseAuth.instance.currentUser!.uid),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/time-complexity-svgrepo-com.svg", "Time Tracker")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Attendance(time: false,uid: FirebaseAuth.instance.currentUser!.uid),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/event-calender-date-note-svgrepo-com (1).svg", "Attendance")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: PerformanceU(user: _user!,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 200)));
                      },
                      child: q(context, "assets/competition-award-svgrepo-com.svg", "Performance")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: ProO(user: organ,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/office-building-svgrepo-com.svg", "Organisation")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: TravelC(id: _user.source,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/airplane-svgrepo-com.svg", "Travel")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Notify(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/announcement-shout-svgrepo-com.svg", "Announcment")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: HrLetters(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/office-worker-svgrepo-com.svg", "HR Letters")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap:(){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: My_Payroll(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/money-svgrepo-com.svg", "My Payroll")),
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Taskk(hr: false,),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 600)));
                      },
                      child: q(context, "assets/time-complexity-svgrepo-com.svg", "Task")),
                ]),
                w(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            PageTransition(
                                child: Approval(),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 400)));
                      },
                      child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Cases")),
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: LabourLaws(user: organ, hr: false,),
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 100)));
                      },
                      child: q(context, "assets/briefcase-svgrepo-com.svg", "Legal Compilance")),
                ]),
                w(),

              ]),
        ));
  }

  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 135;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500)),
            ]));
  }

  Widget w (){
    return SizedBox(height : 15);
  }
}
