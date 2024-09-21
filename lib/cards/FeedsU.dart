import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/notification/notify_all.dart';
import '../model/feeds.dart';
import '../provider/declare.dart';

class FeedsU extends StatelessWidget {
   FeedsU({super.key, required this.user});
   String g = FirebaseAuth.instance.currentUser!.uid;
Feed user ;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap:(){
          Navigator.push(
              context,
              PageTransition(
                  child: FullC(user:user),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child:Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.Ntpic),
                  ),
                  title: Text(user.Ntname + " posted a message",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                  subtitle: Text(fo(user.id)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left :14.0, right :14),
                  child: Text( textAlign : TextAlign.left, user.name),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom:4, right:5),
                  child: Row(
                    children: [
                      TextButton.icon(onPressed: () async {
                        if(user.likes.contains(g)){
                          await FirebaseFirestore.instance.collection("Company")
                              .doc(_user!.source).collection("Feeds")
                              .doc(user.id).update({
                            "likes":FieldValue.arrayRemove([g]),
                          });
                        }else{
                          await  FirebaseFirestore.instance.collection("Company")
                              .doc(_user!.source).collection("Feeds")
                              .doc(user.id).update({
                            "likes":FieldValue.arrayUnion([g]),
                          });
                        }

                      }, label: Text(user.likes.length.toString()),
                          icon: user.likes.contains(g)?Icon(Icons.thumb_up_off_alt_rounded,color: Colors.blue):
                          Icon(Icons.thumb_up_alt_outlined,color: Colors.blue)),
                      TextButton.icon(onPressed: (){

                      }, label: Text(user.comments.length.toString()),
                          icon: Icon(Icons.comment_bank_rounded,color: Colors.blue))
                    ],
                  ),
                )
              ],
            )),
      )
    );
  }
   String fo(String dateTimeString) {
    try {
      // Parse the DateTime string
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTimeString));

      // Get the current date
      DateTime now = DateTime.now();

      // Check if the dateTime is today
      bool isToday = dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;

      // Define date formats
      DateFormat timeFormat = DateFormat('HH:mm');
      DateFormat dateFormat = DateFormat('dd/MM/yy');
      return isToday ? timeFormat.format(dateTime) : dateFormat.format(
          dateTime);
    }catch(e){
      return "few min ago";
    }
   }
}

class FullC extends StatefulWidget {
  FullC({super.key,required this.user});
  Feed user ;

  @override
  State<FullC> createState() => _FullCState();
}

class _FullCState extends State<FullC> {
  String g = FirebaseAuth.instance.currentUser!.uid;

