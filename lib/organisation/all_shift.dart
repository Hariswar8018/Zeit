import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart';

class Shifts extends StatefulWidget {
  OrganisationModel user;
  String id;
  Shifts({super.key,required this.id,required this.user});

  @override
  State<Shifts> createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> {
  List<UserModel> _list = [];
  String st = "";
  bool on = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Edit Shifts for Employees",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        actions: [
          IconButton(onPressed: (){
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
                            height: 6,
                          ),
                          ListTile(
                            onTap: (){
                              setState((){
                                on=true;
                              });
                            },
                            leading: Icon(Icons.all_inclusive),
                            title: Text("All Shifts",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
                            subtitle: Text("View all Shifts without Filter"),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          r("Morning Shift",Icon(Icons.sunny,color:Colors.red)),
                          r("Evening Shift",Icon(Icons.sunny_snowing,color:Colors.orange)),
                          r("Night Shift",Icon(Icons.nightlight,color:Colors.black)),
                          r("Weekend Shift",Icon(Icons.holiday_village,color:Colors.blue)),
                          r("Overtime Shift",Icon(Icons.timelapse_outlined,color:Colors.green)),
                          SizedBox(height:10)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }, icon: Icon(Icons.filter_alt_sharp,color:Colors.white))
        ],
      ),
      backgroundColor: Colors.white,
      body:on?StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo:widget.user.id )
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
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Employees found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Employee Exist for Organisation ${widget.id}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              UserModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatU(user: _list[index],id:widget.id );
            },
          );
        },
      ):StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("shit",isEqualTo: st)
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
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No User found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Applicatants for ${widget.id}",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              UserModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatU(user: _list[index],id:widget.id );
            },
          );
        },
      ),
    );
  }
  Widget r(String str,Widget rt){
    return ListTile(
      onTap: (){
        setState((){
          on=false;
          st=str;
        });
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("View all $str with Filter"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class ChatU extends StatelessWidget {
  UserModel user; String id;
  ChatU({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            tileColor: Colors.white30,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.pic),
            ),
            title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            subtitle: Text(user.bio),
          ),
          Row(
            children: [
              rt("Morning Shift",user.shit),
              rt("Evening Shift",user.shit),
              rt("Night Shift",user.shit),
            ],
          ),
          Row(
            children: [
              rt("Weekend Shift",user.shit),
              rt("Overtime Shift",user.shit),
            ],
          )
        ],
      ),
    );
  }
  Widget rt(String jh,String st){
    return InkWell(
        onTap : () async {
          await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
            "shit":jh,
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