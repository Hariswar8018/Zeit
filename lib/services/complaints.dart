import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_request.dart';
import 'package:zeit/cards/request_C.dart';
import 'package:zeit/main_pages/empty.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/services/hr_letters.dart';

import '../model/approval.dart';
import '../provider/declare.dart';

class Complaints extends StatefulWidget {
  Complaints({super.key});

  @override
  State<Complaints> createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  int active = 0;
  List<Request> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return _user!.source.isNotEmpty?Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Organisation Complaints",style:TextStyle(color:Colors.white,fontSize: 23)),
          backgroundColor: Color(0xff1491C7),
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
                    child: AddR(str: "Complaints",),
                    type: PageTransitionType.rightToLeft,
                    duration: Duration(milliseconds: 600)));
          },
          child: Container(
            width: 140, height : 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.escalator_warning,color :Colors.white),
                    Text("Add Complaint", style : TextStyle(color : Colors.white)),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 40, width: MediaQuery
                  .of(context)
                  .size
                  .width,
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 3, scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int qIndex) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          active = qIndex;
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: ayu(qIndex)
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 13.0, right : 13),
              child: Divider(),
            ),
            Expanded(child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Company').doc(_user!.source).collection("Complaints").where("status", isEqualTo: ga(active))
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
                          "No Complaints Found",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Organisation don't have any ${ga(active)} Complaints ",
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
            ),)
          ],
        )
    ):Empty();
  }
  Widget ayu(int i ){
    return Text(ga(i), style: TextStyle(fontSize: active  == i ?18 : 16, fontWeight: FontWeight.w600,color :active ==i? Colors.black:Colors.grey.shade500),);
  }
  String ga(int i){
    if ( i == 0 ){
      return "Active";
    }else if ( i == 1){
      return "Approved";
    }else if ( i == 2){
      return "Rejected";
    }else if ( i == 3){
      return "About";
    }else if ( i == 4){
      return "Files";
    }else if ( i == 5){
      return "Travel Requests";
    }else {
      return "None";
    }
  }
}
