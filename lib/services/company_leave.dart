
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/flush.dart';

import 'package:zeit/model/time.dart';
import 'dart:async';

import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class Holidays extends StatefulWidget {
  String uid;
  Holidays({super.key,required this.uid});

  @override
  State<Holidays> createState() => _HolidaysState();
}

class _HolidaysState extends State<Holidays> {
  int pre = 0 , abs = 0 , nt = 0;

  Future<List<Date>> fetchDataFromFirestore() async {
    List<Date> firestoreDates = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Company")
        .doc(widget.uid)
        .collection("Holidays")
        .get();
    querySnapshot.docs.forEach((doc) {
      print(doc);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(doc['millisecondstos']));
      firestoreDates.add(Date(
        date: date,
        color: Color(doc['color']), // Use Color directly, no need to parse as int
      ));
    });
    return firestoreDates;
  }

  late Timer _timer;
  double averageDuration1=0.0;
  @override
  void dispose() {
    // Dispose the timer when the screen is disposed
    _stopTimer();
    super.dispose();
  }
  int sumAll = 0;
  double averageDuration = 0.0;

  int daysc = 0;
  int i = 0;
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Code to execute every 5 seconds
      fetchDataFromFirestore().then((firestoreDates) {
        setState(() {
          dates = firestoreDates;
        });
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  late final List<Date> dates   ;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore().then((firestoreDates) {
      setState(() {
        dates = firestoreDates;
      });
    });
  }

  String local = 'en';
  List<TimeModel> _list = [];

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Company Holidays",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              CustomCalendarViewer(
                local: local,
                dates: dates,
                ranges: ranges ,
                calendarType: CustomCalendarType.view ,
                calendarStyle: CustomCalendarStyle.normal ,
                animateDirection: CustomCalendarAnimatedDirection.vertical ,
                movingArrowSize: 29 ,
                spaceBetweenMovingArrow: 20 ,
                closeDateBefore: DateTime.now().subtract(Duration(days: 405)),
                closedDatesColor: Colors.grey.withOpacity(0.7),
                showBorderAfterDayHeader: false,
                showTooltip: false,
                toolTipMessage: '',
                //headerAlignment: MainAxisAlignment.center,
                calendarStartDay: CustomCalendarStartDay.sunday,
                onCalendarUpdate: (date) {
                  // Handel your code here.
                  print('onCalendarUpdate');
                  print(date);
                },
                //showCurrentDayBorder: false,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 4),
                child: TextFormField(
                  controller: cv,
                  decoration: InputDecoration(
                    isDense: true,hintText: "Reason for Holiday",
                    border: OutlineInputBorder(),
                    suffixText: " ${uyj()} days"
                  ),
                ),
              ),
              SizedBox(height: 3,),
              _buildCalendarDialogButton(),
              InkWell(
                onTap: () async {
                  try {
                    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
                        .collection('Users')
                        .where('source', isEqualTo: _user!.source)
                        .get();
                    for (var doc in usersSnapshot.docs) {
                      var data = doc.data() as Map<String, dynamic>;
                      var usser = UserModel.fromJson(data);
                      print(usser.toJson());

                      try {
                        DateTime end = _singleDatePickerValueWithDefaultValue[1]!;
                        DateTime start = _singleDatePickerValueWithDefaultValue[0]!;
                        for (int i = 0; i <= end.difference(start).inDays; i++) {
                          print(i);
                          try {
                            DateTime currentDate = DateTime(start.year, start.month, start.day + i);
                            String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
                            print(formattedDate);
                            String st = currentDate.millisecondsSinceEpoch.toString();
                            String su = currentDate.toString();
                            print(usser.Name+"---------------------------------------->");
                            print(st);
                            print(su);
                            TimeModel uio = TimeModel(
                              time: formattedDate,
                              date: "${currentDate.day}",
                              month: "${currentDate.month}",
                              year: "${currentDate.year}",
                              duration: 0,
                              x: 9,
                              lastupdate: su,
                              started: true,
                              millisecondstos: st,
                              startaddress: 'HOLIDAY',
                              endaddress: "${cv.text}",
                              stlan: 0.00,
                              stlon: 0.2,
                              endlan: 0.0,
                              endlong: 0.0,
                              color: Colors.yellow.value,
                            );
                            try{
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc(usser.uid)
                                  .collection("Attendance")
                                  .doc(formattedDate)
                                  .set(uio.toJson(), SetOptions(merge: true)); //
                              //ng data
                              print(uio.toJson());
                            }catch(e){
                              Send.message(context, "$e", false);
                            }

                          } catch (e) {
                            Send.message(context, "$e", false);
                            print("Error storing attendance: $e");
                          }
                        }
                        Send.message(context, "Success! Added for ${usser.Name}", true);
                      } catch (e) {
                        Send.message(context, "$e", false);
                      }
                    }
                  } catch (e) {
                    print(e);
                    Send.message(context, "Error fetching users: $e", false);
                  }
                  try {
                    DateTime end = _singleDatePickerValueWithDefaultValue[1]!;
                    DateTime start = _singleDatePickerValueWithDefaultValue[0]!;
                    for (int i = 0; i <= end.difference(start).inDays; i++) {
                      print(i);
                      try {
                        DateTime currentDate = DateTime(start.year, start.month, start.day + i);
                        String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
                        print(formattedDate);
                        String st = currentDate.millisecondsSinceEpoch.toString();
                        String su = currentDate.toString();
                        print(st);
                        print(su);
                        TimeModel uio = TimeModel(
                          time: formattedDate,
                          date: "${currentDate.day}",
                          month: "${currentDate.month}",
                          year: "${currentDate.year}",
                          duration: 0,
                          x: 9,
                          lastupdate: su,
                          started: true,
                          millisecondstos: st,
                          startaddress: '',
                          endaddress: '',
                          stlan: 0.00,
                          stlon: 0.2,
                          endlan: 0.0,
                          endlong: 0.0,
                          color: Colors.yellow.value,
                        );
                        try{
                          await FirebaseFirestore.instance.collection("Company")
                              .doc(widget.uid)
                              .collection("Holidays")
                              .doc(formattedDate)
                              .set(uio.toJson(), SetOptions(merge: true)); //
                          //ng data
                          print(uio.toJson());
                        }catch(e){
                          Send.message(context, "$e", false);
                        }

                      } catch (e) {
                        Send.message(context, "$e", false);
                        print("Error storing attendance: $e");
                      }
                    }
                    Send.message(context, "Success! Added for Company too", true);
                  } catch (e) {
                    Send.message(context, "$e", false);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, top: 7),
                  child: Container(
                    width: 400,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("Add Holiday Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              _buildCalendarDialogButtonn(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("Company")
                    .doc(widget.uid)
                    .collection("Holidays")
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
                              "No Events found",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Looks likes Company haven't any Events",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    }
                    final data = snapshot.data?.docs;
                    _list.clear();
                    data?.forEach((doc) {
                      DateTime dateTime = DateTime.parse(doc['lastupdate']);
                      if (dateTime.isAfter(_singleDatePickerValueWithDefaultValue[0]!) && dateTime.isBefore(_singleDatePickerValueWithDefaultValue[1]!)) {
                        _list.add(TimeModel.fromJson(doc.data()));
                        print(_list);
                      }
                    });

                    return ListView.builder(
                      itemCount: _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AttenUser(user: _list[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().subtract(Duration(days: 4)),
    DateTime.now().add(Duration(days: 3)),
  ];

  _buildCalendarDialogButtonn() {
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
    return InkWell(
      onTap: () async {
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
            String dateTimeString = date.toString();

            // Convert DateTime string to DateTime
            DateTime dateTime = DateTime.parse(dateTimeString);

            // Format the DateTime in the desired format (DD/MM/YYYY)
            String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

            setState((){

            });
          });
        }
      },
      child:  Padding(
        padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
        child: Container(
          height: 50,width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),color: Colors.white
          ),
          child: Row(
            children: [
              SizedBox(width: 9,),
              InkWell(
                  onTap: (){
                    setState(() {
                      _singleDatePickerValueWithDefaultValue[0]= _singleDatePickerValueWithDefaultValue[0]!.subtract(Duration(days: 7));
                      _singleDatePickerValueWithDefaultValue[1]= _singleDatePickerValueWithDefaultValue[1]!.subtract(Duration(days: 7));
                         });

                  },
                  child: Icon(Icons.arrow_back)),
              SizedBox(width: 4,),
              Text(s1(_singleDatePickerValueWithDefaultValue[0]!)),
              Spacer(),
              Text(s1(_singleDatePickerValueWithDefaultValue[1]!)),
              SizedBox(width: 4,),
              InkWell(
                  onTap: (){
                    setState(() {
                      _singleDatePickerValueWithDefaultValue[0]=  _singleDatePickerValueWithDefaultValue[0]!.add(Duration(days: 7));
                      _singleDatePickerValueWithDefaultValue[1]=_singleDatePickerValueWithDefaultValue[1]!.add(Duration(days: 7));
                       });
                  },
                  child: Icon(Icons.arrow_forward)),
              SizedBox(width: 9,),
            ],
          ),
        ),
      ),
    );
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
  int uyj(){
    try{
      Duration ko= _singleDatePickerValueWithDefaultValue[1]!.difference(_singleDatePickerValueWithDefaultValue[0]!);
      int t=ko.inDays;
      return t;
    }catch(e){
      return 1 ;
    }
    return 1;
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

  TextEditingController cv=TextEditingController();
  String formatElapsedTime(int elapsedTime) {
    int elapsedSeconds = elapsedTime.toInt();
    if (elapsedSeconds < 60) {
      return "$elapsedSeconds sec";
    } else if (elapsedSeconds < 3600) {
      int minutes = elapsedSeconds ~/ 60;
      int seconds = elapsedSeconds % 60;
      return seconds > 0 ? "$minutes min" : "$minutes min";
    } else if (elapsedSeconds < 72000) {
      int hours = elapsedSeconds ~/ 3600;
      int minutes = (elapsedSeconds % 3600) ~/ 60;
      return minutes > 0 ? "$hours hr, $minutes min" : "$hours hr";
    } else {
      return "20+ hr";
    }
  }

  Widget io(String h, int h2, bool fneeded){
    late String de;
    if(fneeded){
      de=formatElapsedTime(h2);
    }else{
      de=h2.toString()+ " Days";
    }
    return Padding(
      padding: const EdgeInsets.only(bottom:9.0,left:15,right:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$h : "),
          Text(de),
        ],
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
    return InkWell(
      onTap: () async {
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
            String dateTimeString = date.toString();

            // Convert DateTime string to DateTime
            DateTime dateTime = DateTime.parse(dateTimeString);

            // Format the DateTime in the desired format (DD/MM/YYYY)
            String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

            setState((){

               });
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8),
        child: Container(
          width: 400,
          height: 40,
         decoration: BoxDecoration(
           color: Colors.blue,
           borderRadius: BorderRadius.circular(10),
         ),
          child: Center(child: Text("Add Holiday Range",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
        )
      ),
    );
  }

  String s1(DateTime dateTime){
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return formattedDate;
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
}


class AttenUser extends StatelessWidget {
  TimeModel user;
  AttenUser({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0,right:15,bottom:5),
      child: InkWell(
        onTap: (){

        },
        child: user.color==4294961979?Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey,
                    width: 0.3
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("LEAVE",style:TextStyle(color:Colors.orangeAccent,fontWeight: FontWeight.w900,fontSize: 18)),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Text(user.time, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),)),
                        Spacer(),
                        Text( "Enjoy  🥳😎👌🤗",style:TextStyle(color:Colors.blue,fontWeight: FontWeight.w600,fontSize: 14)),
                        SizedBox(width:10),
                      ],
                    ),
                  ),
                ],
              ),
            )):
        Container(
            width: MediaQuery.of(context).size.width-20,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.grey,
                    width: 0.3
                )
            ),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("PRESENT",style:TextStyle(color:Colors.green,fontWeight: FontWeight.w900,fontSize: 18)),
                  Container(
                    width: MediaQuery.of(context).size.width-40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Text(user.time, style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18),)),
                        Spacer(),
                        Text( formatElapsedTime( user.duration),style:TextStyle(color:Colors.red,fontWeight: FontWeight.w600,fontSize: 14)),
                        SizedBox(width:10),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
  String formatElapsedTime(int elapsedTime) {
    int elapsedSeconds = elapsedTime.toInt();
    if (elapsedSeconds < 60) {
      return "$elapsedSeconds sec";
    } else if (elapsedSeconds < 3600) {
      int minutes = elapsedSeconds ~/ 60;
      int seconds = elapsedSeconds % 60;
      return seconds > 0 ? "$minutes min" : "$minutes min";
    } else if (elapsedSeconds < 72000) {
      int hours = elapsedSeconds ~/ 3600;
      int minutes = (elapsedSeconds % 3600) ~/ 60;
      return minutes > 0 ? "$hours hr, $minutes min" : "$hours hr";
    } else {
      return "20+ hr";
    }
  }

}