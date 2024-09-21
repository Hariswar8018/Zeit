import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_feeds.dart';
import 'package:zeit/model/feeds.dart';
import 'package:zeit/model/usermodel.dart';

import '../cards/FeedsU.dart';
import '../provider/declare.dart';

class Feeds extends StatelessWidget {
   Feeds({super.key});
   List<Feed> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Feeds",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      floatingActionButton:InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: AddF(notification:false),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child: Container(
          width: 110, height : 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.add,color :Colors.white),
                  Text(" Add Feeds", style : TextStyle(color : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Feeds")
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
                  Icon(Icons.accessible_forward, color : Colors.red, size : 24,),
                  SizedBox(height: 7),
                  Text(
                    "No Feeds found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes the Company is too Busy",
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
              Feed.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FeedsU(user: _list[index], );
            },
          );
        },
      ),
    );
  }
}
