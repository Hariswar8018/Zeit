import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/task_health_events_training.dart';
import 'package:zeit/model/usermodel.dart';

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

          dc(yearController, 'Year', 'Enter year', true),
          dc(monthController, 'Month', 'Enter month', true),
          oc(explanationController, 'Explanation', 'Enter explanation', false),
          // Add a button to save or submit the data
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Notify Employees',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{

                Expense h = Expense(
                  name: nameController.text,
                  cost: double.parse(costController.text),
                  id: g,
                  doc: docController.text,
                  docid: docidController.text,
                  year: yearController.text,
                  month: monthController.text,
                  explanation: explanationController.text,
                );
                await  FirebaseFirestore.instance.collection("Company")
                    .doc(_user!.source).collection("Expense")
                    .doc(g).set(h.toJson());
                Navigator.pop(context);
                Navigator.push(
                    context,
                    PageTransition(
                        child: How(id: g, first4: 'Expense', topic:"A New ${nameController.text} added by ${_user.Name} for You",sdk: "Expense",
                          message: 'A New ${nameController.text} is added by HR ${_user.Name} : ${explanationController.text}', docname:"Expense",),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 200)));
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

  Expense({
    required this.name,
    required this.cost,
    required this.id,
    required this.doc,
    required this.docid,
    required this.year,
    required this.month,
    required this.explanation,
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
    return data;
  }
}