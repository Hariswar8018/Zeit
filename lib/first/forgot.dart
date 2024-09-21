import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeit/first/info.dart' ;
import 'package:zeit/main.dart' ;
import 'package:zeit/model/usermodel.dart' ;

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../main_pages/navigation.dart';


class ForgotP extends StatefulWidget {
  ForgotP({super.key});

  @override
  State<ForgotP> createState() => _ForgotPState();
}

class _ForgotPState extends State<ForgotP> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,  backgroundColor: Colors.white,
        ),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
            Image.asset("assets/IMG-20240607-WA0011.jpg", height: 100,),
          SizedBox(height: 20,),
          Text("  Forgot your Password",
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                "Type your Email to send Password Reset Email to your Account",
                style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.grey)),
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width : MediaQuery.of(context).size.width  , height : 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              child: Padding(
                  padding: const EdgeInsets.only( left :10, right : 18.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      isDense: true,
                      border: InputBorder.none, // No border
                    ),
                  )
              ),
            ),
          ),
          SizedBox(
            height: 18,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SocialLoginButton(
                backgroundColor: Colors.blue,
                height: 40,
                text: 'Login Now',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async {
                  a();
                  try {
                    final credential = await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Password Reset Email Sent !'),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No User found for this Email'),
                        ),
                      );
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Wrong password provided for that user.'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${e}'),
                        ),
                      );
                    }
                    a();
                  }
                }),
          ),



        ],
      )
    );
  }

  void a(){
    setState((){
      go = !go ;
    });
  }
  bool go = false;
}
