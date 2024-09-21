import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zeit/fee_performance/new_expense.dart';
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
import '../model/usermodel.dart';
class TravelWidget extends StatefulWidget {
  @override
  _TravelWidgetState createState() => _TravelWidgetState();
}

class _TravelWidgetState extends State<TravelWidget> {
  final TextEditingController picController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController iternarylinkController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController flnoController = TextEditingController();
  final TextEditingController flmodeController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController accController = TextEditingController();
  final TextEditingController transportcostController = TextEditingController();
  final TextEditingController dailyexpController = TextEditingController();
  final TextEditingController msexpenseController = TextEditingController();
  final TextEditingController roomtypeController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController des = TextEditingController();
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
        onChanged: (value){
          int a= int.parse(accController.text);
          int t= int.parse(totalController.text);
          int tra = int.parse(transportcostController.text);
          int da = int.parse(dailyexpController.text);
          int mi = int.parse(msexpenseController.text);
          setState(() {
            costController.text=(a+t+tra+da+mi).toString();
          });
        },
      ),
    );
  }
  Widget oc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,readOnly: true,
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
          int a= int.parse(accController.text);
          int t= int.parse(totalController.text);
          int tra = int.parse(transportcostController.text);
          int da = int.parse(dailyexpController.text);
          int mi = int.parse(msexpenseController.text);
          setState(() {
            costController.text=(a+t+tra+da+mi).toString();
          });
        },
      ),
    );
  }
  Widget mc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,minLines: 6,maxLines: 20,
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
          int a= int.parse(accController.text);
          int t= int.parse(totalController.text);
          int tra = int.parse(transportcostController.text);
          int da = int.parse(dailyexpController.text);
          int mi = int.parse(msexpenseController.text);
          setState(() {
            costController.text=(a+t+tra+da+mi).toString();
          });
        },
      ),
    );
  }
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }
  final String g = DateTime.now().microsecondsSinceEpoch.toString();
  String pic="https://www.learnworlds.com/app/uploads/2021/03/employees-working-with-laptops.webp";
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Travel Event",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            dc(nameController, "Name", "Enter Name", false),
            dc(iternarylinkController, "Itinerary Link", "Enter Itinerary Link", false),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.accessibility_new, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Travel Details",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            _buildCalendarDialogButton(),
            dc(startdateController, "Start Date", "Enter Start Date", false),
            dc(enddateController, "End Date", "Enter End Date", false),
            dc(cityController, "City", "Enter City", false),
            dc(locationController, "Location", "Enter Location", false),
            dc(countryController, "Country", "Enter Country", false),
            dc(flnoController, "Flight Number", "Enter Flight Number", false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  rt("Train",),
                  rt("Flight",),
                  rt("Bus",),
                  rt("Other"),
                ],
              ),
            ),
            dc(roomtypeController, "Room Type", "Enter Room Type", false),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  rtt("Single",),
                  rtt("Double",),
                  rtt("Other"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.account_balance, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Cost Details",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(totalController, "Total", "Enter Total", true),
            dc(accController, "Accommodation Cost", "Enter Accommodation Cost", true),
            dc(transportcostController, "Transport Cost", "Enter Transport Cost", true),
            dc(dailyexpController, "Daily Expense", "Enter Daily Expense", true),
            dc(msexpenseController, "Miscellaneous Expense", "Enter Miscellaneous Expense", true),
            oc(costController, "Total Cost", "Enter Miscellaneous Expense", true),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.info, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Descriptions",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            mc(des, "Description", "Enter Description", false),
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
                Travel h = Travel(
                  pic: pic,
                  name: nameController.text,
                  iternarylink: iternarylinkController.text,
                  location: locationController.text,
                  cost: double.tryParse(costController.text) ?? 0.0,
                  passport: true, // assuming default values for now
                  startdate: startdateController.text,
                  enddate: enddateController.text,
                  city: cityController.text,
                  country: countryController.text,
                  flno: flnoController.text,
                  flmode: st,
                  total: double.tryParse(totalController.text) ?? 0.0,
                  acc: double.tryParse(accController.text) ?? 0.0,
                  transportcost: double.tryParse(transportcostController.text) ?? 0.0,
                  dailyexp: double.tryParse(dailyexpController.text) ?? 0.0,
                  msexpense: double.tryParse(msexpenseController.text) ?? 0.0,
                  visa: true, // assuming default values for now
                  roomType: roomtypeController.text,
                  id:g,
                  attendance: [], descri: des.text, // assuming empty list for now
                );

                await  FirebaseFirestore.instance.collection("Company")
                    .doc(_user!.source).collection("Travel")
                    .doc(g).set(h.toJson());
                Navigator.push(
                    context,
                    PageTransition(
                        child: How(id: g, first4: 'TRAV', topic:"A New Travel added by ${_user.Name}",sdk: "Travel",
                          message: 'A New Travel is added by HR to ${locationController.text} ', docname: 'Travel',),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200)));
                try {
                  Expense j = Expense(
                    name: "Travel to ${locationController.text}",
                    cost: double.parse(costController.text),
                    id: g,
                    doc: "Travel",
                    docid: g,
                    year: DateTime
                        .now()
                        .year
                        .toString(),
                    month: DateTime
                        .now()
                        .month
                        .toString(),
                    explanation: "Expense for new Travel starting on ${startdateController
                        .text} to ${locationController.text}",
                  );
                  await FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Expense")
                      .doc(g).set(j.toJson());
                }catch(e){
                  print(e);
                }
              }),
        ),
      ],
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

  String stt = "Insurance" ;
  Widget rtt(String jh){
    return InkWell(
        onTap : (){
          setState(() {
            stt = jh ;
            roomtypeController.text=jh;
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
                  startdateController = TextEditingController(text: formattedDate);
                  DateTime? date1 = _singleDatePickerValueWithDefaultValue[1] ;
                  String dateTimeString1 = date1.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime1 = DateTime.parse(dateTimeString1);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(dateTime1);
                  enddateController = TextEditingController(text: formattedDate1);
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
}
class Travel {
  late final String pic;
  late final String name;
  late final String iternarylink;
  late final String location;
  late final String roomType;
  late final String id;
  late final List attendance;
  late final String startdate;
  late final String enddate;
  late final String city;
  late final String country;
  late final String flno;
  late final String flmode;
  late final double cost;
  late final double total;
  late final double acc;
  late final double transportcost;
  late final double dailyexp;
  late final double msexpense;
  late final bool passport;
  late final bool visa;
  late final String descri;

  Travel({
    required this.pic,
    required this.name,
    required this.iternarylink,
    required this.location,
    required this.roomType,
    required this.id,
    required this.attendance,
    required this.startdate,
    required this.enddate,
    required this.city,
    required this.country,
    required this.flno,
    required this.flmode,
    required this.cost,
    required this.total,
    required this.acc,
    required this.transportcost,
    required this.dailyexp,
    required this.msexpense,
    required this.passport,
    required this.visa,
    required this.descri,
  });

  Travel.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] ?? '';
    name = json['name'] ?? '';
    iternarylink = json['iternarylink'] ?? '';
    location = json['location'] ?? '';
    roomType = json['roomType'] ?? '';
    id = json['id'] ?? '';
    attendance = List.from(json['attendance'] ?? []);
    startdate = json['startdate'] ?? '';
    enddate = json['enddate'] ?? '';
    city = json['city'] ?? '';
    country = json['country'] ?? '';
    flno = json['flno'] ?? '';
    flmode = json['flmode'] ?? '';
    cost = (json['cost'] ?? 0.0).toDouble();
    total = (json['total'] ?? 0.0).toDouble();
    acc = (json['acc'] ?? 0.0).toDouble();
    transportcost = (json['transportcost'] ?? 0.0).toDouble();
    dailyexp = (json['dailyexp'] ?? 0.0).toDouble();
    msexpense = (json['msexpense'] ?? 0.0).toDouble();
    passport = json['passport'] ?? false;
    visa = json['visa'] ?? false;
    descri = json['descri'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pic'] = pic;
    data['name'] = name;
    data['iternarylink'] = iternarylink;
    data['location'] = location;
    data['roomType'] = roomType;
    data['id'] = id;
    data['attendance'] = attendance;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['city'] = city;
    data['country'] = country;
    data['flno'] = flno;
    data['flmode'] = flmode;
    data['cost'] = cost;
    data['total'] = total;
    data['acc'] = acc;
    data['transportcost'] = transportcost;
    data['dailyexp'] = dailyexp;
    data['msexpense'] = msexpense;
    data['passport'] = passport;
    data['visa'] = visa;
    data['descri'] = descri;
    return data;
  }
}

