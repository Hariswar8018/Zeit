
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeit/model/hospital.dart';
import 'package:zeit/model/training.dart';
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
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/model/task_class.dart';
import 'package:zeit/provider/declare.dart';
import 'package:image_picker/image_picker.dart';
import '../functions/task_health_events_training.dart';

class AddH extends StatefulWidget {
  AddH({super.key});

  @override
  State<AddH> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddH> {

  void initState(){

  }
 final String g = DateTime.now().microsecondsSinceEpoch.toString();
  final TextEditingController picController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController feedbackLinkController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController termController = TextEditingController();

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  String pic="https://www.learnworlds.com/app/uploads/2021/03/employees-working-with-laptops.webp";
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Health Information",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(pic),fit: BoxFit.cover,
                      )
                  ),
                ),
                Container(
                  height: 200,width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: TextButton.icon(onPressed: () async {
                                try {
                                  lk.Uint8List? file = await pickImage(ImageSource.gallery);
                                  if (file != null) {
                                    String photoUrl = await StorageMethods().uploadImageToStorage(
                                        'Company', file, true);
        
                                    setState(() {
                                      pic=photoUrl;
                                    });
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Pic Uploaded"),
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
                              }, label: Text("Upload Pic"),icon:Icon(Icons.upload)),
                            )),
                      ),
                      SizedBox(height:8)
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  rt("Insurance",),
                  rt("Retirment",),
                  rt("Life Plan",),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Row(
                children: [
                  rt("Health Service",),
                  rt("Other",),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.work_history, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Insurance Company",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(companyController, 'Insurance Company', 'Enter Company', false),
            dc(emailController, 'Email', 'Enter Email', false),
            dc(linkController, 'Link', 'Enter Link', false),
            dc(phoneController, 'Phone', 'Enter Phone', true),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.info, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("About Insurance",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(nameController, 'Name', 'Enter Name', false),
            dc(locationController, 'Location', 'Enter Location', false),
            dc(feedbackLinkController, 'Feedback Link ( Optional )', 'Enter Feedback Link', false),
            oc(descController, 'Description', 'Enter Description', false),
            dc(termController, 'Term Length ( Additional Info )', 'Enter Term', false),
          ],
        ),
      ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SocialLoginButton(
                backgroundColor: Colors.blue,
                height: 40,
                text: 'Next Add Employee',
                borderRadius: 20,
                fontSize: 21,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () async{
                  String ui = FirebaseAuth.instance.currentUser!.uid;
                 Hospital h=Hospital(pic: pic, type:st, company: companyController.text,
                     name: nameController.text, email: emailController.text, link: linkController.text, phone: phoneController.text,
                     location: locationController.text, feedbackLink: feedbackLinkController.text,
                     rating: 5, desc: descController.text, attendance: [], id: g);
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Health")
                      .doc(g).set(h.toJson());
                  Navigator.push(
                      context,
                      PageTransition(
                          child: How(id: g, first4: 'HEAL', topic:"A New Health Service added by ${_user.Name}",sdk:"Health",
                            message: 'A New Health is added by ${_user.Name} : ${companyController.text}', docname: 'Health',),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 200)));
                }),
          ),
        ]
    );
  }
  String st = "Insurance" ;
  Widget rt(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            st = jh ;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
  Widget dc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
  Widget oc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 4,maxLines: 9,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type It';
          }
          return null;
        },
      ),
    );
  }
  Widget a(TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(), // No border
        ),
      ),
    );
  }

  Widget aa(TextEditingController c,){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,enabled: false,
          border: OutlineInputBorder(), // No border
        ),
      ),
    );
  }

  Widget t(String str){
    return Text(str,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
  }
}
