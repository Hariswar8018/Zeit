import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeitt/cards/usercards.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/provider/declare.dart';

import '../model/usermodel.dart';

class Search extends StatelessWidget {
  UserModel user;
   Search({super.key,required this.user});
 TextEditingController cg = TextEditingController();
   List<UserModel> _list = [];
   String yu = FirebaseAuth.instance.currentUser!.uid;
   final GlobalKey<ScaffoldState> _key = GlobalKey();
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
                  isDense: true,  hintText: "Search your Colleges",
                  border: InputBorder.none, // No border
                  counterText: '',
                ),
              ),
            ),
          ),
        ),
      ),
      body: cg.text.isEmpty?StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("source",isEqualTo: user.source)
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
                    "No Employees found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Do try Searching with designation or with Filter",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);
          return GridView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatUser(user: _list[index]),
              );
            },
          );
        },
      ):
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users').where("name", isLessThanOrEqualTo: cg.text).where("source",isEqualTo: user.source)
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
                    "No Employees found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Do try Searching with designation or with Filter",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }

          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);

          return GridView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatUser(user: _list[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatUser extends StatefulWidget {
  UserModel user ;
  ChatUser({super.key, required this.user});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  bool admin(){
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    String? df=FirebaseAuth.instance.currentUser!.email;
    if(df=="brnrinnovation@gmail.com"||df=="admin@zeitt.com"){
      return true;
    }if(_user!.type=="Individual"){
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.user.Name.isEmpty?InkWell(
      onTap: (){
       Send.message(context, "User Still Not Registered ! Waiting for Registration", false);
      },
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                  fit: BoxFit.cover
              )
          ),
          child : Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  admin()?IconButton(onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Attention ! Delete from Organisation?'),
                          content: Text('You Sure to detach from Organisation. You will remove this USER from Organisation and some data may be Permanent Deleted'),
                          actions: [
                            ElevatedButton(
                              child: Text('No'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance.collection(
                                      "Users").doc(widget.user!.uid).update({
                                    "source": "",
                                    "jobfollower":[],
                                    "jobfollower1":[],
                                    "salary":0.0,
                                    "employees":[],
                                    "following":[],
                                  });
                                  fh();
                                  Navigator.pop(context);
                                  Send.message(context, "Deleted Success", true);
                                }catch(e){
                                  Navigator.pop(context);
                                  Send.message(context, "${e}", false);
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );

                  }, icon: Icon(Icons.delete)):SizedBox(),
                ],
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40, color : Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(widget.user.Email, style: TextStyle(
                          color : Colors.white,fontSize: 9
                      ),),
                      Text("Waiting for Registration", style: TextStyle(
                          color : Colors.white,fontSize: 14,fontWeight: FontWeight.w400
                      ),),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    ):InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: UserC(user: widget.user,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 400)));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.user.pic),
            fit: BoxFit.cover
          )
        ),
        child : Column(
          children: [
            Row(
              children: [
                Spacer(),
                admin()?IconButton(onPressed: () async {
                  await FirebaseFirestore.instance.collection(
                      "Users").doc(widget.user!.uid).update({
                    "source": "",
                    "jobfollower":[],
                    "jobfollower1":[],
                    "salary":0.0,
                    "employees":[],
                    "following":[],
                  });
                  fh();
                }, icon: Icon(Icons.delete)):SizedBox(),
              ],
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40, color : Colors.black,
              child: Center(
                child: Column(
                  children: [
                    Text(widget.user.Name, style: TextStyle(
                      color : Colors.white,fontSize: 17
                    ),),
                    Text(widget.user.education, style: TextStyle(
                        color : Colors.white,fontSize: 10,fontWeight: FontWeight.w400
                    ),),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Future<void> fh() async {
    try{
      await FirebaseFirestore.instance.collection(
          "Company").doc(widget.user!.source).update({
        "people":FieldValue.arrayRemove([widget.user.uid]),
      });
    }catch(e){

    }
    try{
      await FirebaseFirestore.instance.collection(
          "Company").doc(widget.user!.source).update({
        "admin":FieldValue.arrayRemove([widget.user.uid]),
      });
    }catch(e){

    }try{
      await FirebaseFirestore.instance.collection(
          "Company").doc(widget.user!.source).update({
        "subadmin":FieldValue.arrayRemove([widget.user.uid]),
      });
    }catch(e){

    }
    try{
      await FirebaseFirestore.instance.collection(
          "Company").doc(widget.user!.source).update({
        "subadmin":FieldValue.arrayRemove([widget.user.uid]),
      });
    }catch(e){

    }
  }
}
