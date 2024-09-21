import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/task_health_events_training.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';


class TemplateSS extends StatelessWidget {
  bool b;String id;
 TemplateSS({super.key,required this.b,required this.id});
  List<TemplateS> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Salary Template",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Company')
            .doc(id).collection("TemplateS")
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
                    "No Templates found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes Company haven't any Templates",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) =>
              TemplateS.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return HUer(user: _list[index], b:b);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              PageTransition(
                  child: TemplateSForm(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 100)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade100,
      ),
    );
  }
}

class HUer extends StatefulWidget {
  TemplateS user;bool b;
   HUer({super.key,required this.user,required this.b});

  @override
  State<HUer> createState() => _HUerState();
}

class _HUerState extends State<HUer> {
   bool me = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: (){
          setState(() {
            if(me){
              me=false;
            }else{
              me=true;
            }
          });
        },
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                title:  Text(widget.user.name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w800)),
                subtitle: Text("Template for "+widget.user.em),
                trailing: widget.b?(me?CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.verified,color: Colors.white,),
                ):CircleAvatar(

                    child: Icon(Icons.circle_outlined))):SizedBox(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  a("Basic",widget.user.basic),
                  SizedBox(width: 8,),
                  a("Allowance",widget.user.allowance),
                  SizedBox(width: 8,),
                  a("Overtime",widget.user.overtime),
                  SizedBox(width: 8,),
                  a("Other",widget.user.other),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20,),
                  s("Statutory",widget.user.statuatory),
                  SizedBox(width: 8,),
                  s("Loan",widget.user.loan),
                  SizedBox(width: 8,),
                  s("Pension",widget.user.pension),
                  SizedBox(width: 8,),
                  s("Other",widget.user.payment),
                ],
              ),
              widget.b?(me?Padding(
                padding: const EdgeInsets.all(10.0),
                child: SocialLoginButton(
                    backgroundColor: Colors.blue,
                    height: 40,
                    text: 'Use this Template',
                    borderRadius: 20,
                    fontSize: 21,
                    buttonType: SocialLoginButtonType.generalLogin,
                    onPressed: () async{
                      Navigator.pop(context,widget.user);
                    }),
              ):SizedBox()):SizedBox(),

              SizedBox(height:10),
            ],
          ),
        ),
      ),
    );
  }

  Widget a(String st, double d)=>Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(st+" : ",style:TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color:Colors.black)),
      Text("₹"+(d.toInt()).toString(),style:TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color:Colors.blue)),
    ],
  );

  Widget s(String st, double d)=>Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(st+" : ",style:TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color:Colors.black)),
      Text("₹"+(d.toInt()).toString(),style:TextStyle(fontSize: 11,fontWeight: FontWeight.w500,color:Colors.red)),
    ],
  );
}

class TemplateSForm extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emController = TextEditingController();
  final TextEditingController basicController = TextEditingController();
  final TextEditingController netController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController allowanceController = TextEditingController();
  final TextEditingController overtimeController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController statuatoryController = TextEditingController();
  final TextEditingController monthlyController = TextEditingController();
  final TextEditingController loanController = TextEditingController();
  final TextEditingController pensionController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();

  TemplateSForm({Key? key}) : super(key: key);

  Widget dc(TextEditingController c, String label, String hint, bool number) {
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
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Template",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.accessibility_new, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Template Detection",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            oc(nameController, "Name of Template", "Enter Name", false),
            oc(emController, "Eployee Template for ? ( Ex:-  Sales Manager ) ", "Enter Email", false),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.account_balance, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Salary",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(basicController, "Basic", "Enter Basic Salary", true),
            dc(netController, "Net Salary", "Enter Net Salary", true),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.accessible_forward_rounded, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Basic Allowance",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(allowanceController, "Allowance", "Enter Allowance", true),
            dc(overtimeController, "Overtime", "Enter Overtime", true),
            dc(otherController, "Other", "Enter Other", true),
            dc(statuatoryController, "Statuatory", "Enter Statuatory", true),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Icon(Icons.mobiledata_off_rounded, size: 30, color: Colors.blueAccent),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Basic Deductions",
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            dc(loanController, "Loan", "Enter Loan", true),
            dc(pensionController, "Pension", "Enter Pension", true),
            dc(paymentController, "Payment", "Enter Payment", true),
          ],
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 1),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Template',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                final String g = DateTime.now().microsecondsSinceEpoch.toString();
                TemplateS h = TemplateS(
                  name: nameController.text,
                  id: g,
                  em: emController.text,
                  basic: double.tryParse(basicController.text) ?? 0.0,
                  net: double.tryParse(netController.text) ?? 0.0,
                  status: statusController.text,
                  allowance: double.tryParse(allowanceController.text) ?? 0.0,
                  overtime: double.tryParse(overtimeController.text) ?? 0.0,
                  other: double.tryParse(otherController.text) ?? 0.0,
                  statuatory: double.tryParse(statuatoryController.text) ?? 0.0,
                  monthly: double.tryParse(monthlyController.text) ?? 0.0,
                  loan: double.tryParse(loanController.text) ?? 0.0,
                  pension: double.tryParse(pensionController.text) ?? 0.0,
                  payment: double.tryParse(paymentController.text) ?? 0.0,
                );
                await  FirebaseFirestore.instance.collection("Company")
                    .doc(_user!.source).collection("TemplateS")
                    .doc(g).set(h.toJson());
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
  Widget oc(TextEditingController c, String label, String hint, bool number) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.text ,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}

class TemplateS {
  late final String name;
  late final String id;
  late final String em;
  late final double basic;
  late final double net;
  late final String status;
  late final double allowance;
  late final double overtime;
  late final double other;
  late final double statuatory;
  late final double monthly;
  late final double loan;
  late final double pension;
  late final double payment;

  TemplateS({
    required this.name,
    required this.id,
    required this.em,
    required this.basic,
    required this.net,
    required this.status,
    required this.allowance,
    required this.overtime,
    required this.other,
    required this.statuatory,
    required this.monthly,
    required this.loan,
    required this.pension,
    required this.payment,
  });

  TemplateS.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    em = json['em'] ?? '';
    basic = (json['basic'] ?? 0.0).toDouble();
    net = (json['net'] ?? 0.0).toDouble();
    status = json['status'] ?? '';
    allowance = (json['allowance'] ?? 0.0).toDouble();
    overtime = (json['overtime'] ?? 0.0).toDouble();
    other = (json['other'] ?? 0.0).toDouble();
    statuatory = (json['statuatory'] ?? 0.0).toDouble();
    monthly = (json['monthly'] ?? 0.0).toDouble();
    loan = (json['loan'] ?? 0.0).toDouble();
    pension = (json['pension'] ?? 0.0).toDouble();
    payment = (json['payment'] ?? 0.0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['em'] = em;
    data['basic'] = basic;
    data['net'] = net;
    data['status'] = status;
    data['allowance'] = allowance;
    data['overtime'] = overtime;
    data['other'] = other;
    data['statuatory'] = statuatory;
    data['monthly'] = monthly;
    data['loan'] = loan;
    data['pension'] = pension;
    data['payment'] = payment;
    return data;
  }
}
