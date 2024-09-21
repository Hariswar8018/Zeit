import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/google_map_check-in_out.dart';
import 'package:zeit/model/task_class.dart';
import 'package:zeit/provider/declare.dart';

import '../functions/task_health_events_training.dart';
import '../model/usermodel.dart';

class AddTask extends StatefulWidget {
   AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {

  void initState(){
    status.text = "Active" ;
    name.text="Ayushman";
  }
   TextEditingController name = TextEditingController();

   TextEditingController title = TextEditingController();

   TextEditingController desc = TextEditingController();
   TextEditingController status = TextEditingController();
  TextEditingController stday = TextEditingController();
  TextEditingController edday = TextEditingController();

  TextEditingController add = TextEditingController();
  TextEditingController cn = TextEditingController();
  TextEditingController ci = TextEditingController();
  TextEditingController category = TextEditingController();

  TextEditingController lat = TextEditingController();
  TextEditingController lon = TextEditingController();
  TextEditingController address = TextEditingController();

  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Task",style:TextStyle(color:Colors.white,fontSize: 23)),
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.hail_rounded, size: 30, color: Colors.blueAccent),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text("Project Details",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
              t("Task/Project Name"),
              a(title),
              t("Description of Task/Project"),
              ad(desc),
              _buildCalendarDialogButton(),
              t("Task Start Date"),
              aa(stday),
              t("Task End Date"),
              aa(edday),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.privacy_tip_outlined, size: 30, color: Colors.blueAccent),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text("Priority",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
              t("Priority"),
              Row(
                children: [
                  rt("Low"), rt("Moderate"),rt("High"),
                ],
              ),
              t("Status"),
              aa(status),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value!;
                      });
                    },
                  ),
                  Text(
                    'Is Task a type of Meeting in a Location?',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              _isChecked?(address.text.isEmpty? ListTile(
                tileColor: Colors.yellowAccent.shade100,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    PageTransition(
                      child: Google_F(lat: 56, lon: 55),
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 50),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    double? latt = result['lat'] as double?;
                    double? lont = result['lng'] as double?;
                    String? addresss = result['address'] as String?;

                    if (latt != null && lont != null && addresss != null) {
                      print("Latitude: $latt, Longitude: $lont, Address: $addresss");
                      setState(() {
                        lat.text = latt.toString();
                        lon.text = lont.toString();
                        address.text = addresss;
                      });
                    } else {
                      print("Some of the values are null");
                    }
                  } else {
                    print("Result is null or not a Map<String, dynamic>");
                  }
                },
                leading: Icon(Icons.location_history,color: Colors.red,),
                title: Text("Choose the Location"),
                subtitle: Text("Choose Location from map"),
                trailing: Icon(Icons.arrow_forward_outlined),
              ):Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  t("  Lat / Lon"),
                  aa(lat),
                  aa(lon),
                  t("  Address"),
                  aa(address),
                ],
              )):SizedBox(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(Icons.other_houses_sharp, size: 30, color: Colors.blueAccent),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Text("Other Details",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
              t("Client Name"),
              a(cn),
              t("Client ID"),
              a(ci),
              t("Category"),
              a(category),
              SizedBox(height: 20,),
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
              text: 'Next Add Employee',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                String g = DateTime.now().microsecondsSinceEpoch.toString();
                String ui = FirebaseAuth.instance.currentUser!.uid;
                Task h = Task(name: title.text, id: g, hrid: ui,
                    hrname: _user!.Name, comid: _user.source, followers: [],
                    benefit: [], description: desc.text,
                    startdate: stday.text, enddate: edday.text, priority: st,
                    status: status.text, pic: _user.pic, lat: _isChecked?double.parse(lat.text):0.0, lon: _isChecked? double.parse(lon.text):0.0,
                  assigndate: address.text, client_name: cn.text, client_id: ci.text, category: category.text,
                  invited: 0, complete: 0, progress: 0, Completed: [], Ignored: [], Pending: [], Incompleted: [],
                );
                try{
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user.source).collection("Tasks")
                      .doc(g).update(h.toJson());
                }catch(e){
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user.source).collection("Tasks")
                      .doc(g).set(h.toJson());
                }
                Navigator.push(
                    context,
                    PageTransition(
                        child: How(id: g, first4: 'TASK', topic:"A New Task added by ${_user.Name}",sdk:"Tasks",
                          message: 'A New Task is added by Admin by ${_user.Name} : ${title.text}', docname: 'Tasks',),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200)));
              }),
        ),
      ],
    );
  }
 String st = "Moderate" ;
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
  Widget ad(TextEditingController c){
    return Padding(
      padding: const EdgeInsets.only( bottom : 10.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.name,maxLines: 5,
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(), // No border
        ),
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
  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _singleDatePickerValueWithDefaultValue ,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                // Format the DateTime in the desired format (DD/MM/YYYY)
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  stday = TextEditingController(text: formattedDate);
                  DateTime? date1 = _singleDatePickerValueWithDefaultValue[1] ;
                  String dateTimeString1 = date1.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime1 = DateTime.parse(dateTimeString1);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(dateTime1);
                  edday = TextEditingController(text: formattedDate1);
                });
              }
            },
            child: const Text('Choose Range'),
          ),
        ],
      ),
    );
  }
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
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
