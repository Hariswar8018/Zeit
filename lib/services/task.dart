import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/add/add_task.dart';
import 'package:zeit/cards/task.dart';
import 'package:zeit/model/task_class.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class Taskk extends StatelessWidget {
  Taskk({super.key,required this.hr});bool hr;
  List<Task> _list = [];
  @override
  Widget build(BuildContext context){
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Your Tasks",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      floatingActionButton:hr?InkWell(
        onTap: (){
          Task hj = Task(
            name: "hgg",
            id: "1",
            hrid: "hr123",
            hrname: "HR Name",
            comid: "com456",
            followers: [],  // List of followers, empty for now
            benefit: [],    // List of benefits, empty for now
            description: "Sample description",
            startdate: "2024-09-23",
            enddate: "2024-09-30",
            priority: "High",
            status: "Pending",
            pic: "pic_url",
            assigndate: "2024-09-22",
            lat: 12.34,
            lon: 56.78,
            client_name: "Client Name",
            client_id: "client123",
            category: "Category",
            invited: 10,
            complete: 5,
            progress: 50,
            Pending: [],        // List of pending tasks
            Completed: [],      // List of completed tasks
            Ignored: [],        // List of ignored tasks
            Incompleted: [],    // List of incompleted tasks
            hr: true,           // Boolean value for hr
            nameol: "nameol",
            namepicol: "namepicol",
            etol: "etol",
          );
          Navigator.push(
              context,
              PageTransition(
                  child: AddTask(hj: hj, on: false,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 50)));
        },
        child: Container(
          width: 110, height : 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.add,color :Colors.white),
                  Text("Add Tasks", style : TextStyle(color : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ):SizedBox(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc(_user!.source).collection("Tasks")
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
                    "No Task found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes you are Free for Today",
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
              Task.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return TaskU(user: _list[index], );
            },
          );
        },
      ),
    );
  }
}
