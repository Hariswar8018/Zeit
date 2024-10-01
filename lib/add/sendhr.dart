import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/model/feeds.dart';
import 'package:zeit/model/task_class.dart';
import 'package:zeit/notification/notify_all.dart';

import '../functions/give_back_user.dart';
import '../model/approval.dart';
import '../model/usermodel.dart';
import '../provider/declare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/services/messagecard.dart';

import '../model/usermodel.dart';

class Hrchats extends StatelessWidget {
  UserModel user;
  Hrchats({super.key,required this.user});
  TextEditingController cg = TextEditingController();
  List<UserModel> _list = [];
  String yu = FirebaseAuth.instance.currentUser!.uid;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Container(
          width : MediaQuery.of(context).size.width  , height : 50,
          decoration: BoxDecoration(
            color: Colors.blue.shade50, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left : 18.0, right : 10),
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,  hintText: "Find Employees to Send",
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ),
      body: cg.text.isEmpty?StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo: user.source)
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
                    "Do try Searching with designation or with Filter",
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
      ):
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("name", isLessThanOrEqualTo: cg.text).where("source",isEqualTo: user.source)
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
                    "Do try Searching with designation or with Filter",
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
              crossAxisCount: 3, // Number of columns
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatUser(user: _list[index]),
              );
            },
          );
        },
      ),
    );
  }
}
class ChatUser extends StatelessWidget {
  UserModel user ;
  ChatUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: AddHR(user: user,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 400)));
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
                          color : Colors.white
                      ),),
                      Text(user.education, style: TextStyle(
                          color : Colors.white
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

class AddHR extends StatefulWidget {
  UserModel user;
  AddHR({super.key, required this.user});
  @override
  State<AddHR> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddHR> {

  void initState(){
    super.initState();
    v();
  }
  void v(){
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    status.text = "Active" ;
    name.text = widget.user!.Name ;
    desi.text = widget.user.education;
    join.text = widget.user.lastlogin;
    setState(() {

    });
  }
  String reason = "Bank Account";
  TextEditingController name = TextEditingController();
  TextEditingController desi = TextEditingController();
  TextEditingController join = TextEditingController();
  TextEditingController request = TextEditingController();
  TextEditingController status = TextEditingController();
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Send HR Letter",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            t("Employee Name"),
            SizedBox(height:9),
            aa(name),
            t("Employee Designation"),
            SizedBox(height:9),
            aa(desi),
            t("Their Last Login Date & Time"),
            SizedBox(height:9),
            aa(join),
            t("Description"),
            SizedBox(height:9),
            a(request),
            SizedBox(height:9),
           Column(
              children: [
                t("HR Letter"),
                Row(
                  children: [
                    rt("Termination Letter"), rt("Warning Letter"),
                  ],
                ),

              ],
            ),

          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Send $st',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                String g = DateTime.now().millisecondsSinceEpoch.toString();
                String ui = FirebaseAuth.instance.currentUser!.uid;
                Request h = Request(name: name.text, designation:desi.text ,
                    joining: join.text, request: request.text, change: true,
                    reason: desi.text, userid: widget.user!.uid, id: g, pic : widget.user.pic,
                    topic:st, queries: false, description: "",
                    attachment: " ", status: "Active",
                    time: g, response: "", date1: '', date2: ''
                );
                await  FirebaseFirestore.instance.collection("Company")
                    .doc(_user!.source).collection("Requests")
                    .doc(g).set(h.toJson());
                as(request.text);
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
  void as(String desc){
    try {
      UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
      NotifyAll.sendNotification(
          "$st sended by " + _user!.Name, desc,widget.user.token);
    }catch(e){
      print(e);
    }
  }
  String pic="",name1="",name2="";
  String st = "Visa" ;
  Widget rt(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            st = jh ;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }

  Widget a(TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0),
      child: TextFormField(
        controller: c, maxLines: 4,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(), // No border
        ),
      ),
    );
  }

  Widget aa(TextEditingController c,){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,enabled: false,
          border: OutlineInputBorder(), // No border
        ),
      ),
    );
  }
  Widget t(String str){
    return Text(str,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
  }
}

