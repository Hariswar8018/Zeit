
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/usermodel.dart';

import 'jobs_full.dart';

class JobU extends StatelessWidget {
  Job user ; bool checking;
  JobU({super.key,required this.user,required this.checking});
  String uid=FirebaseAuth.instance.currentUser!.uid;
  bool statusru(){
    print(user.status1);
    if(user.status1=="Active"){
      return true;
    }else{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:4.0,right: 4,bottom: 4),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: JobFull(user:user, active: statusru(),),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child: Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.blue,
                width: 1
              )
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 14.0,top: 12,right: 10,bottom: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width-135,
                          child: Text(user.name, style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color:Colors.black),)),
                      Spacer(),
                      InkWell(onTap: () async {
                        if(checking){
                          await FirebaseFirestore.instance.collection("Jobs").doc(user.time).update({
                            "saved":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                          });
                          Send.message(context, "Job Remove from Bookmarks", false);
                        }else{
                          await FirebaseFirestore.instance.collection("Jobs").doc(user.time).update({
                            "saved":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                          });
                          Send.message(context, "Job Added to Bookmarks", true);
                        }
                      },
                      child: checking? Icon(Icons.bookmark_remove_outlined):(user.saved.contains(FirebaseAuth.instance.currentUser!.uid)?Icon(Icons.bookmark):Icon(Icons.bookmark_add_outlined))),
                    ],
                  ),
                  SizedBox(height:10),
                  Text(user.comn, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.black),),
                  Text(user.address, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0,bottom: 9),
                    child: Row(
                      children: [
                        Container(
                          width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue
                            ),
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          ),
                          child : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(child: Text(user.jtype,style: TextStyle(fontWeight: FontWeight.w700),)),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Container(
                          width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                          decoration: BoxDecoration(
                           // Background color of the container
                            border: Border.all(
                              color: Colors.blue
                            ),
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                          ),
                          child : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(child: Text(user.jem,style: TextStyle(fontWeight: FontWeight.w700),)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:2),
                  Container(
                    width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                    decoration: BoxDecoration(
                      // Background color of the container
                      border: Border.all(
                          color: col(),
                        width: 2
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(child: Text( statusr(),style: TextStyle(fontWeight: FontWeight.w700),)),
                    ),
                  ),
                  SizedBox(height:4),
                  Text("Posted on "+ gy(user.time), style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                ],
              ),
            )),
      ),
    );
  }
  String statusr(){
    print(user.status1);
    if(user.status1=="Active"){
      return "Hiring Now";
    }else if(user.status1=="Done"){
      return "Vacancy Filled";
    }else if(user.follower1.contains(uid)){
      return "Selected !";
    }else if(!user.follower1.contains(uid)&&user.follower.contains(uid)){
      return "Not Selected";
    }else{
    return "Vacancy Filled";
    }
  }
  Color col(){
    print(user.status1);
    if(user.status1=="Active"){
      return Colors.blue;
    }else if(user.status1=="Done"){
      return Colors.greenAccent;
    }else if(user.follower1.contains(uid)){
      return Colors.purpleAccent;
    }else{
      return Colors.red;
    }
  }
  String gy(String st){
    try{
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(st));
      String formattedDate = DateFormat('dd/MM/yyyy \'at\' HH:mm').format(dateTime);
      print(formattedDate); // This will print the formatted date
      return formattedDate;
    }catch(e){
      return "Not Uploaded";
    }
  }
}
