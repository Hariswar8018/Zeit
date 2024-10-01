import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeitt/cards/profile_organisation.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/functions/notification.dart';
import 'package:zeitt/notification/notify_all.dart';

import '../model/organisation.dart';

class Manually extends StatefulWidget {
  Manually({super.key});

  @override
  State<Manually> createState() => _ManuallyState();
}

class _ManuallyState extends State<Manually> {
  List<OrganisationModel> _list = [];
  TextEditingController cg = TextEditingController();
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
                  isDense: true,  hintText: "Search your Organisation in zeitt",
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company').where("name",isLessThanOrEqualTo: cg.text)
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
                    "No Organisation found",
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
          _list.addAll(data?.map((e) => OrganisationModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return OUser(user: _list[index] );
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
      subtitle: Text("View all ${str}ed Organisation with Filter"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class OUser extends StatelessWidget {
  OrganisationModel user;
  OUser({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: (){
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 220,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 15),
                          Container(
                            width: 80, height: 10,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(20)
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(textAlign: TextAlign.center,
                              "Add youself to this Organisation",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20)),
                          SizedBox(height: 9),
                          SizedBox(height: 9),
                          Text(textAlign: TextAlign.center,
                              "We will send Notification to HR/Director who will add you once confirmed",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18)),
                          SizedBox(height: 9),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Container(
                                  width : MediaQuery.of(context).size.width , height : 60,
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent, // Background color of the container
                                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                  ),
                                  child : InkWell(
                                    onTap: () async {
                                      try {
                                        await FirebaseFirestore.instance
                                            .collection("Users").doc(
                                            FirebaseAuth.instance.currentUser!
                                                .uid).update({
                                          "joiningd": user.id,
                                        });
                                        NotifyAll.sendallhradmin(user.id, "New Employee Request Access", "A New Employee/Admin asked for Adding to your Organisation");

                                        Send.message(
                                            context, "Your Request Sent", true);
                                      }catch(e){
                                        Send.message(context, "$e", false);
                                      }
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child:  Center(child: Text("Yes ! Send Notification", style : TextStyle( fontSize : 17, color : Colors.black, fontWeight: FontWeight.w900))),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.logo),
            ),
            title: Text(user.name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
            subtitle: Text(user.address),
            trailing: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: ProO(user: user,),
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 30)));
                },
                child: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue)),
          ),
        ],
      ),
    );
  }
  Widget rt(String jh,String st){
    return InkWell(
        onTap : () async {
          await FirebaseFirestore.instance.collection("Company").doc(user.id).update({
            "status":jh,
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
