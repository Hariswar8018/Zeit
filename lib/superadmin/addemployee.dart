import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/model/organisation.dart';
import 'package:zeitt/model/usermodel.dart';
import 'package:zeitt/superadmin/user_approval.dart';

class Addemployee extends StatefulWidget {
  OrganisationModel user;
  String type,name;
   Addemployee({super.key,required this.user,required this.type,required this.name});

  @override
  State<Addemployee> createState() => _AddemployeeState();
}

class _AddemployeeState extends State<Addemployee> {
   bool empty=false,create=false;

  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Users to your Company",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: Column(
        children: [
          SizedBox(height: 10,),
          Center(
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    PageTransition(
                        child: UserApproval(find: widget.user.id),
                        type: PageTransitionType.leftToRight,
                        duration: Duration(milliseconds:40)));
              },
              child: Container(
                height:45,width:w-20,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.purpleAccent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                      spreadRadius: 5, // The extent to which the shadow spreads
                      blurRadius: 7, // The blur radius of the shadow
                      offset: Offset(0, 3), // The position of the shadow
                    ),
                  ],
                ),
                child: Center(child: Text("See Request Access >",style: TextStyle(
                    color: Colors.white,
                    fontFamily: "RobotoS",fontWeight: FontWeight.w800
                ),)),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    empty=true;create=true;
                  });
                },
                child: Center(
                  child: InkWell(
                    child: Container(
                      height:45,width:w/2-15,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:(empty&&create)?Colors.red:Colors.grey.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text("Create New User",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    empty=true;create=false;
                  });
                },
                child: Center(
                  child: InkWell(
                    child: Container(
                      height:45,width:w/2-15,
                      decoration:BoxDecoration(
                        borderRadius:BorderRadius.circular(7),
                        color:(empty&&!create)?Colors.green:Colors.grey.shade800,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                            spreadRadius: 5, // The extent to which the shadow spreads
                            blurRadius: 7, // The blur radius of the shadow
                            offset: Offset(0, 3), // The position of the shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text("Add Existing User",style: TextStyle(
                          color: Colors.white,
                          fontFamily: "RobotoS",fontWeight: FontWeight.w800
                      ),)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          !empty?SizedBox():(create?Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height : 7),
                t1("${widget.name} Login"),
                SizedBox(height : 7),
                t2("${widget.name} Email"),
                SizedBox(height : 4),
                sd(email, context),
                SizedBox(height : 7),
                t2("${widget.name} Password"),
                SizedBox(height : 4),
                sd(password, context),
                SizedBox(height : 7),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,top:10),
                  child: SocialLoginButton(
                    backgroundColor:(email.text.isEmpty||password.text.isEmpty)?Colors.grey: Color(0xff6001FF),
                    height: 40,
                    text: 'Add ${widget.name}',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {
                      String s2="";
                      try{
                        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
                        setState(() {
                          s2=cred.user!.uid;
                        });
                      }catch(e) {
                        try {
                          final cred = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                              email: email.text, password: password.text);
                          setState(() {
                            s2 = cred.user!.uid;
                          });
                        } catch (e) {
                          Send.message(context, "$e", false);
                          return null;
                        }
                      }
                      CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
                      try {
                        UserModel u = UserModel(
                            Email: email.text,
                            Name: "",
                            uid: s2,
                            bday: "",
                            education: "",
                            gender: "",
                            empid: "",
                            address: "",
                            country: " ",
                            state: "",
                            pic: "",
                            lastlogin: " ",
                            online: false,
                            employee: [],
                            following: [],
                            pan: "",
                            adhaar: "",
                            bio: "",
                            reporting: "",
                            location: "",
                            role: widget.type,
                            status: "",
                            type: widget.type,
                            source: widget.user.id,
                            joiningd:  DateTime.now().toString(),
                            exp: "",
                            totalexp: "",
                            identity: "", resumelink: '', resumetime: 9,
                            link1: '', link2: '', link3: '', shit: '', salary: 0,
                            meetlink: '', meetname: '', meetid: '', meetby: '',
                            meetpic: '', meetdesc: '', bankname: '', bankaccount: '', bankaccountname: '', upiname: '', ifsccode: ''
                        );
                        print("haan be");
                        try{
                          await usersCollection.doc(s2).update(u.toJson());
                        }catch(e){
                          try{
                            await usersCollection.doc(s2).set(u.toJson());
                          }catch(e){
                            Send.message(context, "$e", false);
                          }
                        }
                        Send.message(context, "Account Created Success for Director", true);
                        print("gh");
                      } catch (e) {
                        Send.message(context, "${e}", false);
                      }

                    },
                  ),
                ),
              ],
            ),
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height : 7),
                t1("Type zeitt ID"),
                SizedBox(height : 7),
                t2("Add zeitt Id of Employee"),
                SizedBox(height : 4),
                sd(email, context),
                SizedBox(height : 4),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,top:10),
                  child: SocialLoginButton(
                    backgroundColor:!(email.text.length>=12)?Colors.grey: Color(0xff6001FF),
                    height: 40,
                    text: 'Find Employee',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {
                      String s1 = email.text;
                      String s3=s1.substring(0,4);
                      String s4=s1.substring(4);
                      if(s3!="zeitt"){
                        print("Wrong ID");
                      }
                      else{
                        try {
                          // Reference to the 'users' collection
                          CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');

                          // Query the collection based on uid
                          QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: s4).get();

                          // Check if a document with the given uid exists
                          if (querySnapshot.docs.isNotEmpty) {
                            // Convert the document snapshot to a UserModel
                            UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
                            print(user);
                            Navigator.pop(context);
                            confirm(user,widget.type);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No User found !'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${e}'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
   void confirm(UserModel user1,String s){
     showModalBottomSheet<void>(
       context: context,
       builder: (BuildContext context) {
         return SizedBox(
           height: 360,
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
                     "Confirm the $s",
                     style: TextStyle(
                         fontWeight: FontWeight.w700, fontSize: 20)),
                 SizedBox(height: 9),
                 Text(textAlign: TextAlign.center,
                     "We found out this User ! Please check is it Correct? By clicking Yes, The User will be added to the Company.",
                     style: TextStyle(
                         fontWeight: FontWeight.w400, fontSize: 18)),
                 SizedBox(height: 14),
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                       width: MediaQuery.of(context).size.width,
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(12.0),
                         child: ListTile(
                           leading: CircleAvatar(
                             backgroundImage: NetworkImage(user1.pic),
                             radius: 25,
                           ),
                           title: Text(user1.Name,style :TextStyle(fontWeight: FontWeight.w800,fontSize: 18)),
                           subtitle: Text(user1.education,style :TextStyle(fontWeight: FontWeight.w800,)),
                           trailing:Icon(Icons.work,color:Colors.red,size: 25,),
                         ),
                       )),
                 ),
                 Padding(
                   padding: const EdgeInsets.only(left:18.0,right:18,top:10),
                   child: SocialLoginButton(
                     backgroundColor: Color(0xff6001FF),
                     height: 40,
                     text: 'Yes ! this is the User',
                     borderRadius: 20,
                     fontSize: 21,
                     buttonType: SocialLoginButtonType.generalLogin,
                     onPressed: () async {
                       try {
                         if (user1.source.isEmpty&&user1.type==s) {
                           await FirebaseFirestore.instance.collection("Users")
                               .doc(user1.uid)
                               .update({
                             "source": widget.user.uid,
                             "joiningd":DateTime.now().toString(),
                           });
                           await FirebaseFirestore.instance.collection("Company")
                               .doc(widget.user.uid)
                               .update({
                             "people": FieldValue.arrayUnion([user1.uid]),
                           });
                           Navigator.pop(context);
                           Send.message(context, "Success Added", true);
                         }else if (user1.type!=s) {
                           Send.message(context, "User Account exist but he is not $s", false);
                         }else {
                           Navigator.pop(context);
                           Send.message(context,
                               "The Employee is already added to a Company ! Please remove it first",
                               false);
                         }
                       }catch(e){
                         Send.message(context, "$e", false);
                       }
                     },
                   ),
                 ),
               ],
             ),
           ),
         );
       },
     );
   }
  TextEditingController password=TextEditingController();

  TextEditingController email=TextEditingController();

  Widget sd (TextEditingController cg,  BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',

                ),
              ),
            )
        ),
      ),
    );
  }

  Widget t1(String g){
    return Text(g, style : TextStyle(fontSize: 27, fontWeight: FontWeight.w700));
  }

  Widget t2(String g){
    return Text(g, style : TextStyle(fontSize: 18, fontWeight: FontWeight.w300));
  }
}
