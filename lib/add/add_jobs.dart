import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/model/job.dart';
import 'package:zeit/model/usermodel.dart';

import '../model/organisation.dart';
import '../provider/declare.dart';


class AddJ extends StatefulWidget {
  AddJ({super.key,required this.user,required this.job,required this.change});
  OrganisationModel user;
  Job job;bool change;
  @override
  State<AddJ> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddJ> {
List benefit = [];
  void initState(){

    if(widget.change){
      stt=widget.job.jem;
      st=widget.job.jtype;
      pop=widget.job.shift;
      pop1=widget.job.work1;
      name.text=widget.job.name;
      address.text=widget.job.address;
      desc.text=widget.job.description;
      respon.text=widget.job.respon;
      key.text=widget.job.key;
      about.text=widget.job.about;
      exp.text=widget.job.experience;
      qua.text=widget.job.qualification;
      pay.text=widget.job.payment.toString();
      address2.text=widget.job.Intaddress;
      phone.text=widget.job.phone;
      mail.text=widget.job.mail;
      time.text=widget.job.time2;
      note.text=widget.job.note;
      link.text=widget.job.link;
      meet=widget.job.meet;
      lat=widget.job.lat;
      lon=widget.job.lon;
      benefit=widget.job.benefit;
    }
  }
  TextEditingController address = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController key = TextEditingController();
 String stt= " ";
  TextEditingController desc = TextEditingController();
  TextEditingController about = TextEditingController();
  TextEditingController exp = TextEditingController();
  TextEditingController qua= TextEditingController();
  TextEditingController respon= TextEditingController();
TextEditingController pay= TextEditingController();

TextEditingController address2= TextEditingController();
TextEditingController phone= TextEditingController();
TextEditingController mail= TextEditingController();

TextEditingController time= TextEditingController();
TextEditingController note= TextEditingController();
TextEditingController link= TextEditingController();
bool meet=false;double lat=0.0,lon=0.0;
  @override
  Widget build(BuildContext context){
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Jobs",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              t("Job Name"),
              a(name),
              t("Address of the Position"),
              z(address),
              t("Description of the Job"),
              z(desc),
              t("Monthly Payment"),
              ai(pay),
              t("Key Characteristics "),
              z(key),
              Row(
                children: [
                  rt("Part Time"), rt("Full Time"),rt("Freelancing"),
                ],
              ),
              SizedBox(height:10),
              t("Job Span"),
              Row(
                children: [
                  rtt("Permanent"), rtt("Temporary"),rtt("To be decided"),
                ],
              ),
              SizedBox(height:10),
              t("Shitfs"),
              Row(
                children: [
                  p("Morning Shift"),p("Night Shift"),p("Weekends"),
                ],
              ),
              SizedBox(height:10),
              t("Work Mode"),
              Row(
                children: [
                  p1("In Person"),p1("Hybrid"),p1("Online"),
                ],
              ),
              SizedBox(height:15),
              t("Experience needed ?"),
              a(exp),
              t("Qualification Needed"),
              z(qua),
              t("Job type"),
              t("About the Company"),
              z(about),
              t("Job Benefits"),
              Row(
                children: [
                  l("Joining Bonus"), l("Health Insurance"),
                ],
              ),
              Row(
                children: [
                  l("Yealy Bonus"), l("Holiday Bonus"),
                ],
              ),
              Row(
                children: [
                  l("Transport Cover"), l("Travel hikes"),
                ],
              ),
              Row(
                children: [
                  l("Paid Time Off"), l("Paid Sick Time"),
                ],
              ),
              Row(
                children: [
                  l("Cell Phone Reimbursement"),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.meeting_room, size: 30, color: Colors.blueAccent),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text("Interview Details",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
              t("Address to Report"),
              a(address2),
              t("Time to Report"),
              a(time),
              t("Phone for Contact"),
              ai(phone),
              t("Mail for Contact"),
              a(mail),
              t("Note if any"),
              z(note),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Recruitment Now',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                String gl = DateTime.now().millisecondsSinceEpoch.toString();
                String ui = FirebaseAuth.instance.currentUser!.uid;
                if(widget.change){
                  Job g = Job(name: name.text, comn: widget.job.comn, comi: widget.job.comi,
                    rating: 5.0, address: address.text,
                    type: widget.job.type, description: desc.text, respon: respon.text,
                    key: key.text, about: about.text, experience: exp.text,
                    qualification: qua.text, follower: widget.job.follower,follower1: widget.job.follower1,
                    saved:widget.job.saved, benefit:benefit, hrname: widget.job.hrname,
                    hrid: widget.job.hrid, comlogo: widget.job.comlogo, hrlogo: widget.job.hrlogo,
                    status: true, time: widget.job.time, jem: stt, jtype: st, shift: pop, work1:pop1, payment: int.parse(pay.text),
                    Intaddress: address2.text, lat: lat, phone: phone.text, lon: lon, mail: mail.text, note: note.text, link: link.text, meet: meet, time2: time.text,
                  );
                  await  FirebaseFirestore.instance.collection("Jobs").doc(widget.job.time).update(g.toJson());
                  Navigator.pop(context);
                }else{
                  Job g = Job(name: name.text, comn: widget.user.name, comi: widget.user.id,
                    rating: 5.0, address: address.text,
                    type: [], description: desc.text, respon: respon.text,
                    key: key.text, about: about.text, experience: exp.text,
                    qualification: qua.text, follower: [],follower1: [],
                    saved:[], benefit:benefit, hrname: _user!.Name,
                    hrid: _user.uid, comlogo: widget.user.logo, hrlogo: _user.pic,
                    status: true, time: gl, jem: stt, jtype: st, shift: pop, work1: pop1, payment: int.parse(pay.text),
                    Intaddress: address2.text, lat: lat, phone: phone.text, lon: lon, mail: mail.text, note: note.text, link: link.text, meet: meet, time2: time.text,
                  );
                  await  FirebaseFirestore.instance.collection("Jobs")
                      .doc(gl).set(g.toJson());
                  Navigator.pop(context);
                }
              }),
        ),
      ],
    );
  }
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
  String st = "Moderate" ;
  Widget l(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            if( benefit.contains(jh)){
              benefit.remove(jh);
            }else{
              benefit = benefit + [jh] ;
            }
          });

        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: benefit.contains(jh) ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  benefit.contains(jh) ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
  Widget rtt(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            stt = jh ;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: stt==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  stt == jh ? Colors.white : Colors.black )),
          )
      ),
    )
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
Widget ai(TextEditingController c){
  return Padding(
    padding: const EdgeInsets.only( bottom : 10.0),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        border: OutlineInputBorder(), // No border
      ),
    ),
  );
}
Widget z(TextEditingController c){
  return Padding(
    padding: const EdgeInsets.only( bottom : 10.0),
    child: TextFormField(
      controller: c,maxLines: 4,
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
  String pop="Morning Shift",pop1="In Person";
Widget p(String jh){
  return InkWell(
      onTap : (){
        setState(() {
          pop = jh ;
        });
      }, child : Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        decoration: BoxDecoration(
          color: pop==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(jh, style : TextStyle(fontSize: 19, color :  pop == jh ? Colors.white : Colors.black )),
        )
    ),
  )
  );
}
Widget p1(String jh){
  return InkWell(
      onTap : (){
        setState(() {
          pop1 = jh ;
        });
      }, child : Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
        decoration: BoxDecoration(
          color: pop1==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(jh, style : TextStyle(fontSize: 19, color :  pop1 == jh ? Colors.white : Colors.black )),
        )
    ),
  )
  );
}



  String _getValueText(
      CalendarDatePicker2Type datePickerType,
      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }

  Widget t(String str){
    return Text(str,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500));
  }
}
