import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as lk;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/add_task.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/task_class.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/provider/upload.dart';
import '../model/events.dart';
import 'dart:typed_data' as uk ;
class TaskU extends StatefulWidget {
  Task user;
  TaskU({super.key, required this.user});

  @override
  State<TaskU> createState() => _TaskUState();
}

class _TaskUState extends State<TaskU> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gh();
    });
    print("--------->"+widget.user.name);
    print(widget.user.toJson());
    print(widget.user.Incompleted);
    print(widget.user.Ignored);
    print(widget.user.Completed);
    print(widget.user.Pending);
  }

  Future<void> gh() async {
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    print("tttttttttttttttt" + widget.user.enddate);
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Parse the enddate string into a DateTime object
    DateTime endDate = dateFormat.parse(widget.user.enddate);

    // Get the current date and time
    DateTime currentDate = DateTime.now();

    // Compare the endDate with the currentDate
    if (currentDate.isAfter(endDate)) {
      await FirebaseFirestore.instance
          .collection('Company')
          .doc(_user!.source)
          .collection("Tasks")
          .doc(widget.user.id)
          .update({
        "status": "Already Completed",
      });
    } else {
      print("Current date is not beyond the end time.");
    }
  }

  @override
  Widget build(BuildContext context) {
    String dateStr = widget.user.enddate;
    List<String> dateParts = dateStr.split('/');
    String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
    final targetDate = DateTime.parse(formattedDateStr);
    final currentDate = DateTime.now();
    final difference = targetDate.difference(currentDate);

    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6, bottom: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: Tas(user: widget.user),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.blue, width: 1.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.timelapse, color: Colors.red, size: 30),
                title: Text(
                  widget.user.name,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
                subtitle: Text(
                  "Submission Date : " + widget.user.enddate,
                  style:
                  TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
                ),
              ),
              widget.user.hr?SizedBox(height: 1,):Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: 20,
                  width: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width:15),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.user.namepicol,),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Added by ${widget.user.nameol}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9,
                                  color: Colors.grey)),
                          Text(widget.user.etol,
                              style:
                              TextStyle(fontWeight: FontWeight.w300, fontSize: 6)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  widget.user.status=="Active"?Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: SlideCountdown(
                      duration: difference,
                    ),
                  ):Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 ,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade700,
                            width: 3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                            child: Text(
                              "Already Completed",
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3 - 20,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: widget.user.priority == "High"
                                ? Colors.red
                                : (widget.user.priority == "Moderate"
                                ? Colors.orange
                                : Colors.green),
                            width: 3),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Center(
                            child: Text(
                              widget.user.priority,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),

              SizedBox(height: 3),
              Text("      Client Name : " + widget.user.client_name,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey)),
              Text("      Category : " + widget.user.category,
                  style:
                  TextStyle(fontWeight: FontWeight.w300, fontSize: 15)),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class Tas extends StatefulWidget {
  Task user;
  Tas({super.key,required this.user});

  @override
  State<Tas> createState() => _TasState();
}

class _TasState extends State<Tas> {
  bool ishr(UserModel user){
    if(user.type=="Individual"){
      return false;
    }else{
      return true;
    }
  }

