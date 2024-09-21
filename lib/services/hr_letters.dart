import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_request.dart';
import 'package:zeit/model/approval.dart';
import 'package:zeit/model/usermodel.dart';

import '../cards/request_C.dart';
import '../provider/declare.dart';
class HrLetters extends StatelessWidget {
  const HrLetters({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("HR Letters",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: Column(
        children:[
          InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Hr(str : "Address"),
                        type: PageTransitionType.leftToRight,
                        duration: Duration(milliseconds: 600)));
              },
              child: a(Icon(Icons.home,color :  Colors.amber), "Address Proof", "Track your Schedule")),
          InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Hr(str : "Bonafide"),
                        type: PageTransitionType.leftToRight,
                        duration: Duration(milliseconds: 600)));
              },
              child: a(Icon(Icons.newspaper,color :  Colors.blueGrey), "Bonafide Letter", "Fill Attendance")),
          InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Hr(str : "Experience"),
                        type: PageTransitionType.leftToRight,
                        duration: Duration(milliseconds: 600)));
              },
              child: a(Icon(Icons.accessible_forward,color :  Colors.blue), "Experience Letter", "Track Performances / Extras")),
        ]
      ),
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

class Hr extends StatelessWidget {
  String str;
  Hr({super.key, required this.str});
  List<Request> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text(str+" Letter",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      floatingActionButton:InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: AddR(str: str,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child: Container(
          width: 130, height : 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.request_page,color :Colors.white),
                  Text(" Request Now", style : TextStyle(color : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company').doc(_user!.source).collection("Requests").where("topic", isEqualTo: str)
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
                    "No ${str} Letter Found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks like you haven't Requested any ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => Request.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return RequestC(user: _list[index], b: false);
            },
          );
        },
      ),
    );
  }
}
