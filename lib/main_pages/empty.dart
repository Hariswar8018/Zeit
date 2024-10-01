import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/organisation/info.dart';
import 'package:zeitt/organisation/manually.dart';

import '../model/usermodel.dart';
import '../provider/declare.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network("https://cdn-icons-png.flaticon.com/512/7486/7486744.png",width:230),
          SizedBox(height: 7),
          Text(
            "No zeitt Account Exist for the User",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(textAlign:TextAlign.center,
              "You need to add your Account to a Organisation to access this Page and use Services",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Center(
            child: InkWell(
              onTap: (){
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 280,
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
                                "Company Exist in zeitt ▶️ ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 20)),
                            SizedBox(height: 9),
                            SizedBox(height: 9),
                            Text(textAlign: TextAlign.center,
                                "You could ask HR to add you to their Organisation by giving your ID. And you will be added Immediately",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 18)),
                            SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Container(
                                    width : MediaQuery.of(context).size.width , height : 60,
                                    decoration: BoxDecoration(
                                      color: Color(0xffE9075B), // Background color of the container
                                      borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                    ),
                                    child : InkWell(
                                      onTap: () {
                                        Clipboard.setData(
                                            new ClipboardData(text: "zeitt"+_user!.uid));
                                        Navigator.pop(context);
                                        Send.message(context, "Copied to ClipBoard", true);
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(17.0),
                                          child:Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.copy, color : Colors.white),
                                              SizedBox( width : 9),
                                              Text("zeitt"+_user!.uid, style : TextStyle( fontSize : 17, color : Colors.white, fontWeight: FontWeight.w900)),
                                            ],
                                          )
                                      ),
                                    )
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                height:45,width:w-40,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("My zeitt ID to Share",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: Manually(),
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 40)));
              },
              child: Container(
                height:45,width:w-40,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("Ask for Request Manually",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void gj(BuildContext context) {


  }
}


class Empty2 extends StatelessWidget {
  const Empty2({super.key});

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network("https://cdn-icons-png.flaticon.com/512/7486/7486744.png",width:230),
          SizedBox(height: 7),
          Text(
            "Start by Creating Organisation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(textAlign:TextAlign.center,
              "You need to attach yourself to Organisation or create a new one if Organisation don't exist in zeitt.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 13,),
          InkWell(
            onTap: (){
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 280,
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
                              "Company Exist in zeitt ▶️ ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20)),
                          SizedBox(height: 9),
                          SizedBox(height: 9),
                          Text(textAlign: TextAlign.center,
                              "You could ask HR to add you to their Organisation by giving your ID. And you will be added Immediately",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18)),
                          SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Container(
                                  width : MediaQuery.of(context).size.width , height : 60,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE9075B), // Background color of the container
                                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                  ),
                                  child : InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                          new ClipboardData(text: "zeitt"+_user!.uid));
                                      Navigator.pop(context);
                                      Send.message(context, "Copied to ClipBoard", true);
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child:Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.copy, color : Colors.white),
                                            SizedBox( width : 9),
                                            Text("zeitt"+_user!.uid, style : TextStyle( fontSize : 17, color : Colors.white, fontWeight: FontWeight.w900)),
                                          ],
                                        )
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Center(
              child: Container(
                height:45,width:w-40,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.blue,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("My zeitt ID to Share",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
          SizedBox(height: 9,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: InkWell(
                  onTap: () async {
                    await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Create Organisation?'),
                        content: Text("Once created, Organisation can't able to add you and you will from now on manage Organisation in our App"),
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
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: Step2(),
                                        type: PageTransitionType.bottomToTop,
                                        duration: Duration(milliseconds: 300)));

                              }catch(e){
                                Send.message(context, "${e}", false);
                              }
                            },
                          ),
                        ],
                      );
                    },
                    );
                  },
                  child: Container(
                    height:45,width:w/2-30,
                    decoration:BoxDecoration(
                      borderRadius:BorderRadius.circular(7),
                      color:Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                          spreadRadius: 5, // The extent to which the shadow spreads
                          blurRadius: 7, // The blur radius of the shadow
                          offset: Offset(0, 3), // The position of the shadow
                        ),
                      ],
                    ),
                    child: Center(child: Text("Create Organisation",style: TextStyle(
                        color: Colors.white,
                        fontFamily: "RobotoS",fontWeight: FontWeight.w800
                    ),)),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: Manually(),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 40)));
                  },
                  child: Container(
                    height:45,width:w/2-30,
                    decoration:BoxDecoration(
                      borderRadius:BorderRadius.circular(7),
                      color:Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                          spreadRadius: 5, // The extent to which the shadow spreads
                          blurRadius: 7, // The blur radius of the shadow
                          offset: Offset(0, 3), // The position of the shadow
                        ),
                      ],
                    ),
                    child: Center(child: Text("Add Manually",style: TextStyle(
                        color: Colors.white,
                        fontFamily: "RobotoS",fontWeight: FontWeight.w800
                    ),)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          SizedBox(height: 10),
        ],
      ),
    );
  }
  void gj(BuildContext context) {


  }
}
