import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/update/update_user.dart';

class NSalary extends StatefulWidget {
OrganisationModel user;
  String id;
  NSalary({super.key,required this.id,required this.user});

  @override
  State<NSalary> createState() => _NSalaryState();
}

class _NSalaryState extends State<NSalary> {
  List<UserModel> _list = [];
  String st = "";
  bool on = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Edit Salary for Employees",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      backgroundColor: Colors.white,
      body:on?StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo:widget.user.id )
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
                    "Looks likes no Applicatants for ${widget.id}",
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
              return ChatU(user: _list[index],id:widget.id );
            },
          );
        },
      ):StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("shit",isEqualTo: st)
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
                    "Looks likes no Applicatants for ${widget.id}",
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
              return ChatU(user: _list[index],id:widget.id );
            },
          );
        },
      ),
    );
  }
  Widget r(String str,Widget rt){
    return ListTile(
      onTap: (){
        setState((){
          on=false;
          st=str;
        });
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("View all $str with Filter"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class ChatU extends StatelessWidget {
  UserModel user; String id;
  ChatU({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: (){
          Navigator.push(
              context, PageTransition(
              child: Update(Name: 'Salary', doc: user.uid, Firebasevalue: 'salary', Collection: 'Users', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
          ));
        },
        tileColor: Colors.white30,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.pic),
        ),
        title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
        subtitle: Text("Monthly Salary : ₹"+ (user.salary).toInt().toString()
          ,style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),),
        trailing: Icon(Icons.change_circle_rounded,color: Colors.blue,),
      ),
    );
  }
}