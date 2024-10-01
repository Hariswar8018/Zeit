import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/functions/notification.dart';
import 'package:zeit/main_pages/navigation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/notification/notify_all.dart';
import 'package:zeit/provider/declare.dart';

class GoogleMeet extends StatelessWidget {
   GoogleMeet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Notify Google/Zoom meet",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:Column(
        children:[
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 4,top: 25),
            child: TextFormField(
              controller: cv,
              decoration: InputDecoration(
                  isDense: true,hintText: "Link for Meet",
                  border: OutlineInputBorder(),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              if(cv.text.isEmpty){
                Send.message(context, "Please type Link", false);
              }else{
                final String st=DateTime.now().millisecondsSinceEpoch.toString();
                Navigator.push(
                    context,
                    PageTransition(
                        child: How(id:st , sdk: cv.text),
                        type: PageTransitionType.fade,
                        duration: Duration(milliseconds: 60)));
              }
            },
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8,top: 7),
                child: Container(
                  width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Notify Choose Employees",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                )
            ),
          ),
          SizedBox(height: 30,),
          Text("OR",style: TextStyle(fontWeight: FontWeight.w800),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Meeting will start Immediately. If it's after more than 1 Hour - consider Adding Notification first",textAlign: TextAlign.center,),
          ),
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: Notify(),
                      type: PageTransitionType.leftToRight,
                      duration: Duration(milliseconds: 40)));
            },
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8,top: 7),
                child: Container(
                  width: 400,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("Add Notification instead",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                )
            ),
          ),
        ]
      )
    );
  }
  TextEditingController cv=TextEditingController();
}


class How extends StatelessWidget{
  String id;
  String sdk;
  How({super.key,required this.id,required this.sdk});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Notifying and Choosing Employee",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo: _user!.source)
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
                    "Looks likes no Applicatants for ${id}",
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
              return ChatUW(user: _list[index],id:id);
            },
          );
        },
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Complete',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                try {
                  try{
                    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
                        .collection('Users')
                        .where('jobfollower', arrayContains:id)
                        .get();
                    print("vbvnb");
                    List<String> tokens = [];
                    print(usersSnapshot.docs);
                    // Extract tokens from the fetched documents
                    // Extract tokens from the fetched documents
                    usersSnapshot.docs.forEach((doc) async {
                      // Explicitly cast doc.data() to Map<String, dynamic>
                      var data = doc.data() as Map<String, dynamic>;
                      var user = UserModel.fromJson(data); // Assuming UserModel.fromJson correctly initializes from Map
                      print(data);
                      print(user);
                      print("fdvhnnb");
                      if (user.token != null) {
                        tokens.add(user.token);
                      }
                      try{
                        await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
                          "meetlink":sdk,
                          "meetname":sdk,
                          "meetid":id,
                          "meetby":_user.Name,
                          "meetpic":_user.pic,
                          "meetdesc":_user.type,
                        });
                      }catch(e){

                      }
                      print(tokens);
                    });
                    await NotifyAll.sendNotificationsCompany("Google/Zoom Meet Invited", "A New Meet Started by HR/Director ${_user.Name}", tokens);
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: MyHomePage(title: '',),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 200)));
                  }catch(e){
                    print(e);
                  }
                }catch(e){
                  print(e);
                }
              }),
        ),
      ],
    );
  }
}

class ChatUW extends StatelessWidget {
  String id;
  UserModel user;
  ChatUW({super.key,required this.user,required this.id,});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          if(user.follower.contains(id)){
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
              "jobfollower":FieldValue.arrayRemove([id]),
            });
          }else{
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
              "jobfollower":FieldValue.arrayUnion([id]),
            });
          }
        },
        tileColor: Colors.white30,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.pic),
        ),
        title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
        subtitle: Text(user.education),
        trailing: user.follower.contains(id)?CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.verified,color:Colors.white),
        ):CircleAvatar(
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}