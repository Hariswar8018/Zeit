import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/fee_performance/performance_user.dart';

import 'package:zeit/model/usermodel.dart';

import '../functions/flush.dart';

class ViewUseries extends StatefulWidget {
  bool view;
  ViewUseries({super.key,required this.view});

  @override
  State<ViewUseries> createState() => _ViewUseriesState();
}

class _ViewUseriesState extends State<ViewUseries> {
  List<UserModel> _list = [];

  String jh="Individual";
  Widget rt(String st){
    return InkWell(
        onTap : () async {
          setState(() {
            jh=st;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.white : Colors.blue.shade300, // Background color of the container
            borderRadius: BorderRadius.circular(2.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.only(left: 4.0,right: 4,top: 3,bottom: 3),
            child: Text(st, style : TextStyle(fontSize: 16, color : st==jh? Colors.black:Colors.white )),
          )
      ),
    )
    );
  }
  String ji(String oo){
    if(oo=="HR"){
      return "Organisation";
    }else{
      return oo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
        actions: [
          SizedBox(width: 65,),
          widget.view?Text("View User by : ", style : TextStyle(fontSize: 19,color:  Colors.white )):Text("View all Employees", style : TextStyle(fontSize: 19,color:  Colors.white )),
         widget.view? rt("Individual"):SizedBox(),widget.view?rt("HR"):SizedBox(),
          widget.view?SizedBox():Spacer(),
          widget.view?rt("Director"):
          IconButton(onPressed: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: SizedBox(
                    height: 350,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  <Widget>[
                          SizedBox(
                            height: 14,
                          ),
                          Container(height: 8,width: 100,decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue
                          ),),
                          SizedBox(height: 20,),
                          ListTile(
                            onTap: (){
                              setState((){
                                on=true;
                              });
                              Navigator.pop(context);
                            },
                            leading: Icon(Icons.all_inclusive),
                            title: Text("All Users",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
                            subtitle: Text("View all Users without Filter"),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          r("Approve",Icon(Icons.thumb_up_alt_rounded,color:Colors.green)),
                          r("Clarification Needed",Icon(Icons.wifi_tethering_error_outlined,color:Colors.orange)),
                          r("Block",Icon(Icons.thumb_down,color:Colors.red)),
                          SizedBox(height:10)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }, icon: Icon(Icons.filter_alt_sharp)),
          widget.view?Spacer():SizedBox(),
        ],
      ),
      body:StreamBuilder(
        stream: widget.view?FirebaseFirestore.instance
            .collection('Users').where("type",isEqualTo: ji(jh))
            .snapshots():FirebaseFirestore.instance
            .collection('Users')
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
                    "No User found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Company found with this Filter",
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
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return OUser(user: _list[index],view:widget.view );
            },
          );
        },
      ),
    );
  }
  bool on = true;
  String st="";
  Widget r(String str,Widget rt){
    return ListTile(
      onTap: (){
        setState((){
          on=false;
          st=str;
        });
        Navigator.pop(context);
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("View all ${str}ed User with Filter"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class OUser extends StatelessWidget {
  UserModel user;
  bool view;
  OUser({super.key,required this.view,required this.user});
  String timeAgoFromMilliseconds(String millisString) {

    try {
      int millis = int.parse(millisString);
      DateTime givenDate = DateTime.fromMicrosecondsSinceEpoch(millis);
      DateTime now = DateTime.now();

      // Calculate the difference between the two dates
      Duration difference = now.difference(givenDate);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} sec';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hr';
      } else if (difference.inDays < 30) {
        return '${difference.inDays} day';
      } else if (difference.inDays < 365) {
        int months = (difference.inDays / 30).floor();
        return '$months month';
      } else {
        int years = (difference.inDays / 365).floor();
        return '$years year';
      }
    }catch(e){
      return "Long time ago";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: UserC(user: user,),
                      type: PageTransitionType.bottomToTop,
                      duration: Duration(milliseconds: 200)));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pic),
            ),
            title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
            subtitle: Text("Last Login : "+timeAgoFromMilliseconds(user.lastlogin),style:TextStyle(fontWeight: FontWeight.w300,fontSize: 12)),
            trailing: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: InkWell(
              onTap: (){
                Clipboard.setData(
                    new ClipboardData(text: "ZEIT"+user.uid));
                Send.message(context, "Copied to ClipBoard", true);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.red,
                        width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(3)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0,right: 4,top: 2,bottom: 2),
                  child: Text("ZEIT ID : ZEIT"+user.uid,style: TextStyle(fontSize: 13),),
                ),
              ),
            ),
          ),
          SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.only(left:8.0),
            child: InkWell(
              onTap: (){
                Clipboard.setData(
                    new ClipboardData(text: "ZEIT"+user.uid));
                Send.message(context, "Copied to ClipBoard", true);
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(3)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0,right: 4,top: 2,bottom: 2),
                  child: Text("Email : "+user.Email,style: TextStyle(fontSize: 13),),
                ),
              ),
            ),
          ),
          SizedBox(height: 4,),
          Row(
            children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: PerformanceU(user: user),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 80)));
                  },
                  child: rt("Performance",user.status)),
              InkWell(
                onTap: () async {
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
                                await FirebaseFirestore.instance.collection("Users").doc(user.uid).delete();
                                Navigator.pop(context);
                                Send.message(context, "User File Deleted Permanently", true);
                              }catch(e){
                                Navigator.pop(context);
                                Send.message(context, "$e", false);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );

                },
                  child: rt("Delete User",user.status)),
            ],
          ),
          Row(
            children: [
              InkWell(
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: user.Email);
                      Send.message(context, "Sended Success", true);
                    }catch(e){
                      Send.message(context, "$e", false);
                    }
                  },
                  child: rt("Send Password Reset Email",user.status)),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget rt(String jh,String st){
    return InkWell(
        child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade300, // Background color of the container
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
}
