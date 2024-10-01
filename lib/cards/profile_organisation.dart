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
import 'package:zeitt/cards/usercards.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/functions/google_map_check-in_out.dart';
import 'package:zeitt/functions/search.dart';
import 'package:zeitt/model/feeds.dart';
import 'package:zeitt/notification/notify_all.dart';
import 'package:zeitt/provider/declare.dart';
import 'package:zeitt/superadmin/addemployee.dart';
import 'package:zeitt/update/update_user.dart';
import '../model/usermodel.dart';
import '../model/organisation.dart';
import 'FeedsU.dart';
import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeitt/main.dart';
import 'package:zeitt/main_pages/navigation.dart';
import 'package:zeitt/model/organisation.dart';
import 'package:zeitt/model/usermodel.dart'  ;
import 'package:zeitt/provider/upload.dart';
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
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    return ishr(_user!);
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  bool ishr(UserModel user){
    if(user.type=="Individual"){
      return false;
    }else{
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    double ww =  MediaQuery.of(context).size.width ;
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
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
                            await FirebaseFirestore.instance.collection("Company").doc(widget.user.id).update({
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
                                      child: Update(Name: 'Small Description', doc: widget.user.id, Firebasevalue: 'desc', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
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
                      child: Update(Name: "Phone", doc: widget.user.id, Firebasevalue: 'phone', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
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
                      child: Update(Name: 'Email', doc: widget.user.id, Firebasevalue: 'email', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
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
                  itemCount: 5,scrollDirection: Axis.horizontal,
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
      return r2(true,"Individual");
    }else if( active == 2){
      return r2(false,"Organisation");
    }else if( active == 3){
      return r2(false,"Director");
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
        r( Icon(Icons.important_devices, color : Colors.green),"Company Id : " + widget.user.id),
        Row(
          children: [
            r( Icon(Icons.money, color : Colors.orange),"Pan Card : " + widget.user.pan),
            myuser()?IconButton(icon:Icon(Icons.edit,size: 23,color: Colors.green,),onPressed:(){
              Navigator.push(
                  context, PageTransition(
                  child: Update(Name: 'Pan Card', doc: widget.user.id, Firebasevalue: 'pan', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
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
                  child: Update(Name: 'Tan Card', doc: widget.user.id, Firebasevalue: 'tan', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
              ));
            }):SizedBox(),
          ],
        ),

      ]
    );
  }

  Widget r2(bool b,String find ){
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    List<UserModel> _list = [];
    return Column(
      children: [
        ishr(_user!)?Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: Addemployee(user: widget.user,name:b?"Employee":(find=="Director"?"Director":"Organisation"),type: find,),
                      type: PageTransitionType.leftToRight,
                      duration: Duration(milliseconds:40)));
            },
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
                  CircleAvatar(
                    radius: 15,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.add,size: 20,)),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
        ):SizedBox(),
        Container(
          width: MediaQuery.of(context).size.width,
            height:600,
            child:  StreamBuilder(
          stream:  FirebaseFirestore.instance
              .collection('Users').where("source",isEqualTo: widget.user.id).where("type",isEqualTo: find)
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
                    Text(
                      "No Peers found",
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
      return "HR";
    }else if ( i == 3){
      return "Director";
    }else if ( i == 4){
      return "About";
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
}


