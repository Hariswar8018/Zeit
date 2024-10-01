import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/main.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/organisation/all_users.dart';
import 'package:zeit/superadmin/view_company.dart';

import '../provider/declare.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the alert dialog and wait for a result
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
                    SystemNavigator.pop();
                    Navigator.of(context).pop(true);
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
           title: Text("Admin Control", style : TextStyle(fontWeight: FontWeight.w800, fontSize: 27)),
          actions: [
            IconButton(onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout? '),
                    content: Text('You Sure to LOGOUT from the App'),
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
                          await FirebaseAuth.instance.signOut();
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Splash(),
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 300)));
                          Send.message(context, "Log Out Success", true);
                        },
                      ),
                    ],
                  );
                },
              );
            }, icon: Icon(Icons.login, color : Colors.red,size: 35,)),
          ],
        ),
        body:Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ViewCompanies(view: false,),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 300)));
                  },
                  child: q(context, "assets/police-station-svgrepo-com.svg", "Company Approval")),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ViewCompanies(view: true,),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 300)));
                  },
                  child: q(context, "assets/factory-company-svgrepo-com.svg", "View Company")),
            ]),
            SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ViewUseries(view: false,),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 300)));
                  },
                  child: q(context, "assets/identity-and-access-management-svgrepo-com.svg", "Users Account")),
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ViewUseries(view: true,),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 300)));
                  },
                  child: q(context, "assets/identitycardmajor-svgrepo-com.svg", "View By Position")),
            ]),
          ],
        )
      ),
    );
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 135;
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
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500)),
            ]));
  }
}
