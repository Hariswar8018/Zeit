
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/training.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class TrainMe extends StatefulWidget {
  TrainMe({super.key,required this.user});
  TrainingProgram user;

  @override
  State<TrainMe> createState() => _TrainMeState();
}

class _TrainMeState extends State<TrainMe> {
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w = MediaQuery.of(context).size.width;
    String dateStr = widget.user.start;
    List<String> dateParts = dateStr.split('/');
    String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
    final targetDate = DateTime.parse(formattedDateStr);
    final currentDate = DateTime.now();
    final difference = targetDate.difference(currentDate);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  SizedBox(height:5),
                  SlideCountdown(
                    duration: difference,
                  ),
                  SizedBox(height:5),
                  Text("Training on : "+widget.user.start,style:TextStyle(fontWeight: FontWeight.w800,color:Colors.blue)),
                  SizedBox(height:2),
                  Text("Training Type : "+widget.user.type, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
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
            backgroundColor: myc(context),
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
                    content: Text('You are not Invited to this Training by HR'),
                  ),
                );
              }else if(y==1){
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Training")
                      .doc(widget.user.id).update({
                    "Pending":FieldValue.arrayUnion([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Training")
                      .doc(widget.user.id).update({
                    "Ignored":FieldValue.arrayRemove([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["TRAI"+"I"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["TRAI"+"C"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You accepted the Training Proposal ! This Training is marked as Accepted'),
                  ),
                );
              }else if(y==2){
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Training")
                      .doc(widget.user.id).update({
                    "Completed":FieldValue.arrayUnion([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Training")
                      .doc(widget.user.id).update({
                    "Pending":FieldValue.arrayRemove([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["TRAI"+"C"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["TRAI"+"N"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You completed this Traininhg ! Congratulations'),
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
      return "Accept the Training";
    } else if (h == 2) {
      return "Mark as Training Completed";
    } else {
      return "You already got Training";
    }
  }

  Widget mnu(int i){
    if(i==0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Trainer Details"),
          h1("Key Details About Trainer"),
          SizedBox(height:10),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.person,color:Colors.red),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.trainer.toString()),
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
                Icon(Icons.email,color:Colors.orange),
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
              Icon(Icons.location_on_sharp,color:Colors.purpleAccent),
              Text(widget.user.location)
            ],
          ),
          sr(),
          t1("Skills"),
          h1("Skills you will gain after Joining the Training"),
          Container(
            height: widget.user.skills.length*25,
            width: MediaQuery.of(context).size.width,
            child:ListView.builder(
              itemCount: widget.user.skills.length,
              scrollDirection: Axis.vertical,
              reverse: true,
              itemBuilder: (context, index) {
                return Container(
                  height: 25,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(" ⚫ "+widget.user.skills[index],style: TextStyle(fontWeight: FontWeight.w700),),
                  ),
                );
              },
            ),
          ),
          sr(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              t1("Feedback"),
              Spacer(),
              Icon(Icons.star,color: Colors.orangeAccent,size: 30,),
              Text(widget.user.star.toString(),style: TextStyle(fontSize:25,fontWeight: FontWeight.w800),),
              SizedBox(width: 10,),
            ],
          ),
          h1("Feedback to respond to HR"),
          SizedBox(height:6),
          widget.user.feedbackLink.isNotEmpty? Text(widget.user.feedbackLink.toString()):Row(
            children: [for(int i=0;i<5;i++)Icon(Icons.star_border_outlined,size: 33,color: Colors.orangeAccent,),]
          ),
          SizedBox(height:20),
        ],
      );
    }
    else if(i==1){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Description"),
          h1("Training Description as presented"),
          ty(widget.user.desc),
          SizedBox(height:20),
        ],
      );
    }
    else if(i==2){
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TRAI"+"I"+widget.user.id)
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
    else if(i==3) {
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TRAI"+"C"+widget.user.id)
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
    else{
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TRAI"+"N"+widget.user.id)
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

  int active=0;
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
      return "Attendance";
    }else if ( i == 4){
      return "Completed";
    }else if ( i == 5){
      return "Travel Requests";
    }else {
      return "Other";
    }
  }
  bool cont(){
    return widget.user.attendance.contains(FirebaseAuth.instance.currentUser!.uid);
  }

  String gy(int st){
    try{
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(st);
      String formattedDate = DateFormat('dd/MM/yyyy \'at\' HH:mm').format(dateTime);
      print(formattedDate); // This will print the formatted date
      return formattedDate;
    }catch(e){
      return "Not Uploaded";
    }
  }


  Widget fg(bool h,BuildContext context,String asset, String s1, String s2){
    return Padding(
      padding: const EdgeInsets.only(left:15.0,right:15),
      child: Container(
        width:MediaQuery.of(context).size.width,
        height: 85,
        decoration: BoxDecoration(
            color: h?Colors.grey:Colors.transparent,
            border: Border.all(
                color: Colors.blue,
                width: 2
            ),
            borderRadius: BorderRadius.circular(7)
        ),
        child:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: SvgPicture.asset(
              asset,
              semanticsLabel: 'Acme Logo',
              height: 50,
            ),
            title: Text(s1,style :TextStyle(fontWeight: FontWeight.w800,)),
            subtitle: Text(s2,style :TextStyle(fontWeight: FontWeight.w300,fontSize: 14)),
            trailing: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue),
          ),
        ),
      ),
    );
  }


  TextEditingController resume = TextEditingController();

  TextEditingController link1 = TextEditingController();

  TextEditingController link2 = TextEditingController();

  TextEditingController link3 = TextEditingController();

  Widget c(String s1,Widget r){
    return Container(
      height:55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color:Colors.blue,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          r,
          SizedBox(width:8),
          Text(s1,style:TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.w600))
        ],
      ),
    );
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
