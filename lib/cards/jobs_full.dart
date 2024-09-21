import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/add_jobs.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

import '../model/organisation.dart';
import '../organisation/job_applicants.dart';

class JobFull extends StatefulWidget {
   JobFull({super.key,required this.user,required this.active});
  Job user ;bool active;

  @override
  State<JobFull> createState() => _JobFullState();
}

class _JobFullState extends State<JobFull> {
   bool teac() {
     UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
     if (_user!.type== "Organisation"&&_user.uid==widget.user.hrid ){
       return true;
     } else {
       return false;
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Apply for Job",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          teac()?SizedBox():InkWell(
              onTap:() async {
                if(widget.user.saved.contains(FirebaseAuth.instance.currentUser!.uid)){
                  await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                    "saved":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                  });
                  Send.message(context, "Job Remove from Bookmarks", false);
                }else{
                  await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                    "saved":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                  });
                  Send.message(context, "Job Added to Bookmarks", true);
                }
              },
              child: widget.user.saved.contains(FirebaseAuth.instance.currentUser!.uid)?Icon(Icons.bookmark,color: Colors.white,):Icon(Icons.bookmark_add_outlined,color: Colors.white,)),
          SizedBox(width: 15,),
        ],
      ),
      backgroundColor: Colors.white,
      body:Padding(
        padding: const EdgeInsets.only(left:14.0,right:14,top:13),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 28),),
              SizedBox(height:5),
              Text(widget.user.comn, style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15,color: Colors.grey),),
              SizedBox(height:10),
              Text(widget.user.address, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
              SizedBox(height:10),
              Container(
                width : MediaQuery.of(context).size.width/3 - 20, height : 30,
                decoration: BoxDecoration(
                  // Background color of the container
                  border: Border.all(
                      color: col(),
                      width: 2
                  ),
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child : Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Center(child: Text( statusr(),style: TextStyle(fontWeight: FontWeight.w700),)),
                ),
              ),
              SizedBox(height:10),
               widget.user.status1=="Interview"?interview():SizedBox(),
               Divider(
                thickness: 0.5,
              ),
              SizedBox(height:10),
              t1("Job Details"),
              h1("Key Details About Job"),
              SizedBox(height:10),
              Container(
                width:MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.credit_card,color:Colors.green),
                    SizedBox(width:9),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Pay", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                        Container(decoration: BoxDecoration(
                          color: Colors.grey.shade200, // Background color of the container
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),child: Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                          child: Text("₹ "+widget.user.payment.toString()+" a month"),
                        )),
                      ],
                    ),
                  ],
                ),
              ),w2(),
              Container(
                width:MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.work,color: Colors.red,),
                    SizedBox(width:9),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Job Type", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Background color of the container
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),child: Padding(
                              padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                              child: Text(widget.user.shift),
                            )),
                            SizedBox(width:9),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200, // Background color of the container
                                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                ),child: Padding(
                              padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                              child: Text(widget.user.jem),
                            )),
                            SizedBox(width:9),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200, // Background color of the container
                                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                ),child: Padding(
                              padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                              child: Text(widget.user.jtype),
                            )),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200, // Background color of the container
                                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                ),child: Padding(
                              padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                              child: Text(widget.user.work1),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),w2(),
              Container(
                width:MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.timelapse_outlined,color: Colors.purpleAccent,),
                    SizedBox(width:9),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shift Shedule", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                        Container(decoration: BoxDecoration(
                          color: Colors.grey.shade200, // Background color of the container
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),child: Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                          child: Text(widget.user.shift),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              w1(),
              Text("Job Posted on : " +gy(int.parse(widget.user.time)),style:TextStyle(fontWeight: FontWeight.w800,color:Colors.blue)),
              sr(),
              t1("Location"),
              w1(),
              Row(
                children: [
                  Icon(Icons.location_on_sharp,color: Colors.deepPurpleAccent,),
                  Text(widget.user.address)
                ],
              ),
              sr(),
              t1("Benefits"),
              h1("Key Benefits for Job Descriptions"),
              Container(
                height: widget.user.benefit.length*25,
                width: MediaQuery.of(context).size.width,
                child:ListView.builder(
                  itemCount: widget.user.benefit.length,scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(" ⚫ "+widget.user.benefit[index],style: TextStyle(fontWeight: FontWeight.w700),),
                      ),
                    );
                  },
                ),
              ),
              sr(),
              t1("Qualifiations"),
              h1("Key Necessity for taking the Job"),
              ty(widget.user.qualification),
              sr(),
              t1("Description"),
              h1("Job Description as presented"),
              ty(widget.user.description),
              SizedBox(height:20),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Column(
          children: [
           !teac()? (cont()?SizedBox():InkWell(
               onTap:(){
                 if(widget.active){
                   apply();
                 }else{
                   Send.message(context, "Job Applicant is closed by HR", false);
                 }

               },
               child: c("Apply for Job",Icon(Icons.send,color:Colors.white,size:25),))): InkWell(
                onTap:(){
                  status();
                },
                child: c("Change Job Status",Icon(Icons.open_in_new,color:Colors.white,size:25),)),
            SizedBox(height: 9,),
            teac()?InkWell(
                onTap:(){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Applicants(id:widget.user.time),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: c("See Job Applicants",Icon(Icons.remove_red_eye_rounded,color:Colors.white,size:25),)):
            InkWell(
                onTap:() async {
                  if(cont()){

                  }else{
                    if(widget.user.saved.contains(FirebaseAuth.instance.currentUser!.uid)){
                      await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                        "saved":FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
                      });
                      Send.message(context, "Job Remove from Bookmarks", false);
                    }else{
                      await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                        "saved":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                      });
                      Send.message(context, "Job Added to Bookmarks", true);
                    }
                  }
                },
                child: c(cont()?"Already Applied":"Save Job for Later",cont()?Icon(Icons.verified,color:Colors.white,size:25):Icon(Icons.bookmark,color:Colors.white,size:25),))
          ],
        )
      ],
    );
  }
  Widget interview(){
     String uid=FirebaseAuth.instance.currentUser!.uid;
     print(widget.user.follower1);
     print(uid);
     return widget.user.follower1.contains(uid)?Column(
       children: [
         Divider(
           thickness: 0.5,
         ),
         Card(
           color: Colors.white,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Stack(
               children: [
                 Container(
                   height: 170,width: MediaQuery.of(context).size.width-20,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("! Interview Dates Announced",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 18),),
                       Text("You have been Selected for the Interview 🥳🥳",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Icon(Icons.location_on_rounded,color: Colors.orange,),
                           SizedBox(width: 8,),
                           Text(widget.user.Intaddress,style: TextStyle(fontWeight: FontWeight.w700),),
                         ],
                       ),
                       Row(
                         children: [
                           Icon(Icons.access_time_filled_rounded,color: Colors.green,),
                           SizedBox(width: 8,),
                           Text(widget.user.time2,style: TextStyle(fontWeight: FontWeight.w700),),
                         ],
                       ),
                       Row(
                         children: [
                           Icon(Icons.note_add,color: Colors.purpleAccent,),
                           SizedBox(width: 8,),
                           Text(widget.user.note,style: TextStyle(fontWeight: FontWeight.w700),),
                         ],
                       ),
                     ],
                   ),
                 ),
                 Container(
                   height: 170,width: MediaQuery.of(context).size.width-20,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Spacer(),
                           InkWell(
                             onTap: () async {
                               final Uri _url = Uri.parse('tel:${widget.user.phone}');
                               if (!await launchUrl(_url)) {
                               throw Exception('Could not launch $_url');
                               }
                             },
                             child: CircleAvatar(
                               backgroundColor: Colors.greenAccent,
                               child: Icon(Icons.phone,color: Colors.white,),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 9,),
                       Row(
                         children: [
                           Spacer(),
                           InkWell(
                             onTap: () async {
                               final Uri _url = Uri.parse('mailto:${widget.user.mail}');
                               if (!await launchUrl(_url)) {
                               throw Exception('Could not launch $_url');
                               }
                             },
                             child: CircleAvatar(
                               backgroundColor: Colors.blueAccent,
                               child: Icon(Icons.mail,color: Colors.white,),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 9,),
                       Row(
                         children: [
                           Spacer(),
                           CircleAvatar(
                             backgroundColor: Colors.orangeAccent,
                             child: Icon(Icons.map_outlined,color: Colors.white,),
                           ),
                         ],
                       )
                       ]
                   ),
                 )
               ],
             ),
           ),
         ),
       ],
     ):
     Column(
       children: [
         Divider(
           thickness: 0.5,
         ),
         Card(
           color: Colors.white,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               height: 70,width: MediaQuery.of(context).size.width-20,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text("! Not Selected",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600,fontSize: 18),),
                   Text("Sorry, You are not Selected by HR",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 15),),
                   SizedBox(height: 10,),
                   Text("Don't Worry you will be Selected Next Time",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 15),),
                 ],
               ),
             ),
           ),
         ),
       ],
     );
  }
  bool cont(){
     return widget.user.follower.contains(FirebaseAuth.instance.currentUser!.uid);
  }
  String gy(int st){
     try{
       DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(st);
       String formattedDate = DateFormat('dd/MM/yyyy \'at\' HH:mm').format(dateTime);
       print(formattedDate); // This will print the formatted date
       return formattedDate;
     }catch(e){
       return "Not Uploaded";
     }
  }
   final String uid=FirebaseAuth.instance.currentUser!.uid;
   void status(){
     UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
     resume.text=gy(_user!.resumetime);
     link1.text = _user!.link1;
     link2.text = _user.link2;
     link3.text=_user.link3;
     showModalBottomSheet<void>(
       context: context,
       builder: (BuildContext context) {
         return SizedBox(
           height: 700,
           child: Center(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.center,
               children:  <Widget>[
                 SizedBox(
                   height: 10,
                 ),
                 Container(
                   height:8,width:90,decoration: BoxDecoration(
                     color:Colors.blue,borderRadius: BorderRadius.circular(15)
                 ),
                 ),SizedBox(
                   height: 8,
                 ),
                 SizedBox(
                   height: 14,
                 ),
                 Text("Change Status of Job", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 24)),
                 SizedBox(
                   height: 22,
                 ),
                 InkWell(
                     onTap: () async {
                       await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                         "status1":"Interview",
                       });
                       Send.message(context, "Job had been called for Applicants", true);
                       Navigator.pop(context);
                       Navigator.pop(context);
                     },
                     child: fg((widget.user.status1=="Interview"),context,"assets/interview-svgrepo-com.svg","Call for Interview","Call Selected Application for Interview")),
                 w1(),Padding(
             padding: const EdgeInsets.only(left:15.0,right:15),
             child: Container(
               width:MediaQuery.of(context).size.width,
               height: 85,
               decoration: BoxDecoration(
                   color: Colors.transparent,
                   border: Border.all(
                       color: Colors.blue,
                       width: 2
                   ),
                   borderRadius: BorderRadius.circular(7)
               ),
                   child: ListTile(
                     onTap: () async {
                       try {
                         // Reference to the 'users' collection
                         CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
                         // Query the collection based on uid
                         QuerySnapshot querySnapshot = await usersCollection.where('id', isEqualTo: widget.user.comi).get();
                         // Check if a document with the given uid exists
                         if (querySnapshot.docs.isNotEmpty) {
                           // Convert the document snapshot to a UserModel
                           OrganisationModel user1 = OrganisationModel.fromSnap(querySnapshot.docs.first);
                           Navigator.push(
                               context,
                               PageTransition(
                                   child: AddJ(user: user1, change: true, job: widget.user,),
                                   type: PageTransitionType.rightToLeft,
                                   duration: Duration(milliseconds: 600)));
                         } else {
                           // No document found with the given uid
                           return null;
                         }
                       } catch (e) {
                         print("Error fetching user by uid: $e");
                         return null;
                       }

                     },
                     leading: Icon(Icons.edit,color:Colors.green,size:40),
                     title: Text("Change",style :TextStyle(fontWeight: FontWeight.w800,)),
                     subtitle: Text("Edit the Job Card",style :TextStyle(fontWeight: FontWeight.w300,fontSize: 14)),
                     trailing: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue),
                   ),
                 ),
                 ),
                 w1(),InkWell(
                     onTap: () async {
                       await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                         "status1":"Done",
                       });
                       Send.message(context, "Job had been filled by HR ! Please select the Eligible Employee", true);
                       Navigator.pop(context);
                       Navigator.pop(context);
                       Navigator.push(
                           context,
                           PageTransition(
                               child: ApplicantsD( id: widget.user.time, comid: widget.user.comi,),
                               type: PageTransitionType.leftToRight,
                               duration: Duration(milliseconds: 400)));
                     },
                     child: fg((widget.user.status1=="Done"),context,"assets/complete-ok-accept-good-tick-svgrepo-com.svg","Declare Completed","Declare that Job Vacancy is Filled")),
                 w1(),InkWell(
                     onTap: () async {
                       await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).delete();
                       Send.message(context, "Job had been deleted", true);
                       Navigator.pop(context);
                       Navigator.pop(context);
                     },
                     child: fg(false,context,"assets/delete-svgrepo-com.svg","Delete","Delete Job Application")),
               ],
             ),
           ),
         );
       },
     );
   }
   String statusr(){
     print(widget.user.status1);
     if(widget.user.status1=="Active"){
       return "Hiring Now";
     }else if(widget.user.status1=="Done"){
       return "Vacancy Filled";
     }else if(widget.user.follower1.contains(uid)){
       return "Selected !";
     }else{
       return "Not Selected";
     }
   }
   Color col(){
     print(widget.user.status1);
     if(widget.user.status1=="Active"){
       return Colors.blue;
     }else if(widget.user.status1=="Done"){
       return Colors.greenAccent;
     }else if(widget.user.follower1.contains(uid)){
       return Colors.purpleAccent;
     }else{
       return Colors.red;
     }
   }
   Widget fg(bool h,BuildContext context,String asset, String s1, String s2){
     return Padding(
       padding: const EdgeInsets.only(left:15.0,right:15),
       child: Container(
         width:MediaQuery.of(context).size.width,
         height: 85,
         decoration: BoxDecoration(
           color: h?Colors.grey:Colors.transparent,
             border: Border.all(
                 color: Colors.blue,
                 width: 2
             ),
             borderRadius: BorderRadius.circular(7)
         ),
         child:Padding(
           padding: const EdgeInsets.all(8.0),
           child: ListTile(
             leading: SvgPicture.asset(
               asset,
               semanticsLabel: 'Acme Logo',
               height: 50,
             ),
             title: Text(s1,style :TextStyle(fontWeight: FontWeight.w800,)),
             subtitle: Text(s2,style :TextStyle(fontWeight: FontWeight.w300,fontSize: 14)),
             trailing: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue),
           ),
         ),
       ),
     );
   }
  void apply(){
    UserModel? _user = Provider.of<UserProvider>(context, listen: false).getUser;
    resume.text=gy(_user!.resumetime);
    link1.text = _user!.link1;
    link2.text = _user.link2;
    link3.text=_user.link3;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 900,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  height:8,width:90,decoration: BoxDecoration(
                  color:Colors.blue,borderRadius: BorderRadius.circular(15)
                ),
                ),SizedBox(
                  height: 8,
                ),
                Text("Just a Quick Checks", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 24)),
                SizedBox(
                  height: 10,
                ),
                Padding(
                 padding: const EdgeInsets.only(left:15.0,right:15),
                 child: Container(
                   width:MediaQuery.of(context).size.width,
                   height: 85,
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: Colors.blue,
                       width: 2
                     ),
                     borderRadius: BorderRadius.circular(7)
                   ),
                   child:Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ListTile(
                       leading: CircleAvatar(
                         backgroundImage: NetworkImage(_user!.pic),
                         radius: 25,
                       ),
                       title: Text(_user.Name,style :TextStyle(fontWeight: FontWeight.w800,)),
                       subtitle: Text(_user.education,style :TextStyle(fontWeight: FontWeight.w600,fontSize: 17)),
                       trailing: Text(_user.gender,style :TextStyle(fontWeight: FontWeight.w400,fontSize: 16)),
                     ),
                   ),
                 ),
               ),
                SizedBox(
                  height: 6,
                ),
                Row(
                  children:[
                    Container(
                      width:MediaQuery.of(context).size.width-50,
                      child: Padding(
                        padding: const EdgeInsets.only(left:18.0,right:18,top:8,bottom:8),
                        child: TextFormField(
                          controller: resume,readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Your Saved Resume',
                            isDense: true,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: InkWell(
                          onTap:()async{
                            try {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                              if (result != null) {
                                File file = File(result.files.single.path!);
                                Send.message(context, "Uploading your PDF", true);
                                final storageRef = FirebaseStorage.instance.ref();
                                final mountainsRef = storageRef.child("${_user.Name}.pdf"); // Change the filename as needed
                                await mountainsRef.putFile(file);

                                String downloadUrl = await mountainsRef.getDownloadURL();
                                resume.text = downloadUrl;
                                await FirebaseFirestore.instance.collection("Users").doc(_user.uid).update({
                                  "resumelink":downloadUrl,
                                  "resumetime":DateTime.now().millisecondsSinceEpoch,
                                });
                              } else {
                                Send.message(context, "You didn't choose a Pdf ! Try again", false);
                              }
                            } catch (e) {
                              Send.message(context, "${e}", false);
                            }
                          },
                          child: Icon(Icons.upload,color:Colors.white)),
                    )
                  ]
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,bottom:5),
                  child: TextFormField(
                    controller: link1,
                    decoration: InputDecoration(
                      labelText: 'Portfolio Link 1',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,bottom:5),
                  child: TextFormField(
                    controller: link2,
                    decoration: InputDecoration(
                      labelText: 'Portfolio Link 2',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,bottom:5),
                  child: TextFormField(
                    controller: link3,
                    decoration: InputDecoration(
                      labelText: 'Portfolio Link 3',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left:10.0,right:10),
                  child: InkWell(
                      onTap:() async {
                        await FirebaseFirestore.instance.collection("Jobs").doc(widget.user.time).update({
                          "follower":FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                        });
                        await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                          "jobfollower":FieldValue.arrayUnion([widget.user.time]),
                          "link1":link1.text,
                          "link2":link2.text,
                          "link3":link3.text,
                        });
                        Send.message(context, "Job Applied Successfully", true);
                        Navigator.pop(context);
                      },
                      child: c("Apply Now",Icon(Icons.send,color:Colors.white,size:25),)),
                ),
                SizedBox(height:10)
              ],
            ),
          ),
        );
      },
    );
  }

  TextEditingController resume = TextEditingController();
   TextEditingController link1 = TextEditingController();
   TextEditingController link2 = TextEditingController();
   TextEditingController link3 = TextEditingController();

