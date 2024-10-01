import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/model/messagecard.dart';
import 'package:zeit/notification/notify_all.dart';
import 'package:zeit/services/biubble.dart';
import 'package:zeit/services/files_see.dart';


import '../model/usermodel.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../provider/declare.dart';

class ChatPage extends StatefulWidget {
  final UserModel user;
  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Fire = FirebaseFirestore.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Messages> _list = [];
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController textcon = TextEditingController();

  String getConversationId(String id) =>
      widget.user.uid.hashCode <= id.hashCode ? '${user?.uid}_$id' : '${id}_${user?.uid}';
  String yu = FirebaseAuth.instance.currentUser!.uid;

  Future<void> sendMessage(UserModel user1, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages messages = Messages(read: 'me', told: user1.uid, from: widget.user.uid, mes: msg, type: Type.text, sent: time);

    await _firestore.collection('Chat/${getConversationId('${user1.uid}')}/messages/').doc(time).set(messages.toJson(Messages(read: 'me',
        told: user1.uid, from: widget.user.uid, mes: msg, type: Type.text, sent: time)));

    await FirebaseFirestore.instance.collection("Users").doc(user1.uid).update(
        {
          "Mess": FieldValue.arrayUnion([yu]),
        });
    await FirebaseFirestore.instance.collection("Users").doc(widget.user.uid).update(
        {
          "Mess": FieldValue.arrayUnion([yu]),
        });
    String userToken = widget.user.token; // Replace with the actual user's FCM token
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel user3){
    return _firestore.collection('Chat/${getConversationId(user3.uid)}/messages/').snapshots();
  }

  Future<void> updateStatus(Messages message)async {
    _firestore.collection('Chat/${getConversationId('${message.from}')}/messages/').doc(message.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _AppBar(),
          backgroundColor: Colors.white,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://mrwallpaper.com/images/thumbnail/cute-emoticons-whatsapp-chat-9j4qccr8lqrkcwaj.webp"),
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return SizedBox(height: 10,);
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data?.map((e) => Messages.fromJson(e.data()))
                            .toList() ?? [];
                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: _list.length,
                            padding: EdgeInsets.only(top: 10),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MessageCard(message: _list[index],);
                            },);
                        } else {
                          return Center(
                            child: Text("Say Hi to each other "),
                          );
                        }
                    }
                  },
                ),
              ),
              _ChatInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _AppBar() {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: UserC(user: widget.user,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 400)));
      },
      child: Row(
        children: [
          IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios)),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.user.pic),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.user.Name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              Text("Last Seen : " + fo(widget.user.lastlogin)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ChatInput() {
    String s  = " ";
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                IconButton(onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AddS( title: '', userr: widget.user),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 60)));
                }, icon: Icon(Icons.file_copy_sharp),),
                Expanded(
                  child: TextField(
                    controller: textcon,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Type Something........",
                      border: InputBorder.none,
                    ), onChanged: ((value){
                    s = value;
                  }),
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
            if (s.isNotEmpty) {
              sendMessage(widget.user , textcon.text);
              as(textcon.text);
              setState(() {
                s = " ";
                textcon = TextEditingController(text: "");
              });
            }
          },
          child: Icon(Icons.send, color : Colors.white),
        ),
      ],
    );
  }

  void as(String desc){
    try {
      UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
      NotifyAll.sendNotification(
          "New Message by " + _user!.Name, desc,widget.user.token);
    }catch(e){
      print(e);
    }
  }


  String fo(String dateTimeString) {
    // Parse the DateTime string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Get the current date
    DateTime now = DateTime.now();

    // Check if the dateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    // Define date formats
    DateFormat timeFormat = DateFormat('HH:mm');
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    // Return the formatted date
    return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);
  }
}