  @override
  int active=0;
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w = MediaQuery.of(context).size.width;
    String dateStr = widget.user.enddate;
    List<String> dateParts = dateStr.split('/');
    String formattedDateStr = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
    final targetDate = DateTime.parse(formattedDateStr);
    final currentDate = DateTime.now();
    final difference = targetDate.difference(currentDate);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: InkWell(
            onTap:()=>Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 22,)),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            InkWell(
              onTap:() async {
                if(ishr(_user!)||widget.user.nameol==_user.Name){
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Task '),
                        content: Text('You Sure to Delete the Task Permanently'),
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
                              await FirebaseFirestore.instance
                                  .collection('Company')
                                  .doc(_user!.source).collection("Tasks").doc(widget.user.id).delete();
                              Navigator.pop(context);

                              Send.message(context, "Delete Success", true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if(_user.type=="Individual"){
                  Send.message(context, "Only HR could delete this Task",false);
                } else{
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Task '),
                        content: Text('You Sure to Delete the Task Permanently'),
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
                              await FirebaseFirestore.instance
                                  .collection('Company')
                                  .doc(_user!.source).collection("Tasks").doc(widget.user.id).delete();
                              Navigator.pop(context);

                              Send.message(context, "Delete Success", true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }},
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Center(child: Icon(Icons.delete,color:Colors.white,size: 22,)),
                ),
              ),
            ),
            InkWell(
              onTap:(){
                if(ishr(_user!)||widget.user.nameol==_user.Name){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AddTask(hj: widget.user, on: true,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                } else if(_user.type=="Individual"){
                  Send.message(context, "Only HR could edit this Task",false);
                } else{
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AddTask(hj: widget.user, on: true,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Center(child: Icon(Icons.more_vert_outlined,color:Colors.white,size: 22,)),
                ),
              ),
            ),

          ],
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
                    Text(widget.user.name, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 28),),
                    SizedBox(height:5),
                    check(context)<2?Text("Waiting for Task Acceptance",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w800),)
                        :SlideCountdown(
                      duration: difference,
                    ),
                    SizedBox(height:5),
                    Text("Task End Date : "+widget.user.enddate,style:TextStyle(fontWeight: FontWeight.w800,color:Colors.blue)),
                    SizedBox(height:3),
                    Text("Task Start Date : "+widget.user.startdate, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                    SizedBox(height:10),
                    widget.user.hr?SizedBox(height: 1,):Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Container(
                        height: 40,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(widget.user.namepicol,),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Added by ${widget.user.nameol}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 14,
                                        color: Colors.grey)),
                                Text(widget.user.etol,
                                    style:
                                    TextStyle(fontWeight: FontWeight.w300, fontSize: 11)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 51, width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemCount:6,scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int qIndex) {
                          return InkWell(
                            onTap: (){
                              int y=check(context);
                              if(y<2){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('First Accept the Invitation to view full Task Info'),
                                  ),
                                );
                              }else{
                                setState((){
                                  active = qIndex ;
                                });
                              }

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
              ),
            ],
          ),
        ),
      persistentFooterButtons: [
        SocialLoginButton(
            backgroundColor: Colors.red,
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
                    content: Text('You are not Invited'),
                  ),
                );
              }else if(y==1){
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Tasks")
                      .doc(widget.user.id).update({
                    "Pending":FieldValue.arrayUnion([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Tasks")
                      .doc(widget.user.id).update({
                    "Ignored":FieldValue.arrayRemove([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["TASK"+"I"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["TASK"+"C"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You accepted this Invitation ! This task is marked as Accepted'),
                  ),
                );
                try{
                  await FirebaseFirestore.instance
                      .collection('Company')
                      .doc(_user!.source).collection("Tasks").doc(widget.user.id).update({
                    "pending":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                  });
                }catch(e){

                }
              }else if(y==2){
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Tasks")
                      .doc(widget.user.id).update({
                    "Completed":FieldValue.arrayUnion([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Tasks")
                      .doc(widget.user.id).update({
                    "Pending":FieldValue.arrayRemove([_user.uid]),
                  });
                }catch(e){
                  print("hgchvj");
                }
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayRemove(["TASK"+"C"+widget.user.id]),
                });
                await FirebaseFirestore.instance.collection("Users").doc(myid).update({
                  "jobfollower":FieldValue.arrayUnion(["TASK"+"N"+widget.user.id]),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You completed this Task ! This task is done now'),
                  ),
                );
                try{
                  await FirebaseFirestore.instance
                      .collection('Company')
                      .doc(_user!.source).collection("Tasks").doc(widget.user.id).update({
                    "complete":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                  });
                }catch(e){

                }
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
      floatingActionButton: active==2?FloatingActionButton(onPressed: (){
        Navigator.push(
            context,
            PageTransition(
                child:Add(title: widget.user.id,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200)));
      }
        ,child: Icon(Icons.upload,color: Colors.white,),
        backgroundColor: Color(0xff1491C7),
        ):SizedBox(),
    );
  }
  String gt(BuildContext context){
    int h = check(context);
    if(h==0){
      return "You are not Invited";
    }else if(h==1){
      return "Accept the Invitation";
    }else if(h==2){
      return "Mark as Complete";
    }else{
      return "Already Completed";
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

  Widget mnu(int i){
    if(i==0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Task Details"),
          h1("Key Details About Task"),
          SizedBox(height:10),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning,color:Colors.red),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Task Priority", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.priority,style:TextStyle(color:Colors.red,fontWeight: FontWeight.w800)),
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
                Icon(Icons.work,color:Colors.purpleAccent),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Client Details", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
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
                          child: Text(widget.user.client_name),
                        )),
                        SizedBox(width:9),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Background color of the container
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),child: Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                          child: Text(widget.user.client_id),
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
                Icon(Icons.timelapse_outlined,color:Colors.orange),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.category),
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
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                PageTransition(
                  child: Google_S(lat: widget.user.lat, lon: widget.user.lon),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 50),
                ),
              );
            },
            child: Row(
              children: [
                Icon(Icons.location_on_sharp,color:Colors.deepPurpleAccent),
                SizedBox(width: 10,),
                Container(
                    width: 250,
                    child: Text(widget.user.assigndate.isEmpty||widget.user.assigndate==""||widget.user.assigndate==" "?widget.user.assigndate:"This Task is Not an Meetup Task")),
                Spacer(),
                widget.user.lat!=0.0?Icon(Icons.zoom_out_map,size: 35,color: Colors.red,):SizedBox()
              ],
            ),
          ),
          SizedBox(height:30)
        ],
      );
    }
    else if(i==1){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          t1("Description"),
          h1("Task Description as presented"),
          ty(widget.user.description),
          SizedBox(height:20),
        ],
      );
    }
    else if(i==2){
      UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
      List<FileModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Company')
                .doc(_user!.source).collection("Tasks").doc(widget.user.id).collection("Files")
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
                        "No Employees completed",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "No Employees who have completed your Task",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }
              final data = snapshot.data?.docs;
              _list.clear();
              _list.addAll(data?.map((e) => FileModel.fromJson(e.data())).toList() ?? []);
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
                    child: FileUser(user: _list[index]),
                  );
                },
              );
            },
          )
      );
    }
    else if(i==3){
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TASK"+"I"+widget.user.id)
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
    else if(i==4){
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TASK"+"C"+widget.user.id)
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
    }else {
      List<UserModel> _list = [];
      return  Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child:  StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users').where("jobfollower",arrayContains: "TASK"+"N"+widget.user.id)
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
                        "No Employees completed",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "No Employees who have completed your Task",
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
      return "Files";
    }else if ( i == 3){
       return "Invited";
     }else if ( i == 4){
       return "Progress";
     }else if ( i == 5){
      return "Completed";
    }else if ( i == 6){
      return "Employment History";
    }else if ( i == 7){
      return "Travel Requests";
    }else {
      return "Other";
    }
  }

  Widget w1()=>SizedBox(height:10);

  Widget w2()=>SizedBox(height:20);

  Widget t1(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),);

  Widget t2(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);

  Widget h1(String s2)=>Text(s2, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),);
}

