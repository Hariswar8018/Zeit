import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/superadmin/view_company.dart';

import '../provider/declare.dart';

class AdminLogin extends StatelessWidget {
  const AdminLogin({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
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
          leading: Padding(
            padding: const EdgeInsets.only(left : 9.0, right : 2),
            child: InkWell(
              onTap : (){

              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(_user!.pic),
              ),
            ),
          ), title: Text("Admin Control", style : TextStyle(fontWeight: FontWeight.w800, fontSize: 27)),
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