Widget c(String s1,Widget r){
     return Container(
       height:55,
       width: MediaQuery.of(context).size.width,
       decoration: BoxDecoration(
         color:Colors.blue,
         borderRadius: BorderRadius.circular(7),
       ),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           r,
           SizedBox(width:8),
           Text(s1,style:TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.w600))
         ],
       ),
     );
   }

  Widget ty(String s2)=>Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(widget.user.key, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.black),),
  );

  Widget sr(){
    return Column(
      children:[
        w1(),
        Divider(
          thickness: 0.5,
        ),
        SizedBox(height:10),
      ]
    );
  }

  Widget w1()=>SizedBox(height:10);

   Widget w2()=>SizedBox(height:20);

   Widget t1(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),);
   Widget t2(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);
   Widget h1(String s2)=>Text(s2, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),);
}



class ApplicantsD extends StatelessWidget {
  String id; String comid;
  ApplicantsD({super.key,required this.id,required this.comid});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Select Employee to Join your Organisation",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      backgroundColor: Colors.white,
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("jobfollower1",arrayContains: id)
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
                    "Looks likes no Applicatants for $id",
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
              return ChatUD(user: _list[index],id:id, comid: comid, );
            },
          );
        },
      ),
    );
  }
}
class ChatUD extends StatefulWidget {
  UserModel user; String id;String comid;
  ChatUD({super.key,required this.user,required this.id,required this.comid});

