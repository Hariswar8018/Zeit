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

class TrainingProgramForm extends StatefulWidget {

  TrainingProgramForm({super.key});

  @override
  State<TrainingProgramForm> createState() => _TrainingProgramFormState();
}

class _TrainingProgramFormState extends State<TrainingProgramForm> {

  void initState(){
    costController.text="0.1";
  }
  final TextEditingController companyController = TextEditingController();

  final TextEditingController trainerController = TextEditingController();

  final TextEditingController typeController = TextEditingController();

   TextEditingController startController = TextEditingController();

   TextEditingController endController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  final TextEditingController statusController = TextEditingController();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController feedbackLinkController = TextEditingController();

  final TextEditingController picController = TextEditingController();

  final TextEditingController locationController = TextEditingController();

  final TextEditingController feedbackController = TextEditingController();

  final List<TextEditingController> skillsControllers = [];

  final List<TextEditingController> attendanceControllers = [];

  final TextEditingController s1 = TextEditingController();
  final TextEditingController s2 = TextEditingController();
  final TextEditingController s3 = TextEditingController();
  final TextEditingController s4 = TextEditingController();
  final TextEditingController s5 = TextEditingController();

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
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
  final String g = DateTime.now().microsecondsSinceEpoch.toString();
String pic="https://www.learnworlds.com/app/uploads/2021/03/employees-working-with-laptops.webp";
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Training Details",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            dc(companyController, "Training Title", "Training Name", false),
            dcc(descController, "Description", "Enter Description", false),
            Padding(
              padding: const EdgeInsets.only(left:14.0),
              child: Row(
                children: [
                  Text(textAlign: TextAlign.left,"Type of Training",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  rt("Job Training",),
                  rt("Workshop",),
                  rt("Mind Training",),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Row(
                children: [
                  rt("Product Training",),
                  rt("Orientation",),
                  rt("Other",),
                ],
              ),
            ),
            dc(locationController, "Location ( Optional )", "Enter Location", false),
            _buildCalendarDialogButton(),
            oc(startController, "Start Date", "Enter Start Date", false),
            oc(endController, "End Date", "Enter End Date", false),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.accessibility_new, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Trainer Details",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(nameController, "Name of Trainer", "Enter Name", false),
            dc(emailController, "Email", "Enter Email", false),
            dc(phoneController, "Phone ( Optional )", "Enter Phone", true),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.star, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Feedback & Finance",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(costController, "Cost", "Enter Cost", true),
            dc(feedbackLinkController, "Feedback Link ( Optional ) ",
                "Enter Feedback Link", false),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.work_history, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Skills",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(s1, "Skill 1", "Enter Skill", false),
            dc(s2, "Skill 2", "Enter Skill", false),
            dc(s3, "Skill 3", "Enter Skill", false),
            dc(s4, "Skill 4", "Enter Skill", false),
            dc(s5, "Skill 5", "Enter Skill", false),
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
                List<String> l1= [s1.text,s2.text,s3.text,s4.text,s5.text];
               TrainingProgram h = TrainingProgram(
                   company: companyController.text, trainer:nameController.text, type: st,
                   start: startController.text, end: endController.text, cost: int.parse(costController.text), desc: descController.text,
                   status: "Active", name: nameController.text, id: g, email: emailController.text, phone: phoneController.text,
                   feedbackLink: feedbackLinkController.text, skills: l1, pic: pic,
                   attendance: [], star: 5, location: locationController.text,
                   feedback: feedbackController.text, Completed: [], Ignored: [], Incompleted: [], Pending: []);
               try{
                 await  FirebaseFirestore.instance.collection("Company")
                     .doc(_user!.source).collection("Training")
                     .doc(g).update(h.toJson());
               }catch(e){
                 await  FirebaseFirestore.instance.collection("Company")
                     .doc(_user!.source).collection("Training")
                     .doc(g).set(h.toJson());
               }
                try {
                  Expense j = Expense(
                    name: "Training for ${companyController.text}",
                    cost: double.parse(costController.text),
                    id: g,
                    doc: "Training",
                    docid: g,
                    year: DateTime
                        .now()
                        .year
                        .toString(),
                    month: DateTime
                        .now()
                        .month
                        .toString(),
                    explanation: "Expense for new Training ${companyController.text} organised by ${nameController.text}",
                  );
                  await FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Expense")
                      .doc(g).set(j.toJson());
                }catch(e){
                  print(e);
                }
                Navigator.push(
                    context,
                    PageTransition(
                        child: How(id: g, first4: 'TRAI', topic:"A New Training added by ${_user.Name}",sdk:"Training",
                          message: 'A New Training is added by Admin by ${_user.Name} : ${companyController.text}', docname: 'Training',),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200)));
              }),
        ),
      ],
    );
  }
  Widget dcc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,maxLines: 10,minLines: 4,
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
  String st="v";
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
                  startController = TextEditingController(text: formattedDate);
                  DateTime? date1 = _singleDatePickerValueWithDefaultValue[1] ;
                  String dateTimeString1 = date1.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime1 = DateTime.parse(dateTimeString1);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate1 = DateFormat('dd/MM/yyyy').format(dateTime1);
                  endController = TextEditingController(text: formattedDate1);
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
  Widget oc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,readOnly: true,
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
}
