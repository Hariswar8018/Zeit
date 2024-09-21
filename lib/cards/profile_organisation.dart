import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/feeds.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/update/update_user.dart';
import '../model/usermodel.dart';
import '../model/organisation.dart';
import 'FeedsU.dart';
import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeit/main.dart';
import 'package:zeit/main_pages/navigation.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart'  ;
import 'package:zeit/provider/upload.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class ProO extends StatefulWidget {

  ProO({super.key, required this.user});
  OrganisationModel user;

  @override
  State<ProO> createState() => _ProOState();
}

class _ProOState extends State<ProO> {
  int active=0;
  bool myuser(){
    String gh = FirebaseAuth.instance.currentUser!.uid;
    if(widget.user.admin.contains(gh)){
      return true;
    }else{
      return false;
    }
  }
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  @override
  Widget build(BuildContext context) {
    double ww =  MediaQuery.of(context).size.width ;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 18,)),
            ),
          ),
        ),
        elevation: 0, backgroundColor: Colors.transparent,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.user.pic1,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Image.asset(
                      'assets/IMG-20240607-WA0011.jpg', // Path to your local placeholder image
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    );
                  },
                ),
                Positioned(
                    top: 150,left: 10,
                    child: myuser()?InkWell(
                      onTap: () async {
                        try {
                          lk.Uint8List? file = await pickImage(ImageSource.gallery);
                          if (file != null) {
                            String photoUrl = await StorageMethods().uploadImageToStorage(
                                'Company', file, true);
                            await FirebaseFirestore.instance.collection("Company").doc(widget.user.uid).update({
                              "pic1":photoUrl,
                            });
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logo Uploaded"),
                            ),
                          );
                        }catch(e){
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${e}"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)
                        ),
                          width: 120,height: 40,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                                                  children: [
                            Text("  Upload Cover",style:TextStyle(color: Colors.white)),
                            Icon(Icons.upload,color: Colors.white,),
                                                  ],
                                                ),
                          )),
                    ):SizedBox())
              ],
            ),
            SizedBox(height: 15,),
            Container(
              width :MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left : 10.0, right :10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.user.logo),fit: BoxFit.cover
                        )
                      ),
                    ),
                    SizedBox(width :15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.user.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),),
                        Container(
                            width : ww- 90,
                            child: Row(
                              children: [
                                Text(widget.user.desc, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.grey),),
                                myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                                  Navigator.push(
                                      context, PageTransition(
                                      child: Update(Name: 'Small Description', doc: widget.user.uid, Firebasevalue: 'desc', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                                  ));
                                }):SizedBox(),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 13,),
            r( Icon(Icons.business, color : Colors.red),widget.user.type + " Company"),
            Row(
              children: [
                r( Icon(Icons.phone, color: Colors.blue), "Phone : " + widget.user.phone),
                myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                  Navigator.push(
                      context, PageTransition(
                      child: Update(Name: "Phone", doc: widget.user.uid, Firebasevalue: 'phone', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                }):SizedBox(),
              ],
            ),
            Row(
              children: [
                r( Icon(Icons.mail, color : Colors.green), "Email : " + widget.user.email),
                myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
                  Navigator.push(
                      context, PageTransition(
                      child: Update(Name: 'Email', doc: widget.user.uid, Firebasevalue: 'email', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                }):SizedBox(),
              ],
            ),
            Row(
              children: [
                r( Icon(Icons.location_on_rounded, color : Colors.red),"Address : " + widget.user.address),
              ],
            ),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 35, width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: 4,scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int qIndex) {
                    return InkWell(
                      onTap: (){
                        setState((){
                          active = qIndex ;
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: ayu(qIndex)
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(thickness: 0.5,),
            ),
            op(),
          ],
        ),
      )
    );
  }

  Widget op(){
    if(widget.user.status!="Approve"&&active<3){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40, width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.red,
                  width: 2
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Row(
                children: [
                  SizedBox(width: 9,),
                 widget.user.status=="Block"? Text("This Company is ",style:TextStyle(fontWeight: FontWeight.w600))
                     : Text("This Company is still ",style:TextStyle(fontWeight: FontWeight.w600)),
                  Text(widget.user.status,style:TextStyle(fontWeight: FontWeight.w900,color:Colors.red)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          widget.user.status=="Block"? Text("If you think we had Done Mistake, Please Contact",style:TextStyle(fontWeight: FontWeight.w600))
              : Text("If it's taking more Time than Usual, Kindly Contact",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 15)),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue,
                child: IconButton(onPressed: () async {
                  final Uri _url = Uri.parse("tel:8592025948");
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                }, icon: Icon(Icons.call,color:Colors.white)),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.red,
                child: IconButton(onPressed: () async {
                  final Uri _url = Uri.parse("mailto:brmrinnovations@gmail.com");
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                }, icon: Icon(Icons.mail,color:Colors.white)),
              ),
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.green,
                child: IconButton(onPressed: () async {
                  final Uri _url = Uri.parse("https://wa.me/918592025948");
                  if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                  }
                }, icon: Icon(CupertinoIcons.chat_bubble_2_fill,color:Colors.white)),
              ),
            ],
          )
        ],
      );
    }
    if(active==0){
      return r3();
    }else if(active == 1){
      return r2(true);
    }else if( active == 2){
      return r2(false);
    }else{
      return r1();
    }
  }
  Widget r1(){
    return Column(
      children: [
        myuser()?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(8)
          ),
            child: Row(
              children: [
                SizedBox(width: 10,),
                Text("Update Location",style: TextStyle(fontWeight: FontWeight.w800),),
                Spacer(),
                InkWell(
                  onTap: () async {
                    Map<String, double> locationData = await Navigator.push(
                      context,
                      PageTransition(
                        child: Google_F(lat: 56, lon: 55),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 50),
                      ),
                    );
                    double lat = locationData['lat'] ?? 0.0;
                    double lon = locationData['lng'] ?? 0.0;
                    String address = locationData['address']?.toString() ?? "Unknown address";
                    print(address);
                    await FirebaseFirestore.instance.collection("Company").doc(widget.user.id).update({
                      "address":address,
                      "lat":lat,
                      "long":lon,
                    });

                  },
                  child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.location_history_sharp,size: 20,)),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
        ):SizedBox(),
        r( Icon(Icons.calendar_month, color : Colors.red),"Date of Est. : " + widget.user.bday),
        r( Icon(Icons.business, color : Colors.blue),"Incor. Id : " + widget.user.uid),
        r( Icon(Icons.important_devices, color : Colors.green),"Company Id : " + widget.user.uid),
        Row(
          children: [
            r( Icon(Icons.money, color : Colors.orange),"Pan Card : " + widget.user.pan),
            myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
              Navigator.push(
                  context, PageTransition(
                  child: Update(Name: 'Pan Card', doc: widget.user.uid, Firebasevalue: 'pan', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
              ));
            }):SizedBox(),
          ],
        ),
        Row(
          children: [
            r( Icon(Icons.credit_card, color : Colors.blue),"Tan Card : " + widget.user.tan),
            myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
              Navigator.push(
                  context, PageTransition(
                  child: Update(Name: 'Tan Card', doc: widget.user.uid, Firebasevalue: 'tan', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
              ));
            }):SizedBox(),
          ],
        ),

      ]
    );
  }

  Widget r2(bool b ){
    List<UserModel> _list = [];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 40,decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(8)
          ),
            child: Row(
              children: [
                SizedBox(width: 10,),
                Text(b?"Add Employees":"Add Admins",style: TextStyle(fontWeight: FontWeight.w800),),
                Spacer(),
                InkWell(
                  onTap: (){
                    opeen(b);
                  },
                  child: CircleAvatar(
                    radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add,size: 20,)),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
            height: 800,
            child:  StreamBuilder(
          stream: b ? FirebaseFirestore.instance
              .collection('Users').where("source",isEqualTo: widget.user.id)
              .snapshots(): FirebaseFirestore.instance
              .collection('Users').where("admin",arrayContains: widget.user.id)
              .snapshots()  ,
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
                      "Looks likes we can't find any peers",
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
        )
        ),
      ],
    );
  }

  Widget r3( ){
    List<Feed> _list = [];
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child:  StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Company').doc(widget.user.id).collection("Feeds")
              .snapshots()  ,
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
                      "No Post found",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Looks likes we can't find any posts",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }

            final data = snapshot.data?.docs;
            _list.clear();
            _list.addAll(data?.map((e) => Feed.fromJson(e.data())).toList() ?? []);
            return ListView.builder(
              itemCount: _list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedsU(user: _list[index]),
                );
              },
            );
            return GridView.builder(
              itemCount: _list.length,
              padding: EdgeInsets.only(top: 10),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
              ),
              itemBuilder: (context, index) {

              },
            );
          },
        )
    );
  }
  String ga(int i){
    if ( i == 0 ){
      return "Posts";
    }else if ( i == 1){
      return "Employee";
    }else if ( i == 2){
      return "Managment";
    }else if ( i == 3){
      return "About";
    }else if ( i == 4){
      return "Files";
    }else if ( i == 5){
      return "Travel Requests";
    }else {
      return "None";
    }
  }
  Widget ayu(int i ){
    return Text(ga(i), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,color :active ==i? Colors.black:Colors.grey.shade500),);
  }

  Widget r(Widget  g, String str){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width:7),
         g,
          SizedBox(width: 10),
          Text(str, style: TextStyle(fontWeight: FontWeight.w800,
              fontSize: 14, color: Colors.grey.shade800),),
        ],
      ),
    );
  }
  void opeen(bool b) {
    TextEditingController c = TextEditingController();
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
                   b? "Add Employee ID":"Add Company Admins",
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20)),
                SizedBox(height: 9),
                SizedBox(height: 9),
                Text(textAlign: TextAlign.center,
                    "Add Employee ID here to add it to your Organisation, and Invite them to our App",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 18)),
                SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: c,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: ' Enter Employee ID',
                      isDense: true,
                      suffixIconColor: Colors.blueAccent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the value as needed
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:18.0,right:18,top:10),
                  child: SocialLoginButton(
                    backgroundColor:!(c.text.length>=12)?Colors.grey: Color(0xff6001FF),
                    height: 40,
                    text: 'Find Employee',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {
                      String s1 = c.text;
                      String s3=s1.substring(0,4);
                      String s4=s1.substring(4);
                      if(s3!="ZEIT"){
                        print("Wrong ID");
                      }else{
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
                            confirm(user,b);
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
          ),
        );
      },
    );

  }
  void confirm(UserModel user1,bool b){
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
                    b? "Confirm the User":"Confirm the Admin",
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
                      if(user1.source.isEmpty){
                          await FirebaseFirestore.instance.collection("Users")
                              .doc(user1.uid)
                              .update({
                            "type": 'Individual',
                            "source": widget.user.uid,
                          });
                          await FirebaseFirestore.instance.collection("Company")
                              .doc(widget.user.uid)
                              .update({
                            "people": FieldValue.arrayUnion([user1.uid]),
                          });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added'),
                          ),
                        );
                      }else if(!b){
                        await FirebaseFirestore.instance.collection("Company")
                            .doc(widget.user.uid)
                            .update({
                          "admin": FieldValue.arrayUnion([user1.uid]),
                          "people": FieldValue.arrayUnion([user1.uid]),
                        });
                        await FirebaseFirestore.instance.collection("Users")
                            .doc(user1.uid)
                            .update({
                          "type": 'Organisation',
                          "source": widget.user.uid,
                          "admin": FieldValue.arrayUnion([widget.user.uid]),
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added'),
                          ),
                        );
                      }else{
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('The Employee is already added to a Company ! Please remove it first'),
                          ),
                        );
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
}