  @override
  State<ChatUD> createState() => _ChatUDState();
}

class _ChatUDState extends State<ChatUD> {
bool done=false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            onTap: (){
              setState(() {
                if(done){
                  done=false;
                }else{
                  done=true;
                }
              });
            },
            tileColor: Colors.white30,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.user.pic),
            ),
            title: Text(widget.user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            subtitle: Text(widget.user.bio),
            trailing: InkWell(
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: widget.user.follower1.contains(widget.id)?Icon(Icons.verified,color: Colors.blue,):Icon(Icons.verified,color:Colors.grey),
              ),
            ),
          ),
          SizedBox(height: 9,),
          done?Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SocialLoginButton(
                backgroundColor: Colors.blue,
                height: 40,
                text: 'Add ${widget.user.Name} to your Organisation',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async{
                  confirm(widget.user, true);
                }),
          ):SizedBox(),
          done?SizedBox(height: 14,):SizedBox(),
        ],
      ),
    );
  }
void confirm(UserModel user1,bool b){
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 360,
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
                  b? "Confirm the User":"Confirm the Admin",
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 20)),
              SizedBox(height: 9),
              Text(textAlign: TextAlign.center,
                  "We found out this User ! Please check is it Correct? By clicking Yes, The User will be added to the Company.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 18)),
              SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user1.pic),
                          radius: 25,
                        ),
                        title: Text(user1.Name,style :TextStyle(fontWeight: FontWeight.w800,fontSize: 18)),
                        subtitle: Text(user1.education,style :TextStyle(fontWeight: FontWeight.w800,)),
                        trailing:Icon(Icons.work,color:Colors.red,size: 25,),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18.0,right:18,top:10),
                child: SocialLoginButton(
                  backgroundColor: Color(0xff6001FF),
                  height: 40,
                  text: 'Yes ! this is the User',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    if(user1.source.isEmpty){
                      await FirebaseFirestore.instance.collection("Users")
                          .doc(user1.uid)
                          .update({
                        "type": 'Individual',
                        "source": widget.comid,
                      });
                      await FirebaseFirestore.instance.collection("Company")
                          .doc(widget.user.source)
                          .update({
                        "people": FieldValue.arrayUnion([user1.uid]),
                      });
                      Navigator.pop(context);
                      Send.message(context, "Added", true);
                    }else{
                      Send.message(context, "The Employee is already added to a Company ! Please remove it first", false);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}