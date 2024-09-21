import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/add/add_jobs.dart';
import 'package:zeit/cards/jobcard.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/organisation.dart';

class Jobh extends StatefulWidget {
  bool hr;
  Jobh({super.key,required this.hr});

  @override
  State<Jobh> createState() => _JobhState();
}

class _JobhState extends State<Jobh> {
  List<Job> _list = [];

  bool b = false;

  @override
  Widget build(BuildContext context) {
    return widget.hr?Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Job Openings",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            setState((){
              b=!b;
            });
          }, icon:b?Icon(Icons.bookmark,color:Colors.white): Icon(Icons.bookmark_border,color:Colors.white))
        ],
      ),
      floatingActionButton:InkWell(
        onTap: () async {
          String  uid = FirebaseAuth.instance.currentUser!.uid ;
          try {
            // Reference to the 'users' collection
            CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
            // Query the collection based on uid
            QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
            // Check if a document with the given uid exists
            if (querySnapshot.docs.isNotEmpty) {
              // Convert the document snapshot to a UserModel
              OrganisationModel user = OrganisationModel.fromSnap(querySnapshot.docs.first);
              Job gh=Job(name: "j", comn: "h", comi: "h", rating:4.8, address: "", type: [],
                  description: "jj", respon: "gg", key: "h", about: "j", experience: "j",
                  qualification: "jh", follower: [], saved: [], benefit: [], hrname: "j", hrid: "j", comlogo: "h",
                  hrlogo:"h", status: false, time: "k", jem: "j", jtype:"h", shift: "h",
                  work1:"j", follower1: [], payment:100, Intaddress: '', lat: 23.66, lon: 54.3, phone: '', mail: '', note: '', link: '', meet: false, time2: '');
              Navigator.push(
                  context,
                  PageTransition(
                      child: AddJ(user: user, change: false, job: gh,),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 600)));
            } else {
              Send.message(context, "Error", false);
            }
          } catch (e) {
            print("Error fetching user by uid: $e");
            Send.message(context, "${e}", false);
            return null;
          }
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25)
            ),
            height: 55, width : 170,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_box_rounded, color: Colors.white),
                SizedBox(width: 9),
                Text("Add Job Applicant", style: TextStyle(color: Colors.white))
              ],
            )
        ),
      ),
      body:StreamBuilder(
        stream: b?FirebaseFirestore.instance
            .collection('Jobs').where("saved",arrayContains: FirebaseAuth.instance.currentUser!.uid).where("hrid",isEqualTo: FirebaseAuth.instance.currentUser!.uid )
            .snapshots():FirebaseFirestore.instance
            .collection('Jobs').where("hrid",isEqualTo: FirebaseAuth.instance.currentUser!.uid )
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
                    "No Jobs Application found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes the Company HR haven't posted any Job Application",
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
              Job.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return JobU(user: _list[index], checking: b, );
            },
          );
        },
      ),
    ): Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Job Openings",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            setState((){
              b=!b;
            });
          }, icon:b?Icon(Icons.bookmark,color:Colors.white): Icon(Icons.bookmark_border,color:Colors.white))
        ],
      ),
      body:StreamBuilder(
        stream: b?FirebaseFirestore.instance
            .collection('Jobs').where("saved",arrayContains: FirebaseAuth.instance.currentUser!.uid)
            .snapshots():FirebaseFirestore.instance
            .collection('Jobs').orderBy("time",descending: true)
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
                    "No Jobs found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes company are still busy",
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
              Job.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return JobU(user: _list[index], checking: b, );
            },
          );
        },
      ),
    );
  }
}
