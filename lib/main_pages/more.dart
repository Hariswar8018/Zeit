import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/feeds.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/fee_performance/performance_user.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/organisation/change.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/services/leave.dart';
import 'package:zeit/superadmin/admin_login.dart';

import '../cards/profile_organisation.dart';
import '../functions/flush.dart';
import '../functions/notification.dart';
import '../main.dart';
import '../model/organisation.dart';
import '../organisation/info.dart';
import '../services/attendance.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body : SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
                onTap : (){
                  if(_user!.source.isEmpty){
                    Send.message(context, "This function will work once you are Attached to Organisation", false);
                  }else{
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Feeds(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200)));
                  }
                  print("rrukuli");

            },
                child: a(Icon(Icons.content_copy,color :  Colors.blue), "Feeds", "Discover Blogs")),
            InkWell(
                onTap: (){
                  if(_user!.source.isEmpty){
                    Send.message(context, "This function will work once you are Attached to Organisation", false);
                  }else{
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Leave(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400)));
                  }

                },
                child: a(Icon(Icons.airport_shuttle,color :  Colors.green), "Leave Tracker", "Track Leave Records")),
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
                child: a(Icon(Icons.watch_later,color :  Colors.amber), "Time Tracker", "Track your Schedule")),
            InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Attendance(time: false,uid: FirebaseAuth.instance.currentUser!.uid),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: a(Icon(Icons.scatter_plot,color :  Colors.blueGrey), "Attendance", "Fill Attendance")),
            InkWell(
                onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PerformanceU(user: _user!,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200)));
                },
                child: a(Icon(Icons.leaderboard,color :  Colors.blue), "Performance", "Track Performances / Extras")),
            a(Icon(Icons.file_copy,color :  Colors.black), "Files", "Discover Files Shared / Uploaded"),
            InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: UserC(user: _user!,),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 50)));
                },
                child: a(Icon(Icons.person,color :  Colors.purpleAccent), "User Profile", "See / Manage your all Profile")),
            InkWell(
                onTap: () async {

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
                              child: ProO(user: user,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 600)));
                    } else {
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Create Organisation?'),
                            content: Text("Once created, Organisation can't able to add you and you will from now on manage Organisation in our App"),
                            actions: [
                              ElevatedButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              ElevatedButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  try {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: Step2(),
                                            type: PageTransitionType.bottomToTop,
                                            duration: Duration(milliseconds: 300)));

                                  }catch(e){
                                    Send.message(context, "${e}", false);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );

                    }
                  } catch (e) {
                    print("Error fetching user by uid: $e");
                    Send.message(context, "$e", false);
                  }
                },onLongPress: (){
                  String? st = FirebaseAuth.instance.currentUser!.email;
                  if(st=="hari@g.com"||st=="hariswarsamasi@gmail.com"||st=="brnrinnovations@gmail.com"){
                    print("Ayus");
                    Navigator.push(
                        context,
                        PageTransition(
                            child: AdminLogin(),
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 400)));
                  }
            },
                child: a(Icon(Icons.business,color :  Colors.deepPurpleAccent), "Organisation", "Settings your Organisation Level")),
            InkWell(
                onTap: (){
                  if(_user!.source.isEmpty){
                    Send.message(context, "This function will work once you are Attached to Organisation", false);
                  }else{
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Notify(),
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 400)));
                  }

                },
                child: a(Icon(Icons.announcement,color :  Colors.purple), "Announments", "Discover Notices, Cases, Salary Hikes")),
            SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Logout? '),
                      content: Text('You Sure to LOGOUT from the App'),
                      actions: [
                        ElevatedButton(
                          child: Text('No'),
                          onPressed: () {
                           Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Splash(),
                                    type: PageTransitionType.bottomToTop,
                                    duration: Duration(milliseconds: 300)));
                            Send.message(context, "Log Out Success", true);
                          },
                        ),
                      ],
                    );
                  },
                );

              }, icon: Icon(Icons.login, color : Colors.red,size: 35,)),
              IconButton(onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Attention ! Delete from Organisation?'),
                      content: Text('You Sure to detach from Organisation. You will be removed from Organisation and some data may be Permanent Deleted'),
                      actions: [
                        ElevatedButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            try {
                              User? user = FirebaseAuth.instance.currentUser;
                              await FirebaseFirestore.instance.collection(
                                  "Users").doc(user!.uid).update({
                                "source": "",
                              });
                              await FirebaseAuth.instance.signOut();
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Splash(),
                                      type: PageTransitionType.bottomToTop,
                                      duration: Duration(milliseconds: 300)));
                              Send.message(context, "Log Out Success", true);
                            }catch(e){
                              Send.message(context, "${e}", false);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              }, icon: Icon(Icons.no_accounts_outlined, color : Colors.orange,size: 35,)),
              IconButton(onPressed: () async {
                Navigator.pop(context);
                fz(context);
              }, icon: Icon(Icons.delete, color : Colors.red,size: 35,)),
            ],
          ),
            SizedBox(height: 30,),
          ],
        ),
      )
    );
  }
  Future<void> fz(BuildContext context) async {
    await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm to Delete?'),
        content: Text('Last chance ! Delete everything Permanently?'),
        actions: [
          ElevatedButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () async {
              try {
                User? user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance.collection(
                    "Users").doc(user!.uid).delete();
                await user!.delete();
                await FirebaseAuth.instance.signOut();

                Navigator.push(
                    context,
                    PageTransition(
                        child: Splash(),
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 100)));
                Send.message(context, "Account Delete Success", true);
              }catch(e){
                Send.message(context, "${e}", false);
              }
            },
          ),
        ],
      );
    },
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
