
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:zeit/model/time.dart';
import 'dart:async';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  final bool time;
  final String uid;

  Attendance({super.key, required this.time, required this.uid});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  late List<Date> dates ; // Initialize dates here
  int pre = 0, abs = 0, nt = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore().then((firestoreDates) {
      setState(() {
        dates = firestoreDates;
      });
    });
    calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
  }

  Future<List<Date>> fetchDataFromFirestore() async {
    List<Date> firestoreDates = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.uid)
          .collection("Attendance")
          .get();

      for (var doc in querySnapshot.docs) {
        // Cast doc.data() to Map<String, dynamic>
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print(data); // Check the data being fetched

        // Check for the necessary fields
        if (data.containsKey('millisecondstos') && data.containsKey('color')) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(data['millisecondstos']));
          firestoreDates.add(Date(
            date: date,
            color: Color(data['color']),
          ));
        } else {
          print("Missing fields in document: ${doc.id}");
        }
      }

      // Update the state with fetched data
      setState(() {
        dates = firestoreDates;
      });

    } catch (e) {
      print("Error fetching attendance data: $e");
    }

    print(firestoreDates);
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


  void calculateDurationSumAndAverageForMonth(DateTime d1) async {
    int totalDurationd = 0;

    // Get the first and last days of the month for d1
    DateTime firstDayOfMonth = DateTime(d1.year, d1.month, 1);
    DateTime lastDayOfMonth = DateTime(d1.year, d1.month + 1, 0);

    // Number of days in the month
    int daysInMonth = lastDayOfMonth.difference(firstDayOfMonth).inDays + 1;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .collection("Attendance")
          .get();

      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Parse the datetime field
          DateTime docDateTime = DateTime.parse(data['datetime']);

          // Check if the document date is within the specified month
          if (docDateTime.isAfter(firstDayOfMonth.subtract(Duration(days: 1))) && docDateTime.isBefore(lastDayOfMonth.add(Duration(days: 1)))) {
            // Check if the document contains the 'duration' field
            if (data.containsKey('duration')) {
              dynamic durationValue = data['duration'];
              if (durationValue is int) {
                totalDurationd += durationValue;
              } else if (durationValue is double) {
                totalDurationd += durationValue.toInt();
              }
            }
          }
        }
      });

      // Calculate the average duration per day
      double averaged = totalDurationd / daysInMonth;

      setState(() {
        averageDuration1 = averaged;
      });

      print("Total duration for the month: $totalDurationd");
      print("Average duration per day for the month: $average");
    } catch (error) {
      print("Error calculating duration: $error");
    }
  }
  void calculateDurationSumAndAverage(DateTime d1, DateTime d2) async {
    int totalDuration = 0;
    int daysDifference = d2
        .difference(d1)
        .inDays + 1; // to include both start and end days
if(widget.time){
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.uid)
          .collection("Attendance")
          .get();

      querySnapshot.docs.forEach((doc) {
        // Check if the document data is not null and is of type Map<String, dynamic>
        if (doc.data() != null && doc.data() is Map<String, dynamic>) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Parse the datetime field
          DateTime docDateTime = DateTime.parse(data['lastupdate']);
          // Check if the document date is within the specified range
          if (docDateTime.isAfter(d1.subtract(Duration(days: 1))) &&
              docDateTime.isBefore(d2.add(Duration(days: 1)))) {
            // Check if the document contains the 'duration' field
            if (data.containsKey('duration')) {
              dynamic durationValue = data['duration'];
              if (durationValue is int) {
                totalDuration += durationValue;
              } else if (durationValue is double) {
                totalDuration += durationValue.toInt();
              }
            }
          }
        }
      });

      // Calculate the average duration per day
      double average = totalDuration / daysDifference;

      setState(() {
        sumAll = totalDuration;
        averageDuration = average;
        daysc = daysDifference;
      });
      calculateDurationSumAndAverageForMonth(d1);
      print("Total duration: $totalDuration");
      print("Average duration per day: $average");
    } catch (error) {
      print("Error calculating duration: $error");
    }
  }
  }
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





  String local = 'en';
  List<TimeModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text(widget.time?"My Time Tracker":"My Attendance",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Column(
            children: [
              CustomCalendarViewer(
                local: local,
                dates: dates,
                ranges: ranges ,
                calendarType: CustomCalendarType.range ,
                calendarStyle: CustomCalendarStyle.normal ,
                animateDirection: CustomCalendarAnimatedDirection.vertical ,
                movingArrowSize: 29 ,
                spaceBetweenMovingArrow: 20 ,
                closeDateBefore: DateTime.now().subtract(Duration(days: 405)),
                closedDatesColor: Colors.grey.withOpacity(0.7),
                //showHeader: false ,
                showBorderAfterDayHeader: true,
                showTooltip: true,
                toolTipMessage: '',
                //headerAlignment: MainAxisAlignment.center,
                calendarStartDay: CustomCalendarStartDay.monday,
                onCalendarUpdate: (date) {
                  // Handel your code here.
                  print('onCalendarUpdate');
                  print(date);
                },
                onDatesUpdated: (newDates) {
                  print('onDatesUpdated');
                  print(newDates.length);
                },
                onRangesUpdated: (newRanges) {
                  print('onRangesUpdated');
                  print(newRanges.length);
                },
                //showCurrentDayBorder: false,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Divider(),
              ),
             _buildCalendarDialogButton(),
              widget.time? Padding(
                padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
                child: Container(
                  height: 180,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                      ),color: Colors.white
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 9,),
                      Padding(
                        padding: const EdgeInsets.only(left:14.0),
                        child: Icon(Icons.timer_rounded,color:Colors.blue),
                      ),
                      io("Total Days",daysc,false),
                      io("Your Total Time",sumAll,true),
                      io("Your Average Time", averageDuration.toInt(),true),
                      SizedBox(height: 9,),
                      Padding(
                        padding: const EdgeInsets.only(left:14.0),
                        child: Icon(Icons.timeline_sharp,color:Colors.red),
                      ),
                      io("This Month Average", averageDuration1.toInt(),true),
                      SizedBox(width: 9,),
                    ],
                  ),
                ),
              ):
              Expanded(
                child:StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(widget.uid).collection("Attendance")
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
              )
            ],
          ),
        ),
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
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().subtract(Duration(days: 4)),
    DateTime.now().add(Duration(days: 3)),
  ];

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
              calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
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
                      calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
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
                      calculateDurationSumAndAverage(_singleDatePickerValueWithDefaultValue[0]!, _singleDatePickerValueWithDefaultValue[1]!);
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
      child: user.startaddress=="HOLIDAY"?
      InkWell(
        onTap: (){

          // Step 1: Convert DateTime to formatted string
          String formattedDate = '${user.date}-${user.month}-${user.year}';

          // Step 2: Convert string back to DateTime
          DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          DateTime parsedDate = dateFormat.parse(formattedDate);

          // Step 3: Add 7 hours to the parsedDate for the endDate
          DateTime endDate = parsedDate.add(Duration(hours: 7));

          // Use parsedDate for startDate and endDate for the event
          final Event event = Event(
            title: 'Holiday for ${user.endaddress}',
            description: 'Holiday declared by HR in account of ${user.endaddress}',
            location: 'Company Location',
            startDate: parsedDate, // Use parsedDate as startDate
            endDate: endDate, // Use the calculated endDate (7 hours ahead)
            iosParams: IOSParams(
              reminder: Duration(hours: 1), // Set reminder duration here.
              url: 'https://www.example.com', // Set URL for iOS.
            ),
            androidParams: AndroidParams(
              emailInvites: [], // Set email invites for Android.
            ),
          );
          Add2Calendar.addEvent2Cal(event);
          print('Event Start Date: $parsedDate');
          print('Event End Date: $endDate');
        },
        child: Container(
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
                  Text("Holiday for ${user.endaddress}",style:TextStyle(color:Colors.orangeAccent,fontWeight: FontWeight.w900,fontSize: 18)),
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
            )),
      ):
      (user.color==4294961979?Container(
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
          ))
            ));
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