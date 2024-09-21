import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zeit/cards/request_C.dart';
import 'package:zeit/main_pages/empty.dart';
import 'package:zeit/model/usermodel.dart';

import '../model/approval.dart';
import '../provider/declare.dart';

class Approval extends StatefulWidget {
  Approval({super.key});

  @override
  State<Approval> createState() => _ApprovalsState();
}

class _ApprovalsState extends State<Approval> {
  int active = 0;
  List<Request> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("My Cases"),
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
                  .collection('Company').doc(_user!.source).collection("Requests").where("status", isEqualTo: ga(active))
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
                          "No Request Found",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Looks like you haven't any ${ga(active)} Requests ",
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
    );
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
