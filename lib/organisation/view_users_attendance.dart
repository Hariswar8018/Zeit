import 'package:page_transition/page_transition.dart';
import 'package:zeit/fee_performance/performance_user.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/services/attendance.dart';


class ViewUsersAttendance extends StatelessWidget {
  String id;bool b ; bool performance;OrganisationModel user;
  ViewUsersAttendance({super.key,required this.id,required this.b,required this.performance,required this.user});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text(performance?"View Employee Performance":(b?"Time Tracking for Employees":"Attendance Tracking of Employees"),style:TextStyle(color:Colors.white,fontSize: 22)),
          leading: InkWell(
            onTap:()=>Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Center(child: Icon(Icons.arrow_back_rounded,color:Color(0xff1491C7),size: 22,)),
              ),
            ),
          ),
        ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo:user.id )
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
                    "No User found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Applicatants for ${id}",
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
              UserModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatU(user: _list[index],id:id,b:b ,performance: performance,);
            },
          );
        },
      )
    );
  }
}

class ChatU extends StatelessWidget {
  UserModel user; String id;bool b;bool performance;
  ChatU({super.key,required this.user,required this.id,required this.b,required this.performance});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: (){
          if(performance){
            Navigator.push(
                context,
                PageTransition(
                    child: PerformanceU(user: user,),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200)));
          }else{
            Navigator.push(
                context,
                PageTransition(
                    child: Attendance(time: b,uid:user.uid),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 200)));
          }

        },
        tileColor: Colors.white30,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.pic),
        ),
        title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
        subtitle: Text(user.education),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}