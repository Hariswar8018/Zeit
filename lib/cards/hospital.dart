import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/hospital.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

import '../model/events.dart';

class HUser extends StatelessWidget {
  Hospital user;
  HUser({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
   return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10,bottom: 4),
      child: InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: HUserF(user:user),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200)));
        },
        child: Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Colors.blue,
                    width: 1.5
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width-130,
                          child: Text(user.name, style: TextStyle(fontWeight: FontWeight.w900,fontSize: 22,color:Colors.black),)),
                      Spacer(),
                      Icon(Icons.bookmark_add_outlined),
                    ],
                  ),
                  SizedBox(height:10),
                  Text("By : " +user.company, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.black),),
                  Text("Type : "+user.type, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                  SizedBox(height:7),
                  Container(
                    width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                    decoration: BoxDecoration(
                      // Background color of the container
                      border: Border.all(
                          color: Colors.red,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(5.0), // Rounded corners
                    ),
                    child : Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Center(child: Text("Not Applied",style: TextStyle(fontWeight: FontWeight.w700),)),
                    ),
                  ),
                  SizedBox(height:4),
                  ],
              ),
            )),
      ),
    );
  }
}

class HUserF extends StatefulWidget {
  Hospital user;
   HUserF({super.key,required this.user});

  @override
  State<HUserF> createState() => _HUserFState();
}

class _HUserFState extends State<HUserF> {
  int active=0;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: InkWell(
            onTap:()=>Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 18,)),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(widget.user.pic,height: 240,width: w,fit: BoxFit.cover,),
              Padding(
                padding: const EdgeInsets.only(left:9.0,right: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height:10),
                    Text(widget.user.company, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 28),),
                    SizedBox(height:8),
                    Text("Website Link : "+widget.user.link,style:TextStyle(fontWeight: FontWeight.w800,color:Colors.blue)),
                    SizedBox(height:2),
                    Text("Insurance Type : "+widget.user.type, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                    SizedBox(height:10),
                    Container(
                      height: 51, width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount:5,scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int qIndex) {
                          return InkWell(
                            onTap: (){
                              setState((){
                                active = qIndex ;
                              });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: ayu(qIndex)
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      thickness: 0.5,
                    ),
                    SizedBox(height:10),
                    mnu(active),
                  ],
                ),
              )
            ],
          ),
        ),
      persistentFooterButtons: [
        SocialLoginButton(
            backgroundColor:myc(context),
            height: 40,
            text: gt(context),
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              String myid = FirebaseAuth.instance.currentUser!.uid;
              int y=check(context);
              if(y==0){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You are not Invited to this Health Benefit by HR'),
                  ),
                );
              }else if(y==1){
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["HEAL"+"I"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["HEAL"+"C"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You accepted this Invitation ! This Health Benefit is marked as Accepted'),
                  ),
                );
              }else if(y==2){
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["HEAL"+"C"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["HEAL"+"N"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You completed this HEAL ! This Health Benefit is done for you'),
                  ),
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('This is already Completed'),
                  ),
                );
              }
              UserProvider _userprovider = Provider.of(context, listen: false);
              await _userprovider.refreshuser();
            }),
      ],
    );
  }
  Color myc(BuildContext ){
    int hj=check(context);
    if(hj==1){
      return Colors.red;
    }else if(hj==2){
      return Colors.blue;
    }else{
      return Colors.blueGrey.shade300;
    }
  }
  int check(BuildContext context){
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    for(String huy in _user!.follower){
      String h1=huy.substring(0,4);
      String h2=huy.substring(4,5);
      String h3=huy.substring(5);

      if(h3==widget.user.id){
        print(h1);
        print(h2);print(h3);
        print(huy);
        if(h2=="L"){
          return 4;
        }else if(h2=="N"){
          return 3;
        }else if(h2=="C"){
          return 2;
        }else if(h2=="I"){
          return 1;
        }else{
          return 0;
        }
      }
    }
    return 0;
  }
  String gt(BuildContext context) {
    int h = check(context);
    if (h == 0) {
      return "You are not Invited";
    } else if (h == 1) {
      return "Accept the Invitation";
    } else if (h == 2) {
      return "Mark as Health Benefit Got";
    } else {
      return "Already got to Health Benefit";
    }
  }

  Widget mnu(int i){
    if(i==0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Insurance Details"),
          h1("Key Details About Insurer"),
          SizedBox(height:10),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.factory,color:Colors.purpleAccent),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Insurance Name", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.company),
                    )),
                  ],
                ),
              ],
            ),
          ),w2(),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.email,color:Colors.red),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Background color of the container
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),child: Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                          child: Text(widget.user.email),
                        )),
                        SizedBox(width:9),

                      ],
                    ),
                    SizedBox(height: 5,),
                  ],
                ),
              ],
            ),
          ),w2(),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.phone,color:Colors.green),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.phone),
                    )),
                  ],
                ),
              ],
            ),
          ),
          w1(),

          sr(),
          t1("Location"),
          w1(),
          Row(
            children: [
              Icon(Icons.location_on_sharp,color:Colors.orange),
              Text(widget.user.location)
            ],
          ),
          sr(),
          t1("Feedback"),
          h1("Feedback to respond to User"),
          Text(widget.user.feedbackLink.toString()),
          SizedBox(height:20),
        ],
      );
    }else if(i==1){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Description"),
          h1("Health Description as presented"),
          ty(widget.user.desc),
          SizedBox(height:20),
        ],
      );
    }else if(i==2){
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "HEAL"+"I"+widget.user.id)
                .snapshots() ,
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
                        "No Employees found",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Looks likes we can't find any peers",
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
                    child: ChatUser(user: _list[index]),
                  );
                },
              );
            },
          )
      );
    }else if(i==3){
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "HEAL"+"C"+widget.user.id)
                .snapshots() ,
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
                        "No Employees found",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Looks likes we can't find any peers",
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
                    child: ChatUser(user: _list[index]),
                  );
                },
              );
            },
          )
      );
    }else{
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "HEAL"+"N"+widget.user.id)
                .snapshots() ,
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
                        "No Employees found",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Looks likes we can't find any peers",
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
                    child: ChatUser(user: _list[index]),
                  );
                },
              );
            },
          )
      );
    }
  }

  Widget ayu(int i ){
    return Container(
      child :  Column(
        children: [
          Text(ga(i), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color : Colors.black),),
          active == i ? Container(
            height: 5,  width: 24, decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(70)
          ),
          ) : SizedBox(width : 2)
        ],
      ),
    );
  }
  String ga(int i){
    if ( i == 0 ){
      return "Overview";
    }else if ( i == 1){
      return "Decription";
    }else if ( i == 2){
      return "Invited";
    }else if ( i == 3){
      return "Accepted";
    }else if ( i == 4){
      return "Benefit Got";
    }else if ( i == 5){
      return "Travel Requests";
    }else {
      return "Other";
    }
  }
  Widget ty(String s2)=>Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(s2, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
  );
  Widget sr(){
    return Column(
        children:[
          w1(),
          Divider(
            thickness: 0.5,
          ),
          SizedBox(height:10),
        ]
    );
  }
  Widget w1()=>SizedBox(height:10);

  Widget w2()=>SizedBox(height:20);

  Widget t1(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),);

  Widget t2(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);

  Widget h1(String s2)=>Text(s2, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),);
}
