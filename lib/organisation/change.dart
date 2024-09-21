import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/add/feeds.dart';

import '../cards/profile_organisation.dart';
import '../functions/notification.dart';
import '../main.dart';
import '../model/organisation.dart';
import '../organisation/info.dart';
import '../services/attendance.dart';

class Change extends StatelessWidget {
  const Change({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Change your View"),
      ),
      body: Column(
          children:[
            InkWell(
                onTap: ()async{
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "type":"Organisation",
                    "source":"qHOQtUtjbZhGT4l3zjDXnIxSUIh1",
                  });
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: MyApp(),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 600)));
                },
                child: a(Icon(Icons.home,color :  Colors.amber), "Organisation", "View as HR/Admin")),
            InkWell(
                onTap: () async {
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "type":"Individual",
                    "source":"qHOQtUtjbZhGT4l3zjDXnIxSUIh1",
                  });
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: MyApp(),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 600)));
                },
                child: a(Icon(Icons.newspaper,color :  Colors.blueGrey), "Individual", "View as Employee")),
            InkWell(
                onTap: () async {
                  await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                    "type":"Individual",
                    "source":"",
                  });
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: MyApp(),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 600)));
                },
                child: a(Icon(Icons.accessible_forward,color :  Colors.blue), "Guest", "View as Job Applicant")),
          ]
      ),
    );
  }
  Widget a(Widget r, String str , String str1){
    return ListTile(
      leading: r,
      title: Text(str),
      subtitle: Text(str1),
      trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey, size: 15,),
    );
  }
}
