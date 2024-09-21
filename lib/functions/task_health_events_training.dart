import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/main_pages/navigation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/notification/notify_all.dart';

import '../provider/declare.dart';

class How extends StatelessWidget{
  String id,first4; String message;String topic; String docname;
  String sdk;
   How({super.key,required this.id,required this.first4,required this.message,required this.topic,required this.docname,required this.sdk});
  List<UserModel> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add User to $first4",style:TextStyle(color:Colors.white,fontSize: 23)),
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
                return ChatU(user: _list[index],id:id,first4: first4,);
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
                        .where('jobfollower', arrayContains:first4+"I"+id)
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
                        await FirebaseFirestore.instance
                            .collection('Company')
                            .doc(user!.source).collection(docname).doc(id).update({
                          "invite":FieldValue.arrayUnion([user.uid]),
                        });

                      }catch(e){

                      }
                      try{
                        await  FirebaseFirestore.instance.collection("Company")
                            .doc(_user.source).collection(sdk)
                            .doc(id).update({
                          "Ignored":FieldValue.arrayUnion([user.uid]),
                        });
                      }catch(e){
                        print("hgchvj");
                      }
                      print(tokens);
                    });
                    await NotifyAll.sendNotificationsCompany(topic, message, tokens);
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

class ChatU extends StatelessWidget {
  String id,first4;
  UserModel user;
   ChatU({super.key,required this.user,required this.id,required this.first4});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: () async {
          if(user.follower.contains(first4+"I"+id)){
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
              "jobfollower":FieldValue.arrayRemove([first4+"I"+id]),
            });
          }else{
            await FirebaseFirestore.instance.collection("Users").doc(user.uid).update({
              "jobfollower":FieldValue.arrayUnion([first4+"I"+id]),
            });
          }
        },
        tileColor: Colors.white30,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user.pic),
        ),
        title: Text(user.Name,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
        subtitle: Text(user.education),
        trailing: user.follower.contains(first4+"I"+id)?CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.verified,color:Colors.white),
        ):CircleAvatar(
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
