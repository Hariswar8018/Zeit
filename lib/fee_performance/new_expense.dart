import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeitt/functions/flush.dart';
import 'package:zeitt/functions/task_health_events_training.dart';
import 'package:zeitt/model/usermodel.dart';

import '../provider/declare.dart';

class ExpenseWidget extends StatefulWidget {

  ExpenseWidget({Key? key}) : super(key: key);

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController costController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController docController = TextEditingController();

  final TextEditingController docidController = TextEditingController();

  final TextEditingController yearController = TextEditingController();

  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();

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
            return 'Please type it';
          }
          return null;
        },
      ),
    );
  }
  final String g=DateTime.now().microsecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("New Expense Entry",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                rt("Accomodation",),
                rt("Food Expense",),
                rt("Travel 2 Wheel",),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0,right:8),
            child: Row(
              children: [
                rt("Train",),
                rt("Flight",),
                rt("Bus",),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0,right:8),
            child: Row(
              children: [
                rt("Travel 3 Wheel",),
                rt("Travel 4 Wheel",),
                rt("Other ",),
              ],
            ),
          ),
          dc(nameController, 'Reason for Expense', 'Enter expense name', false),
          ic(costController, 'Cost', 'Enter expense cost', true),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              children: [
                SizedBox(width: 8,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () async {
                      DateTime? selectedDateTime = await DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(2000, 1, 1),
                        maxTime: DateTime(2100, 12, 31),
                        onChanged: (date) {
                          print('Changed: $date');
                        },
                        onConfirm: (date) {
                          print('Confirmed: $date');
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en,
                      );

                      if (selectedDateTime != null) {
                        setState(() {
                          monthController.text = selectedDateTime.month.toString();
                          dayController.text = selectedDateTime.day.toString();
                          yearController.text = selectedDateTime.year.toString();
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                        height:45,width:MediaQuery.of(context).size.width/2-20,
                        decoration:BoxDecoration(
                          borderRadius:BorderRadius.circular(7),
                          color:Colors.blue,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4), // Shadow color with transparency
                              spreadRadius: 5, // The extent to which the shadow spreads
                              blurRadius: 7, // The blur radius of the shadow
                              offset: Offset(0, 3), // The position of the shadow
                            ),
                          ],
                        ),
                        child: Center(child: Text("Choose Date/Time",style: TextStyle(
                            color: Colors.white,
                            fontFamily: "RobotoS",fontWeight: FontWeight.w800
                        ),)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child:Row(
              children: [
                SizedBox(width: 10,),
                Container(
                  width: w*1/4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: dayController,
                      readOnly: true,
                      decoration: InputDecoration(

                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please type it';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  width: w*1/4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: monthController,
                      readOnly: true,
                      decoration: InputDecoration(

                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please type it';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  width: w*2/4 - 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: yearController,
                      readOnly: true,
                      decoration: InputDecoration(

                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please type it';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          oc(explanationController, 'Explanation', 'Enter explanation', false),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Expense',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                if(dayController.text.isEmpty||monthController.text.isEmpty||costController.text.isEmpty){
                  print(_user!.Name);
                  print(_user.pic);
                  Send.message(context, "Select Date as well as Cost", false);
                }else{
                  Expense h = Expense(
                    name: nameController.text,
                    cost: double.parse(costController.text),
                    id: g,
                    doc: docController.text,
                    docid: docidController.text,
                    year: yearController.text,
                    month: monthController.text,
                    explanation: explanationController.text, useruid: _user!.uid, stname: _user!.Name,
                    stpic: _user!.pic, stdeveloper: _user.education, date: "",
                  );
                  await  FirebaseFirestore.instance.collection("Company")
                      .doc(_user!.source).collection("Expense")
                      .doc(g).set(h.toJson());
                  Navigator.pop(context);
                }
              }),
        ),
      ],
    );
  }
  Widget ic(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number ,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixText: "₹ ",
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type it';
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
        controller: c,minLines: 4,maxLines: 16,
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please type it';
          }
          return null;
        },
      ),
    );
  }
  Widget rt(String jh){
    return InkWell(
        onTap : () async {
          setState(() {
            nameController.text=jh;
          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: nameController.text==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  nameController.text== jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
}

class Expense {
  late final String name;
  late final double cost;
  late final String id;
  late final String doc;
  late final String docid;
  late final String year;
  late final String month;
  late final String explanation;
  late final String useruid;   // Added useruid field
  late final String stname;    // Added stname field
  late final String stpic;     // Added stpic field
  late final String stdeveloper;// Added stdeveloper field
  late final String date;      // Added date field

  Expense({
    required this.name,
    required this.cost,
    required this.id,
    required this.doc,
    required this.docid,
    required this.year,
    required this.month,
    required this.explanation,
    required this.useruid,     // Required useruid
    required this.stname,      // Required stname
    required this.stpic,       // Required stpic
    required this.stdeveloper, // Required stdeveloper
    required this.date,        // Required date
  });

  Expense.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    cost = (json['cost'] ?? 0.0).toDouble();
    id = json['id'] ?? '';
    doc = json['doc'] ?? '';
    docid = json['docid'] ?? '';
    year = json['year'] ?? '';
    month = json['month'] ?? '';
    explanation = json['explanation'] ?? '';
    useruid = json['useruid'] ?? '';       // Handle useruid from JSON
    stname = json['stname'] ?? '';         // Handle stname from JSON
    stpic = json['stpic'] ?? '';           // Handle stpic from JSON
    stdeveloper = json['stdeveloper'] ?? ''; // Handle stdeveloper from JSON
    date = json['date'] ?? '';             // Handle date from JSON
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['cost'] = cost;
    data['id'] = id;
    data['doc'] = doc;
    data['docid'] = docid;
    data['year'] = year;
    data['month'] = month;
    data['explanation'] = explanation;
    data['useruid'] = useruid;         // Add useruid to JSON
    data['stname'] = stname;           // Add stname to JSON
    data['stpic'] = stpic;             // Add stpic to JSON
    data['stdeveloper'] = stdeveloper; // Add stdeveloper to JSON
    data['date'] = date;               // Add date to JSON
    return data;
  }
}
