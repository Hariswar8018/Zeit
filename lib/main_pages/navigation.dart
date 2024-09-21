import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';

import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/main.dart';
import 'package:zeit/main_pages/approval_clone.dart';
import 'package:zeit/main_pages/approvals.dart';
import 'package:zeit/main_pages/home.dart';
import 'package:zeit/main_pages/more.dart';
import 'package:zeit/main_pages/services.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/services/task.dart';

import '../functions/notification.dart';
import '../model/usermodel.dart';

const List<TabItem> items = [
  TabItem(
    icon: Icons.dashboard,
    title: "Services"
  ),
  TabItem(
    icon: Icons.home,
    title: 'Home',
  ),
  TabItem(
    icon: Icons.add,
  ),
  TabItem(
    icon: Icons.turned_in_rounded,
    title: 'Approvals',
  ),
  TabItem(
    icon: Icons.menu,
    title: 'More',
  ),
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int visit = 1;
  double height = 30;
  Color colorSelect =const Color(0XFF0686F8);
  Color color = const Color(0XFF7AC0FF);
  Color color2 = const Color(0XFF96B1FD);
  Color bgColor = const  Color(0XFF1752FE);
  Widget as(int i ){
    if( i == 0){
      return Services();
    }else if(i == 1){
      return Home();
    }else if(i == 2){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet<void>(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: SizedBox(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text("Add New Service for Organisation",style:TextStyle(fontSize: 19,fontWeight: FontWeight.w700)),
                      SizedBox(height: 15),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Notify(),
                                      type: PageTransitionType.leftToRight,
                                      duration: Duration(milliseconds: 400)));
                            },
                            child: q(context, "assets/announcement-shout-svgrepo-com.svg", "Announcment")),
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Taskk(hr: false,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 600)));
                            },
                            child: q(context, "assets/time-complexity-svgrepo-com.svg", "Task")),
                      ]),
                      SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Approval(),
                                      type: PageTransitionType.leftToRight,
                                      duration: Duration(milliseconds: 400)));
                            },
                            child: q(context, "assets/calender-day-love-svgrepo-com.svg", "Cases")),
                        InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Taskk(hr: false,),
                                      type: PageTransitionType.rightToLeft,
                                      duration: Duration(milliseconds: 600)));
                            },
                            child: q(context, "assets/office-worker-svgrepo-com.svg", "Training")),
                      ]),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      });
      visit=1;
      return as(1); // Placeholder widget.
    }else if(i == 3){
      return Approvals();
    }else{
      return More();
    }
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 2 - 40;
    double h = MediaQuery.of(context).size.width / 2 - 130;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 12),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500)),
            ]));
  }
  Widget r(bool b,String str,Widget rt){
    return ListTile(
      onTap: () async {
        Navigator.pop(context);
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("Make $str"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }

  String ay(i){
    if( i == 0){
      return "Services";
    }else if(i == 1){
      return "Home";
    }else if(i == 2){
      return "Home";
    }else if(i == 3){
      return "Approvals";
    }else{
      return "More";
    }
  }
  vq() async {
    UserProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshuser();
  }

  void initState(){
    vq();
    super.initState();
    vq();
    gh();
  }
  Future<void> gh() async {
    String hj = DateTime.now().toString();
    print(hj);
    await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "last":hj,
    });
    hjk();
  }
  Future<void> hjk() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    if(_user!.joiningd==" "||_user!.joiningd==""||_user!.joiningd==" "||_user.joiningd.isEmpty){
      String hj = DateTime.now().toString();
      print(hj);
      await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).update({
        "joiningd":hj,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return WillPopScope(
      onWillPop: () async {
        bool exit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit App'),
              content: Text('Are you sure you want to exit?'),
              actions: [
                ElevatedButton(
                  child: Text('No'),
                  onPressed: () {
                    // Return false to prevent the app from exiting
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: Text('Yes'),
                  onPressed: () {
                    // Return true to allow the app to exit
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          },
        );

        // Return the result to handle the back button press
        return exit ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left : 9.0, right : 2),
            child: InkWell(
              onTap : (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: UserC(user: _user,),
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 300)));
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(_user!.pic),
              ),
            ),
          ), title: Text(ay(visit), style : TextStyle(fontWeight: FontWeight.w800, fontSize: 27)),
          actions: [
            IconButton(onPressed: (){
              if(_user.source.isEmpty){
                Send.message(context, "This function will work once you are Attached to Organisation", false);
              }else{
                Navigator.push(
                    context,
                    PageTransition(
                        child: Search(user: _user,),
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 300)));
              }
            }, icon: Icon(Icons.search)),
            IconButton(onPressed: (){
      if(_user.source.isEmpty){
        Send.message(context, "This function will work once you are Attached to Organisation", false);
      }else{
        Navigator.push(
            context,
            PageTransition(
                child: Notify(),
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 400)));}
            }, icon: Icon(Icons.notifications)),
            SizedBox(width : 8),
          ],
        ),
        body: as(visit),
        bottomNavigationBar: Container(
          child:  BottomBarCreative(
            items: items,
            backgroundColor: Colors.white,
            color: Colors.black,
            colorSelected: colorSelect,
            indexSelected: visit,
            isFloating: true,
            highlightStyle:const HighlightStyle(sizeLarge: true, isHexagon: true, elevation: 2),
            onTap: (int index) => setState(() {
              visit = index;
            }),
          ),
        ),
      ),
    );
  }
}
