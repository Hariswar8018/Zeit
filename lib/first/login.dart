import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeit/first/forgot.dart';
import 'package:zeit/first/info.dart' ;
import 'package:zeit/functions/flush.dart';
import 'package:zeit/main.dart' ;
import 'package:zeit/model/usermodel.dart' ;

import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../main_pages/navigation.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final TextEditingController _ref = TextEditingController();
  final TextEditingController _con = TextEditingController();
  String s = "Demo";
  String d = "Demo";

  @override
  void dispose() {
    _emailController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool on = true;
    String var1 = " ";
    bool go = false ;
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
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
          automaticallyImplyLeading: true,  backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: on ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/IMG-20240607-WA0011.jpg", height: 100,),
            SizedBox(height: 20,),
            Text("  Login with your Account",
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  "Type your Email to login to account. You could use Google or Facebook too. If you don't have account, do signup",
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
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _confirmPasswordController.text,
                      );
                      Navigator.push(
                          context, PageTransition(
                          child:MyHomePage(title: 'hjh',), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 50)
                      ));
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Send.message(context, "No User found for this Email", false);
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        Send.message(context, "Wrong password provided for that user", false);
                      } else {
                        Send.message(context, "$e", false);
                      }
                      a();
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 15.0, right : 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : [
                  TextButton(
                    child : Text("SignUp", style : TextStyle(color : Colors.blue)), onPressed : (){
                      setState((){
                        on = !on ;
                      });
                  }
                  ),
                  TextButton(
                      child : Text("Forgot Password ?", style : TextStyle(color : Colors.blue)), onPressed : (){
                    Navigator.push(
                        context, PageTransition(
                        child:ForgotP(), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 50)
                    ));
                  }
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 20.0, right : 20),
              child: Text(
                  "By continuing, You agree to our Terms & Condition",
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.grey)),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness : 0.5
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: SocialLoginButton(
                  backgroundColor: Colors.grey.shade100,
                  height: 40,
                  text: 'Continue with Google',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.google,
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
                      final GoogleSignInAuthentication googleAuth = await googleUser!
                          .authentication;
                      final AuthCredential credential = GoogleAuthProvider
                          .credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );
                      await FirebaseAuth.instance.signInWithCredential(credential);
                      String uid= await FirebaseAuth.instance.currentUser!.uid;
                      checkonce(uid);
                    }catch(e){
                      print(e);
                      Send.message(context, "$e", false);
                    }
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: SocialLoginButton(
                  backgroundColor: Colors.blue,
                  height: 40,
                  text: 'Continue with Facebook',
                  borderRadius: 20,
                  fontSize: 21,
                  buttonType: SocialLoginButtonType.facebook,
                  onPressed: () async {

                  }),
            ),
          ],
        ) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/IMG-20240607-WA0011.jpg", height: 100,),
            SizedBox(height: 20,),
            Text("  Create your Account",
                style: TextStyle(fontSize: 29, fontWeight: FontWeight.w800)),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  "Welcome to our App. We will be helping you in setting up your Account",
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.grey)),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fg(w,0,"Individual"),fg(w,1,"HR"),
                fg(w,2,"Director"),
              ],
            ),
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
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
            go ? Center(
              child : CircularProgressIndicator
                ()
            ) : Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: SocialLoginButton(
                  backgroundColor: Colors.blue,
                  height: 40,
                  text: 'Create Account as $strin',
                  borderRadius: 20,
                  fontSize: 20,
                  buttonType: SocialLoginButtonType.generalLogin,
                  onPressed: () async {
                    a();
                    try {
                      final credential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _confirmPasswordController.text,
                      );
                      print(credential);
                      String sn = credential.user!.uid ;
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Step1(strr: strin,),
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 800)));
                      Send.message(context, "Welcome, We will need some additional details for Account to Ste Up", true);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                        Send.message(context, "The password provided is too weak", false);
                      } else if (e.code == 'email-already-in-use') {
                        print(
                            'The account already exists for that email.');
                        Send.message(context, "The account already exists for that email.", false);
                      } else {
                        Send.message(context, "$e", false);
                      }
                    } catch (e) {
                      Send.message(context, "$e", false);
                    }
                    a();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 15.0, right : 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children : [
                    TextButton(
                        child : Text("Not New ? Login", style : TextStyle(color : Colors.blue)), onPressed : (){
                      setState((){
                        on = !on ;
                      });
                    }
                    ),
                    SizedBox(width : 6),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left : 20.0, right : 20),
              child: Text(
                  "By continuing, You agree to our Terms & Condition",
                  style:
                  TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.grey)),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
  Future<void> checkonce(String uid) async {
    CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();
    if (querySnapshot.docs.isNotEmpty) {
      // Convert the document snapshot to a UserModel
      UserModel user = UserModel.fromSnap(querySnapshot.docs.first);

      Navigator.push(
          context, PageTransition(
          child:MyHomePage(title: 'hjh',), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 50)
      ));
      Send.message(context, "Login Success !",true);
    } else {
      Navigator.push(
          context,
          PageTransition(
              child: Step1(strr: strin,),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 800)));
      Send.message(context, "Welcome, We will need some additional details for Account to Set Up", true);
    }
  }
  String strin = "Individual";
  Widget fg(double w,int i,String st){
    return InkWell(
      onTap: (){
        setState(() {
          strin=st;
        });
      },
      child: Card(
        color: st==strin?Colors.blue:Colors.white,
        child: Container(
          width: w/3-10,
          height: w/3-10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sd(i,st==strin),
              SizedBox(height: 5,),
              Text(st,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: st==strin?Colors.white:Colors.black),)
            ],
          ),
        ),
      ),
    );
  }
  Widget sd(int i,bool yes){
    if(i==0){
      return Icon(Icons.accessibility_new,color:yes?Colors.white:Colors.black,size: 20,);
    }else if(i==1){
      return Icon(Icons.work,color:yes?Colors.white:Colors.black,size: 20,);
    }else if(i==2){
      return Icon(Icons.factory,color:yes?Colors.white:Colors.black,size: 20,);
    }else {
      return Icon(Icons.security,color:yes?Colors.white:Colors.black,size: 20,);
    }
  }

  void a(){
    setState((){
      go = !go ;
    });
  }
}

