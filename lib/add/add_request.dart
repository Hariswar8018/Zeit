import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/model/feeds.dart';
import 'package:zeit/model/task_class.dart';

import '../model/approval.dart';
import '../model/usermodel.dart';
import '../provider/declare.dart';

class AddR extends StatefulWidget {
  AddR({super.key, required this.str});
String str;
  @override
  State<AddR> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddR> {

  void initState(){
    super.initState();
    v();
  }
  void v(){
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    status.text = "Active" ;
    name.text = _user!.Name ;
    desi.text = _user.education;
    join.text = _user.lastlogin;
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
        title: Text("Add Request for " + widget.str,style:TextStyle(color:Colors.white,fontSize: 23)),
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
            t("Your Name"),
            SizedBox(height:9),
            aa(name),
            t("Your Designation"),
            SizedBox(height:9),
            aa(desi),
            t("Your Last Login Date & Time"),
            SizedBox(height:9),
            aa(join),
            t("Your Request"),
            SizedBox(height:9),
            a(request),
            SizedBox(height:9),
            t("Request Reason ?"),
            Row(
              children: [
                rt("Visa"), rt("BroadBand Connection"),
              ],
            ),
            Row(
              children: [
                rt("Gas Connection"), rt("Bank Account Open"),
              ],
            ),
            Row(
              children: [
                rt("Govt. Related"), rt("Others"),
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
              text: 'Add Event Now',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                String g = DateTime.now().millisecondsSinceEpoch.toString();
                String ui = FirebaseAuth.instance.currentUser!.uid;
                Request h = Request(name: name.text, designation:desi.text ,
                    joining: join.text, request: request.text, change: true,
                    reason: st, userid: _user!.uid, id: g, pic : _user.pic,
                    topic: widget.str, queries: false, description: "",
                    attachment: " ", status: "Active",
                    time: g, response: "", date1: '', date2: ''
                );
                await  FirebaseFirestore.instance.collection("Company")
                    .doc(_user!.source).collection("Requests")
                    .doc(g).set(h.toJson());
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
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
