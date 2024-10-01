import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeitt/cards/usercards.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/functions/google_map_check-in_out.dart';
import 'package:zeitt/functions/search.dart';
import 'package:zeitt/model/feeds.dart';
import 'package:zeitt/notification/notify_all.dart';
import 'package:zeitt/provider/declare.dart';
import 'package:zeitt/superadmin/addemployee.dart';
import 'package:zeitt/update/update_user.dart';
import '../model/usermodel.dart';

import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeitt/main.dart';
import 'package:zeitt/main_pages/navigation.dart';
import 'package:zeitt/model/organisation.dart';
import 'package:zeitt/model/usermodel.dart'  ;
import 'package:zeitt/provider/upload.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class UserApproval extends StatelessWidget {
  String  find;
   UserApproval({super.key,required this.find});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Request Access",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        stream:  FirebaseFirestore.instance
            .collection('Users').where("joiningd",isEqualTo:find)
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
                  Text(
                    "No Peers found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no one have requested Access for your Company",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);
          return GridView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatUser(user: _list[index], id: find,),
              );
            },
          );
        },
      ),
    );
  }
}
class ChatUser extends StatelessWidget {
  UserModel user ;String id;
  ChatUser({super.key, required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return SizedBox(
              height: 220,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 15),
                    Container(
                      width: 80, height: 10,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(textAlign: TextAlign.center,
                        "Confirm User",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20)),
                    SizedBox(height: 9),
                    SizedBox(height: 9),
                    Text(textAlign: TextAlign.center,
                        "Comfirm this User to your Organisation",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                    SizedBox(height: 9),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Container(
                            width : MediaQuery.of(context).size.width , height : 60,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent, // Background color of the container
                              borderRadius: BorderRadius.circular(15.0), // Rounded corners
                            ),
                            child : InkWell(
                              onTap: () async {
                                try {
                                  await FirebaseFirestore.instance.collection("Users")
                                      .doc(user.uid)
                                      .update({
                                    "source": id,
                                    "joiningd":DateTime.now().toString(),
                                  });
                                  await FirebaseFirestore.instance.collection("Company")
                                      .doc(id)
                                      .update({
                                    "people": FieldValue.arrayUnion([user.uid]),
                                  });
                                  Navigator.pop(context);
                                  Send.message(context, "Success Added", true);
                                  NotifyAll.sendNotification("You are Accepted as Employee", "HR accepted your Request to Join",user.token);
                                }catch(e){
                                  Send.message(context, "$e", false);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(17.0),
                                child:  Center(child: Text("Yes ! Send Notification", style : TextStyle( fontSize : 17, color : Colors.black, fontWeight: FontWeight.w900))),
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(user.pic),
                  fit: BoxFit.cover
              )
          ),
          child : Column(
            children: [
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40, color : Colors.black,
                child: Center(
                  child: Column(
                    children: [
                      Text(user.Name, style: TextStyle(
                          color : Colors.white,fontSize: 17
                      ),),
                      Text(user.education, style: TextStyle(
                          color : Colors.white,fontSize: 10,fontWeight: FontWeight.w400
                      ),),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}
