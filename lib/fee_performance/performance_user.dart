import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/add/emp_history.dart';
import 'package:zeit/cards/emphistory.dart';
import 'package:zeit/cards/pdf.dart';
import 'package:zeit/fee_performance/performance_see/task.dart';
import 'package:zeit/fee_performance/performance_see/training.dart';
import 'package:zeit/fee_performance/transaction.dart';
import 'package:zeit/model/emp_history.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/update/update_user.dart';

import '../model/usermodel.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:custom_calendar_viewer/custom_calendar_viewer.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:zeit/model/time.dart';
import 'dart:async';

import '../services/attendance.dart';
import 'package:pie_chart/pie_chart.dart';

class PerformanceU extends StatefulWidget {
  UserModel user;
  PerformanceU({super.key,required this.user});

  @override
  State<PerformanceU> createState() => _PerformanceUState();
}

class _PerformanceUState extends State<PerformanceU> {
  late Map<String, double> dataMap ;
  late Map<String, double> dataMap2 ;
  Future<List<Date>> fetchDataFromFirestore() async {
    List<Date> firestoreDates = [];
    int hy=0,hy1=0,hy2=0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users")
        .doc(widget.user.uid)
        .collection("Attendance")
        .get();
    querySnapshot.docs.forEach((doc) {
      print(doc);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(doc['millisecondstos']));
      print(doc['color']);
      if(doc['color']==4294961979){
        hy++;
      }else if(doc['color']==4280391411){
        hy1++;
      }else{
        hy2++;
      }
      firestoreDates.add(Date(
        date: date,
        color: Color(doc['color']), // Use Color directly, no need to parse as int
      ));
    });
    setState(() {
      dataMap2 = {
        "Holiday": hy.toDouble(),
        "Present": hy1.toDouble(),
        "Leave": (30-hy1-hy).toDouble(),
        "Travel": 1,
      };
    });
    return firestoreDates;
  }
  late Map<String, double> dataMap3 ;
  void initState(){
    try{
      fetchDataFromFirestore();
    }catch(e){

    }

    double tI = 0;
    double tC=0;
    double tN=0;
    double tU=0;
    for (String huy in widget.user.follower){
      String h1=huy.substring(0,4);

      String h2=huy.substring(4,5);
      String h3=huy.substring(5);
      if(h1=="TASK"){
        if(h2=="L"){
          tU++;
        }else if(h2=="N"){
          tN++;
        }else if(h2=="C"){
          tC++;
        }else if(h2=="I"){
          tI++;
        }else{

        }
      }
    }
    dataMap = {
      "Not Completed": tU,
      "Completed": tN,
      "Still Doing": tC,
      "Ignored": tI,
    };


    double RI = 0;
    double RC=0;
    double RN=0;
    double RU=0;
    for (String huy in widget.user.follower){
      String h1=huy.substring(0,4);
      String h2=huy.substring(4,5);
      String h3=huy.substring(5);
      if(h1=="TRAI"){
        if(h2=="L"){
          tU++;
        }else if(h2=="N"){
          tN++;
        }else if(h2=="C"){
          tC++;
        }else if(h2=="I"){
          tI++;
        }else{

        }
      }
    }
    dataMap3 = {
      "Not Attended": RU,
      "Completed": RN,
      "In Training": RC,
      "Ignored": RI,
    };
  }


  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now().subtract(Duration(days: 4)),
    DateTime.now().add(Duration(days: 3)),
  ];
  int pre = 0 , abs = 0 , nt = 0;



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
          .doc(widget.user.uid)
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

  late final List<Date> dates   ;

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
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text(widget.user.Name+" Performance",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height:15),
            se("assets/calender-day-love-svgrepo-com.svg","Attendance Report"),
            SizedBox(height:15),
            _buildCalendarDialogButton(),
            PieChart(
              dataMap: dataMap2,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Attendance",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage:false,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
            SizedBox(height:25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               forattendance(context,w, true),
                forattendance(context,w, false),
              ],
            ),

           d(),
           se("assets/time-hourglass-svgrepo-com.svg","Task / Project Report"),
            SizedBox(height:15),
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              centerText: "Task",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage:false,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
            SizedBox(height:25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fortask(context,w, true,0),
                fortask(context,w, false,1),
              ],
            ),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fortask2(context,w, true,0),
                fortask2(context,w, false,1),
              ],
            ),
            d(),
            se("assets/factory-company-svgrepo-com.svg","Training"),
            SizedBox(height:15),
            PieChart(
              dataMap: dataMap3,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3,
              initialAngleInDegree: 0,
              chartType: ChartType.disc,
              ringStrokeWidth: 32,
              centerText: "Training",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage:false,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
            SizedBox(height:25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fortrain(context,w, true,0),
                fortrain(context,w, false,1),
              ],
            ),
            SizedBox(height:10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                fortrain2(context,w, true,2),
                fortrain2(context,w, false,3),
              ],
            ),
          ],
        ),
      )
    );
  }


  Widget se(String asset,String name)=> Row(
    children: [
      SizedBox(width:9),
      Container(
        height: 40,width: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:Border.all(
                color: Colors.blue,
                width: 2
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
              asset,
              semanticsLabel: 'Acme Logo'
          ),
        ),
      ),
      SizedBox(width:9),
      Text(name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 20)),
    ],
  );

  Widget d()=>  Padding(
    padding: const EdgeInsets.all(10.0),
    child: Divider(),
  );

  Widget forattendance(BuildContext context,double w,bool b)=> InkWell(
    onTap: (){
      Navigator.push(
          context,
          PageTransition(
              child: Attendance(time: b,uid: widget.user.uid),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: 600)));
    },
    child: Container(
      width: w/2-20,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color:b?Colors.purple:Colors.deepPurpleAccent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0,right:8),
        child: Row(
          children: [
            Text(!b?"Check Attendance":"Check Report",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16)),
            Spacer(),
            Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 25,),
          ],
        ),
      )
    ),
  );

  Widget fortask(BuildContext context,double w,bool b,int i)=> InkWell(
    onTap: (){
      print(widget.user.uid);
      if(i==0){
        Navigator.push(
            context,
            PageTransition(
                child:Taskk(uid: widget.user.uid, ft: 'Pending', name: widget.user.Name, topic: 'Pending Task', foll: widget.user.follower1,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }else {
        Navigator.push(
            context,
            PageTransition(
                child:Taskk(uid: widget.user.uid, ft: 'Completed', name: widget.user.Name, topic: 'Completed Task', foll: widget.user.follower,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }

    },
    child: Container(
        width: w/2-20,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:b?Colors.deepOrange:Colors.brown,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8),
          child: Row(
            children: [
              Text(!b?"Completed Task":"Pending Task",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 25,),
            ],
          ),
        )
    ),
  );

  Widget fortask2(BuildContext context,double w,bool b,int i)=> InkWell(
    onTap: (){
      print(widget.user.uid);
      if(i==0){
        Navigator.push(
            context,
            PageTransition(
                child:Taskk(uid: widget.user.uid, ft: "Ignored", name: widget.user.Name, topic: 'Pending Task', foll: widget.user.follower1,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }else {
        Navigator.push(
            context,
            PageTransition(
                child:Taskk(uid: widget.user.uid, ft: 'Incompleted', name: widget.user.Name, topic: 'Completed Task', foll: widget.user.follower,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }

    },
    child: Container(
        width: w/2-20,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:b?Colors.indigo:Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8),
          child: Row(
            children: [
              Text(!b?"Incomplete Task":"Ignored Task",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 25,),
            ],
          ),
        )
    ),
  );


  Widget fortrain(BuildContext context,double w,bool b,int i)=> InkWell(
    onTap: (){
      if(i==0){
        Navigator.push(
            context,
            PageTransition(
                child:Traink(uid: widget.user.uid, ft: 'Pending', name: widget.user.Name, topic: 'Pending Training', foll: widget.user.follower1,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }else {
        Navigator.push(
            context,
            PageTransition(
                child:Traink(uid: widget.user.uid, ft: 'Completed', name: widget.user.Name, topic: 'Completed Training', foll: widget.user.follower,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }

    },
    child: Container(
        width: w/2-20,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:b?Colors.deepOrange:Colors.brown,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8),
          child: Row(
            children: [
              Text(!b?"Completed Training":"Pending Training",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 25,),
            ],
          ),
        )
    ),
  );
  Widget fortrain2(BuildContext context,double w,bool b,int i)=> InkWell(
    onTap: (){
      if(i==0){
        Navigator.push(
            context,
            PageTransition(
                child:Traink(uid: widget.user.uid, ft: 'Ignored', name: widget.user.Name, topic: 'Ignored Training', foll: widget.user.follower1,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }else {
        Navigator.push(
            context,
            PageTransition(
                child:Traink(uid: widget.user.uid, ft: 'Incompleted', name: widget.user.Name, topic: 'Incomplete Training', foll: widget.user.follower,),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 600)));
      }

    },
    child: Container(
        width: w/2-20,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:b?Colors.indigo:Colors.red,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left:8.0,right:8),
          child: Row(
            children: [
              Text(!b?"Incomplete Training":"Ignored Training",style:TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 16)),
              Spacer(),
              Icon(Icons.arrow_forward_ios_sharp,color:Colors.white,size: 25,),
            ],
          ),
        )
    ),
  );
}
