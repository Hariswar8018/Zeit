import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/add/add_request.dart';
import 'package:zeit/cards/request_C.dart';
import 'package:zeit/model/approval.dart';
import 'package:zeit/provider/declare.dart';
import 'package:zeit/services/attendance.dart';

import '../model/usermodel.dart';

class L1 extends StatefulWidget {
   L1({super.key});

  @override
  State<L1> createState() => _L1State();
}

class _L1State extends State<L1> {
  List j=[];
// Create the list with today's date and the date 4 days later

  List<DateTime?> _rangeDatePickerValueWithDefaultValue = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 4)),
  ];
TextEditingController cont = TextEditingController();
  String pic = " ", name = " ", classn = " ", sec = " ", cl = " ", rg = " ";
  Widget rt(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            cont.text = jh ;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: cont.text==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  cont.text == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }

  TextEditingController tty=TextEditingController();
  Widget rtj(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            tty.text = jh ;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: tty.text==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color :  tty.text == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Leave Applicants",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        body : SingleChildScrollView(
          child: Column (
            crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                Container(child: _buildDefaultRangeDatePickerWithValue()),
                Text("    Reason for Leave",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 21)),
                Row(
                  children: [
                   rt("Sick Leave"),  rt("Maternity Leave"),
                  ],
                ),
                Row(
                  children: [
                    rt("Casual Leave"),  rt("Sabbatical Leave"),
                  ],
                ),
                Row(
                  children: [
                    rt("Marriage Leave"),  rt("Compensatory Off"),
                  ],
                ),
                SizedBox(height: 8,),
                Text("    Type of Leave",style:TextStyle(fontWeight: FontWeight.w600,fontSize: 21)),
                Row(
                  children: [
                    rtj("Full Day Leave"),  rtj("Half Day Leave"),
                  ],
                ),
                a(cont),
              ]
          ),
        ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: SocialLoginButton(
              backgroundColor: Color(0xff50008e),
              height: 40,
              text: 'Apply for Leave',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async {
                j= _generateFormattedDatesInRange( _rangeDatePickerValueWithDefaultValue[0]!  ,
                    _rangeDatePickerValueWithDefaultValue[1]!);
                print(j);
                try{
                  _generate( _rangeDatePickerValueWithDefaultValue[0]!  ,
                      _rangeDatePickerValueWithDefaultValue[1]!, rg);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error puttind data in calender"),
                    ),
                  );
                }
                try{
                  String g = DateTime.now().millisecondsSinceEpoch.toString();
                  String ui = FirebaseAuth.instance.currentUser!.uid;
                  Request ty = Request(name: _user!.Name, designation: _user!.education,
                      joining: _user.uid, request: "Leave Application for ${tty.text}",
                      change: true, reason: cont.text, userid: ui,
                      id: g, topic: "Leave Application for ${tty.text}", queries: false,
                      description: "", attachment: "",
                      status: "Active", time: g, response: "",
                      pic: _user!.pic, date1: _rangeDatePickerValueWithDefaultValue[0].toString(),
                      date2: _rangeDatePickerValueWithDefaultValue[1].toString());
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Requests")
                      .doc(g).set(ty.toJson());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_user.Name + " is set as Leave on the Following Days Success !"),
                    ),
                  );
                  Navigator.pop(context);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error ! Either the Student is not from current session or have bad Registration ID"),
                    ),
                  );
                }

              }
          ),
        ),
      ],
    );
  }

  Widget a(TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0,left:10,right:10),
      child: TextFormField(
        controller: c, maxLines: 1,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          isDense: true,
          suffixText: "for ${uyj()} Days",
          border: OutlineInputBorder(), // No border
        ),
      ),
    );
  }

  int uyj(){
    try{
     Duration ko= _rangeDatePickerValueWithDefaultValue[1]!.difference(_rangeDatePickerValueWithDefaultValue[0]!);
     int t=ko.inDays;
     return t;
    }catch(e){
      return 1 ;
    }
    return 1;
  }

  void _generate(DateTime start, DateTime end, String reg) async {
    List<String> formattedDates = [];
    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);

      // Manually format the date without leading zeros
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate); // Add the formatted date to the list

      // Use the formatted date in Firestore
      String sj = DateTime.now().microsecondsSinceEpoch.toString();
      await FirebaseFirestore.instance.collection('School')
          .doc(reg)
          .collection("Colors")
          .doc(formattedDate)
          .set({
        'color': Colors.green.value,
        'date': currentDate, // Save the formatted date
        'st': formattedDate,
      });
    }
  }

  List<String> _generateFormattedDatesInRange(DateTime start, DateTime end) {
    List<String> formattedDates = [];

    for (int i = 0; i <= end.difference(start).inDays; i++) {
      DateTime currentDate = DateTime(start.year, start.month, start.day + i);
      String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
      formattedDates.add(formattedDate);
    }

    return formattedDates;
  }

  Widget _buildDefaultRangeDatePickerWithValue() {
    final config = CalendarDatePicker2Config(
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.teal[800],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        const Text('Range Date Picker (With default value)'),
        CalendarDatePicker2(
          config: config,
          value: _rangeDatePickerValueWithDefaultValue,
          onValueChanged: (dates) =>
              setState(() => _rangeDatePickerValueWithDefaultValue = dates),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Selection(s):  '),
            const SizedBox(width: 10),
            Text(
              _getValueText(
                config.calendarType,
                _rangeDatePickerValueWithDefaultValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values,) {
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
}


class Hr extends StatelessWidget {
  Hr({super.key,});
  List<Request> _list = [];
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Leave Application",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      floatingActionButton:InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child: L1(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child: Container(
          width: 130, height : 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.request_page,color :Colors.white),
                  Text(" Request Now", style : TextStyle(color : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company').doc(_user!.source).collection("Requests").where("topic", isEqualTo: "Leave Application").where("joining",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots() ,
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
                    "No Request Letter Found",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks like you haven't Requested any ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => Request.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return RequestC(user: _list[index], b: false);
            },
          );
        },
      ),
    );
  }
}

class Leave extends StatelessWidget {
  const Leave({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Leave Tracker"),
      ),
      body: Column(
          children:[
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Hr()),
                  );
                },
                child: a(Icon(Icons.remove_red_eye,color :  Colors.amber), "View", "Track your Leave Application")),
            InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Attendance(time: false,uid: FirebaseAuth.instance.currentUser!.uid),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 600)));
                },
                child: a(Icon(Icons.travel_explore_sharp,color :  Colors.blueGrey), "Holidays", "View all Holidays")),

          ]
      ),
    );
  }
  Widget a(Widget r, String str , String str1){
    return ListTile(
      leading: r,
      title: Text(str),
      subtitle: Text(str1),
      trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey, size: 15,),
    );
  }
}