class Add extends StatefulWidget {
  String title;
  Add({super.key,required this.title});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {

  bool up=false;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Upload Task Files",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Text("Topic Name of ${st} ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            dcc(name,"","Please type topic of post",false),
            SizedBox(height: 10,),
            Text("Upload Type ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
            Row(
              children: [
                rt("PDF"),
                rt("Picture"),
                rt("XML/DOC/DOCX"),
                rt("Link"),
              ],
            ),
            SizedBox(height: 10,),
            st=="Link"?
            dcc(link,"Enter Link","Enter Link to file or Web",false):
                Center(
                  child: InkWell(
                    onTap: () async {
                     setState(() {
                       up=true;
                     });
                      if(st=="PDF"){
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uploading your PDF'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            final storageRef = lk.FirebaseStorage.instance.ref();
                            final mountainsRef = storageRef.child("Task_${widget.title}_${name.text}.pdf"); // Change the filename as needed
                            await mountainsRef.putFile(file);
                            String downloadUrl = await mountainsRef.getDownloadURL();
                            setState(() {
                              link.text=downloadUrl;
                            });
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You cancelled PDF picking'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$e"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                      else if(st=="Picture"){
                        try {
                          uk.Uint8List? file = await pickImage(ImageSource.gallery);
                          if (file != null) {
                            String photoUrl = await StorageMethods().uploadImageToStorage(
                                'Company_Task', file, true);
                            setState(() {
                              link.text=photoUrl;
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Pic Uploaded"),
                            ),
                          );
                        }catch(e){
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      }
                      else{
                        try {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uploading your PDF'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            final storageRef = lk.FirebaseStorage.instance.ref();
                            final mountainsRef = storageRef.child("Task_${widget.title}_${name.text}.pdf"); // Change the filename as needed
                            await mountainsRef.putFile(file);
                            String downloadUrl = await mountainsRef.getDownloadURL();
                            setState(() {
                              link.text=downloadUrl;
                            });
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('You cancelled PDF picking'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("$e"),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                     setState(() {
                       up=false;
                     });
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue.shade100,
                      child: up?CircularProgressIndicator():as(),
                    ),
                  ),
                ),
            SizedBox(height: 8,),
            st=="Link"? SizedBox(): Center(child: Text("Click on above Button to Browse Files")),
            SizedBox(height: 15,),
            link.text.isEmpty?SizedBox():Padding(
              padding: const EdgeInsets.only(left: 9.0, right: 9),
              child: SocialLoginButton(
                  backgroundColor: Colors.blue,
                  height: 40,
                  text: 'Add the ${st} to this Task',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    String d=DateTime.now().microsecondsSinceEpoch.toString();
                    FileModel u =FileModel(name:_user!.Name, pic: _user.pic, id: d,
                        topic: name.text, pdf: st=="PDF"?true:false,
                        outside: st=="Picture"?false:true, link: link.text
                    );
                   await  FirebaseFirestore.instance
                        .collection('Company')
                        .doc(_user!.source).collection("Tasks").doc(widget.title).collection("Files").doc(d)
                        .set(u.toJson());
                   Navigator.pop(context);
                  }),
            ),
          ],
        ),
      )
    );
  }
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  Widget as(){
    if(st=="PDF"){
      return Icon(Icons.picture_as_pdf,size: 50,);
    }else if(st=="Picture"){
      return Icon(Icons.photo,size: 50,);
    }else{
      return Icon(Icons.upload_file_rounded,size: 50,);
    }
  }
  TextEditingController link = TextEditingController();
  TextEditingController name = TextEditingController();
  String st="PDF";
  Widget dcc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 1,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
        onChanged: (value){
          setState(() {

          });
        },
      ),
    );
  }
  Widget rt(String jh){
    return InkWell(
        onTap : () async {
          setState(() {
            st=jh;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
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

class FileUser extends StatelessWidget{
  FileModel user;
  FileUser({
   required this.user
});

  @override
  Widget build(BuildContext context){
    if(user.pdf){
      return rpdf(context);
    }else if(!user.outside){
      return rpic(context);
    }else if(!user.pdf){
      return rxml(context);
    }else{
      return rout(context);
    }
  }
  Widget rpdf(BuildContext context)=>InkWell(
    onTap: (){
      Navigator.push(
          context,
          PageTransition(
              child: MyPdf(str: user.link,),
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 400)));
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://w7.pngwing.com/pngs/193/938/png-transparent-pdf-computer-icons-theme-cool-business-card-background-pdf-icon-miscellaneous-text-logo.png"),
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.pic),
                      ),
                    ),SizedBox(width: 6,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.topic, style: TextStyle(
                          color : Colors.white,fontWeight: FontWeight.w600,
                        ),),
                        Text("by : "+user.name, style: TextStyle(
                            color : Colors.white,fontWeight: FontWeight.w300,fontSize: 10
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),
  );

  Widget rpic(BuildContext context)=>InkWell(
    onTap: (){
      Navigator.push(
          context,
          PageTransition(
              child: MyPic(link: user.link,),
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 400)));
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(user.link),
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.pic),
                      ),
                    ),SizedBox(width: 6,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.topic, style: TextStyle(
                          color : Colors.white,fontWeight: FontWeight.w600,
                        ),),
                        Text("by : "+user.name, style: TextStyle(
                            color : Colors.white,fontWeight: FontWeight.w300,fontSize: 10
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),
  );
  Widget rout(BuildContext context)=>InkWell(
    onTap: (){

    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://img.freepik.com/premium-psd/web-red-button-icon-3d-render-transparent-background_568120-2131.jpg"),
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.pic),
                      ),
                    ),SizedBox(width: 6,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.topic, style: TextStyle(
                          color : Colors.white,fontWeight: FontWeight.w600,
                        ),),
                        Text("by : "+user.name, style: TextStyle(
                            color : Colors.white,fontWeight: FontWeight.w300,fontSize: 10
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),
  );
  Widget rxml(BuildContext context)=>InkWell(
    onTap: () async {
      final Uri _url = Uri.parse(user.link);
      if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
      }
    },
    child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://www.staceyeburke.com/wp-content/uploads/2019/04/Folders-770x484.jpg"),
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.pic),
                      ),
                    ),SizedBox(width: 6,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.topic, style: TextStyle(
                          color : Colors.white,fontWeight: FontWeight.w600,
                        ),),
                        Text("by : "+user.name, style: TextStyle(
                            color : Colors.white,fontWeight: FontWeight.w300,fontSize: 10
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    ),
  );
}
class FileModel {
  late final String name;
  late final String pic;
  late final String id;
  late final String topic;
  late final bool pdf;
  late final bool outside;
  late final String link;

  FileModel({
    required this.name,
    required this.pic,
    required this.id,
    required this.topic,
    required this.pdf,
    required this.outside,
    required this.link,
  });

  FileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    pic = json['pic'] ?? '';
    id = json['id'] ?? '';
    topic = json['topic'] ?? '';
    pdf = json['pdf'] ?? false;
    outside = json['outside'] ?? false;
    link = json['link'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['pic'] = pic;
    data['id'] = id;
    data['topic'] = topic;
    data['pdf'] = pdf;
    data['outside'] = outside;
    data['link'] = link;
    return data;
  }
}
