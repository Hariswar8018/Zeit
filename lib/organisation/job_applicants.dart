import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/cards/jobcard.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/usermodel.dart';

import '../cards/pdf.dart';
import '../cards/usercards.dart';

class Applicants extends StatelessWidget {
  String id;
  Applicants({super.key,required this.id});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("List of all Applicants",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("jobfollower",arrayContains: id)
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
                    "Looks likes no Applicatants for $id",
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
              return ChatU(user: _list[index],id:id );
            },
          );
        },
      ),
    );
  }
}
class ChatU extends StatelessWidget {
  UserModel user; String id;
   ChatU({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: UserC(user: user,b:true),
                      type: PageTransitionType.bottomToTop,
                      duration: Duration(milliseconds: 300)));
            },
            tileColor: Colors.white30,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pic),
            ),
            title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            subtitle: Text(user.bio),
            trailing: InkWell(
              onTap:() async {
                if(user.follower1.contains(id)){
                  await FirebaseFirestore.instance.collection("Jobs").doc(id).update({
                    "follower1":FieldValue.arrayRemove([user.uid]),
                  });
                  await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
                    "jobfollower1":FieldValue.arrayRemove([id]),
                  });
                }else{
                  await FirebaseFirestore.instance.collection("Jobs").doc(id).update({
                    "follower1":FieldValue.arrayUnion([user.uid]),
                  });
                  await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
                    "jobfollower1":FieldValue.arrayUnion([id]),
                  });
                }

              },
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: user.follower1.contains(id)?Icon(Icons.verified,color: Colors.blue,):Icon(Icons.verified,color:Colors.grey),
              ),
            ),
          ),
          InkWell(
            onTap:(){
              Navigator.push(
                  context,
                  PageTransition(
                      child: MyPdf(str:user.resumelink,),
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
          SizedBox(height: 9,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(user.link1);
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                    child:Icon(Icons.open_in_new,color:Colors.red),
                ),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(user.link2);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:Icon(Icons.open_in_new,color:Colors.purpleAccent),
                ),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(user.link3);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:Icon(Icons.open_in_new,color:Colors.indigo),
                ),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(user.Email);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:Icon(Icons.mail,color:Colors.orange),
                ),
              ),
              InkWell(
                onTap: () async {
                  final Uri _url = Uri.parse(user.Email);
                  if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                  }
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child:Icon(Icons.call,color:Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 14,)
        ],
      ),
    );
  }
}