  List<Feed> _list = [];

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Respond to Feed",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      padding: const EdgeInsets.all(5.0),
      child: Container(
          width: MediaQuery.of(context).size.width-20,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.Ntpic),
                ),
                title: Text(widget.user.Ntname + " posted a message",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                subtitle: Text(fo(widget.user.id)),
              ),
              Padding(
                padding: const EdgeInsets.only(left :14.0, right :14),
                child: Text( textAlign : TextAlign.left, widget.user.name),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom:4, right:5),
                child: Row(
                  children: [
                    TextButton.icon(onPressed: () async {
                      if(widget.user.likes.contains(g)){
                        await FirebaseFirestore.instance.collection("Company")
                            .doc(_user!.source).collection("Feeds")
                            .doc(widget.user.id).update({
                          "likes":FieldValue.arrayRemove([g]),
                        });
                      }else{
                        await  FirebaseFirestore.instance.collection("Company")
                            .doc(_user!.source).collection("Feeds")
                            .doc(widget.user.id).update({
                          "likes":FieldValue.arrayUnion([g]),
                        });
                      }

                    }, label: Text(widget.user.likes.length.toString()),
                        icon: widget.user.likes.contains(g)?Icon(Icons.thumb_up_off_alt_rounded,color: Colors.blue):
                        Icon(Icons.thumb_up_alt_outlined,color: Colors.blue)),
                    TextButton.icon(onPressed: (){

                    }, label: Text(widget.user.comments.length.toString()),
                        icon: Icon(Icons.comment_bank_rounded,color: Colors.blue))
                  ],
                ),
              )
            ],
          )),
    ),
          Container(
            width: MediaQuery.of(context).size.width,
            height:MediaQuery.of(context).size.height-325 ,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Company')
                  .doc(_user!.source).collection("Feeds").doc(widget.user.id).collection("Comment").orderBy("id",descending: true)
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
                        Icon(Icons.accessible_forward, color : Colors.red, size : 24,),
                        SizedBox(height: 7),
                        Text(
                          "No Comments found",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Looks likes the Feeds have No Comment",
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
                    Feed.fromJson(e.data())).toList() ?? []);
                return ListView.builder(
                  itemCount: _list.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FeedsUC(user: _list[index], firstu: widget.user.id, );
                  },
                );
              },
            ),
          ),

        ]
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.emoji_emotions),
                    ),
                    Expanded(
                      child: TextField(
                        controller: textcon,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Type Something........",
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {

                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            MaterialButton(
              shape: CircleBorder(),
              color: Colors.blue,
              minWidth: 0,
              onPressed: () async {
                if (textcon.text.isNotEmpty) {
                  try{
                    String g = DateTime.now().millisecondsSinceEpoch.toString();
                    String ui = FirebaseAuth.instance.currentUser!.uid;
                    Feed u =Feed(name: textcon.text, title: ui,
                        description: "", likes: [],
                        comments: [], announ: false,
                        hr: false, pic:"" , link: "", Ntname: _user!.Name, Ntpic: _user!.pic, id: g);
                    await  FirebaseFirestore.instance.collection("Company")
                        .doc(_user.source).collection("Feeds")
                        .doc(widget.user.id).collection("Comment").doc(g).set(u.toJson());

                  }catch(e){
                    print(e);
                  }
                  try{
                    await  FirebaseFirestore.instance.collection("Company")
                        .doc(_user!.source).collection("Feeds")
                        .doc(widget.user.id).update({
                      "comments":FieldValue.arrayUnion([g]),
                    });

                  }catch(e){

                  }
                  setState(() {
                    textcon = TextEditingController(text: "");
                  });
                  NotifyAll.sendc( "New comment to feed added by ${_user.Name}", textcon.text);
                }
              },
              child: Icon(Icons.send, color: Colors.white),
            ),
          ],
        )
      ],
    );
  }

  TextEditingController textcon=TextEditingController();

  String fo(String dateTimeString) {
    try {
      // Parse the DateTime string
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTimeString));

      // Get the current date
      DateTime now = DateTime.now();

      // Check if the dateTime is today
      bool isToday = dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;

      // Define date formats
      DateFormat timeFormat = DateFormat('HH:mm');
      DateFormat dateFormat = DateFormat('dd/MM/yy');
      return isToday ? timeFormat.format(dateTime) : dateFormat.format(
          dateTime);
    }catch(e){
      return "few min ago";
    }
  }
}
class FeedsUC extends StatelessWidget {
  FeedsUC({super.key, required this.user,required this.firstu});
  String g = FirebaseAuth.instance.currentUser!.uid;
  Feed user ;String firstu;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,bottom: 7),
        child: Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.Ntpic),
                    ),
                  ),
                  SizedBox(width: 9,),
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.Ntname,style: TextStyle(fontWeight: FontWeight.w600),),
                        Text(user.name,),
                      ],
                    ),
                  ),
                  Spacer(),
                  TextButton.icon(onPressed: () async {
                    if(user.likes.contains(g)){
                      await FirebaseFirestore.instance.collection("Company")
                          .doc(_user!.source).collection("Feeds")
                          .doc(firstu).collection("Comment").doc(user.id).update({
                        "likes":FieldValue.arrayRemove([g]),
                      });
                    }else{
                      await  FirebaseFirestore.instance.collection("Company")
                          .doc(_user!.source).collection("Feeds")
                          .doc(firstu).collection("Comment").doc(user.id).update({
                        "likes":FieldValue.arrayUnion([g]),
                      });
                    }

                  }, label: Text(user.likes.length.toString()),
                      icon: user.likes.contains(g)?Icon(Icons.thumb_up_off_alt_rounded,color: Colors.blue):
                      Icon(Icons.thumb_up_alt_outlined,color: Colors.blue))
                ],
              ),
            ))
    );
  }
  String fo(String dateTimeString) {
    try {
      // Parse the DateTime string
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTimeString));

      // Get the current date
      DateTime now = DateTime.now();

      // Check if the dateTime is today
      bool isToday = dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day;

      // Define date formats
      DateFormat timeFormat = DateFormat('HH:mm');
      DateFormat dateFormat = DateFormat('dd/MM/yy');
      return isToday ? timeFormat.format(dateTime) : dateFormat.format(
          dateTime);
    }catch(e){
      return "few min ago";
    }
  }
}