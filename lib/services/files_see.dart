import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/cards/task.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/notification/notify_all.dart';
import 'package:zeit/provider/declare.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as lk;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/add_task.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/task_class.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/provider/upload.dart';
import '../model/events.dart';
import 'dart:typed_data' as uk ;

class File_See extends StatelessWidget {
  String str;
   File_See({super.key,required this.str});
  List<FileModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("All Files",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(str).collection("Files")
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
                  Icon(Icons.hourglass_empty, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Files found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes you haven't shared Files",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              FileModel.fromJson(e.data())).toList() ?? []);
          return GridView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 5.0, // Space between columns
              mainAxisSpacing: 5.0, // Space between rows
            ),
            itemBuilder: (context, index) {
              return FileUser(user: _list[index]);
            },
          );
        },
      ),
    );
  }
}


class AddS extends StatefulWidget {
  String title; UserModel userr;
  AddS({super.key,required this.title,required this.userr});

  @override
  State<AddS> createState() => _AddSState();
}

class _AddSState extends State<AddS> {

  bool up=false;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Send Files to ${widget.userr.Name}",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text("Topic Name of ${st} ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              dcc(name,"","Please type topic of post",false),
              SizedBox(height: 10,),
              Text("Upload Type ?",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
              Row(
                children: [
                  rt("PDF"),
                  rt("Picture"),
                  rt("XML/DOC/DOCX"),
                  rt("Link"),
                ],
              ),
              SizedBox(height: 10,),
              st=="Link"?
              dcc(link,"Enter Link","Enter Link to file or Web",false):
              Center(
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      up=true;
                    });
                    if(st=="PDF"){
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Uploading your PDF'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          final storageRef = lk.FirebaseStorage.instance.ref();
                          final mountainsRef = storageRef.child("Task_${widget.title}_${name.text}.pdf"); // Change the filename as needed
                          await mountainsRef.putFile(file);
                          String downloadUrl = await mountainsRef.getDownloadURL();
                          setState(() {
                            link.text=downloadUrl;
                          });
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You cancelled PDF picking'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$e"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                    else if(st=="Picture"){
                      try {
                        uk.Uint8List? file = await pickImage(ImageSource.gallery);
                        if (file != null) {
                          String photoUrl = await StorageMethods().uploadImageToStorage(
                              'Company_Task', file, true);
                          setState(() {
                            link.text=photoUrl;
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
                    }
                    else{
                      try {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Uploading your PDF'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          final storageRef = lk.FirebaseStorage.instance.ref();
                          final mountainsRef = storageRef.child("Task_${widget.title}_${name.text}.pdf"); // Change the filename as needed
                          await mountainsRef.putFile(file);
                          String downloadUrl = await mountainsRef.getDownloadURL();
                          setState(() {
                            link.text=downloadUrl;
                          });
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('You cancelled PDF picking'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$e"),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                    setState(() {
                      up=false;
                    });
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    child: up?CircularProgressIndicator():as(),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              st=="Link"? SizedBox(): Center(child: Text("Click on above Button to Browse Files")),
              SizedBox(height: 15,),
              link.text.isEmpty?SizedBox():Padding(
                padding: const EdgeInsets.only(left: 9.0, right: 9),
                child: SocialLoginButton(
                    backgroundColor: Colors.blue,
                    height: 40,
                    text: 'Send Attachment',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async {
                      String d=DateTime.now().microsecondsSinceEpoch.toString();
                      FileModel u =FileModel(name:_user!.Name, pic: _user.pic, id: d,
                          topic: name.text, pdf: st=="PDF"?true:false,
                          outside: st=="Picture"?false:true, link: link.text
                      );
                      await  FirebaseFirestore.instance
                          .collection('Users')
                          .doc(widget.userr.uid).collection("Files").doc(d)
                          .set(u.toJson());
                      ahs("A New Attachment is waiting for you : ${name.text}");
                      Navigator.pop(context);

                    }),
              ),
            ],
          ),
        )
    );
  }
  void ahs(String desc){
    try {
      UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
      NotifyAll.sendNotification(
          "New Attachment by " + _user!.Name, desc,widget.userr.token);
    }catch(e){
      print(e);
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

  Widget as(){
    if(st=="PDF"){
      return Icon(Icons.picture_as_pdf,size: 50,);
    }else if(st=="Picture"){
      return Icon(Icons.photo,size: 50,);
    }else{
      return Icon(Icons.upload_file_rounded,size: 50,);
    }
  }
  TextEditingController link = TextEditingController();
  TextEditingController name = TextEditingController();
  String st="PDF";
  Widget dcc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 1,
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
        onChanged: (value){
          setState(() {

          });
        },
      ),
    );
  }
  Widget rt(String jh){
    return InkWell(
        onTap : () async {
          setState(() {
            st=jh;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
}
