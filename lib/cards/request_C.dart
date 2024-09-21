import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_request.dart';
import 'package:zeit/model/approval.dart';
import 'package:zeit/model/time.dart';
import 'package:zeit/model/usermodel.dart';

import '../provider/declare.dart';
class RequestC extends StatefulWidget {
  RequestC({super.key, required  this.user, required this.b});
  Request user; bool b ;
  @override
  State<RequestC> createState() => _RequestCState();
}

class _RequestCState extends State<RequestC> {
  bool teac() {
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    if (_user!.type== "Organisation") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          if(teac()){
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 550,
                child: SizedBox(
                  height: 550,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  <Widget>[
                        SizedBox(
                    height: 10,
                        ),
                        Container(
                          width: 80,height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue
                          ),
                        ),
                        SizedBox(height: 20,),
                        r("Reject",Icon(Icons.close_rounded,color:Colors.blue)),
                        r("Apply",Icon(Icons.no_cell,color:Colors.red)),
                        ListTile(
                          onTap: (){
                            setState((){

                            });
                          },
                          leading: Icon(Icons.upload,color:Colors.green),
                          title: Text("Approve with Upload",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
                          subtitle: Text("Approve the Request with Upload"),
                          trailing: Icon(Icons.arrow_downward_outlined),
                        ),
                        SizedBox(height:10),
                        InkWell(
                          onTap: () async {
                            try {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                              if (result != null) {
                                File file = File(result.files.single.path!);
                                final storageRef = FirebaseStorage.instance.ref();
                                final mountainsRef = storageRef.child("${DateTime.now().toString()}.pdf"); // Change the filename as needed
                                await mountainsRef.putFile(file);
                                String downloadUrl = await mountainsRef.getDownloadURL();
                                f(downloadUrl);
                              } else {
                                // User canceled file picking
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Sucess ! Pdf uploaded'),
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
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.upload,color:Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("OR"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:18.0,right:18,bottom:5),
                          child: TextFormField(
                            controller: link,
                            decoration: InputDecoration(
                              labelText: 'Link of Upload',suffixIcon: IconButton(onPressed: (){
                                f(link.text);
                            }, icon: Icon(Icons.send)),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );}
        },
        child: Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:4.0,right:4,bottom:4),
                    child: Text(widget.user.topic,style: TextStyle(color:Colors.blue,fontWeight: FontWeight.w900),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: (){

                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.user.pic),
                          radius: 30,
                        ),
                      ),
                      SizedBox(width : 15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.user.name, style : TextStyle(fontWeight: FontWeight.w800,fontSize: 21)),
                          Text(sy(widget.user.time), style : TextStyle(fontWeight: FontWeight.w300,fontSize: 10)),
                          SizedBox(height : 9),
                          !widget.b? Text(widget.user.reason):Text(widget.user.topic + " Letter"),
                          widget.user.topic=="Leave Application"?Text("From "+io(widget.user.date1)+" to "+io(widget.user.date2), style : TextStyle(fontWeight: FontWeight.w500,fontSize: 10)):SizedBox(),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                        decoration: BoxDecoration(
                            color: Colors.white70, // Background color of the container
                            borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            border: Border.all(color: Color(0xffE9075B), width: 2
                            )
                        ),
                        child : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Center(child: Text(widget.user.status)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
  Future<void> f(String str) async {
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    await FirebaseFirestore.instance.collection("Company").doc(_user!.source).collection("Requests").
    doc(widget.user.id).update({
      "status":"Approved",
      "linkk":str,
    });
    Navigator.pop(context);
  }
  TextEditingController link = TextEditingController();
  Widget r(String str,Widget rt){
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    return ListTile(
      onTap: () async {
        if(str=="Reject"){
          await FirebaseFirestore.instance.collection("Company").doc(_user!.source).collection("Requests").
          doc(widget.user.id).update({
            "status":"Rejected",
          });
        }else{
          await FirebaseFirestore.instance.collection("Company").doc(_user!.source).collection("Requests").
          doc(widget.user.id).update({
            "status":"Approved",
          });
          if(widget.user.request=="Leave Application"){
            List<String> formattedDates = [];
            DateTime end =DateTime.parse( widget.user.date2);
            DateTime start =DateTime.parse( widget.user.date1);
            for (int i = 0; i <= end.difference(start).inDays; i++) {
              DateTime currentDate = DateTime(start.year, start.month, start.day + i);

              // Manually format the date without leading zeros
              String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
              formattedDates.add(formattedDate); // Add the formatted date to the list

              // Use the formatted date in Firestore
              String st = currentDate.millisecondsSinceEpoch.toString();
              String su = currentDate.toString();
              TimeModel uio = TimeModel(
                time: formattedDate,
                date: "${currentDate.day}",
                month: "${currentDate.month}",
                year: "${currentDate.year}",
                duration: 0,
                x: 9,
                lastupdate: su,
                started: true,
                millisecondstos: st,
                startaddress: '',
                endaddress: '',
                stlan: 0.00,
                stlon: 0.2,
                endlan: 0.0,
                endlong: 0.0,
                color: Colors.yellow.value,
              );
              await FirebaseFirestore.instance.collection("Users")
                  .doc(widget.user.joining)
                  .collection("Attendance")
                  .doc(formattedDate)
                  .set(uio.toJson());
            }
          }
        }
        Navigator.pop(context);
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("$str the Application without Upload"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
  String sy(String g) {
    try {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(g));
      String formattedDate = DateFormat('dd, MMM yy').format(dateTime);
      String formattedTime = DateFormat('hh:mm a').format(dateTime);
      print(formattedDate); // Output: 28, Jan 22
      return formattedDate + " At " + formattedTime;
    }catch(e){
      return "Long time ago";
    }
  }

  String io(String g) {
    try {
      DateTime dateTime = DateTime.parse(g);
      String formattedDate = DateFormat('dd, MMM yy').format(dateTime);
      print(formattedDate); // Output: 28, Jan 22
      return formattedDate ;
    }catch(e){
      return "Long time ago";
    }
  }
}
