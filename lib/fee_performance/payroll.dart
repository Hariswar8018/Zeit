import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/fee_performance/change_salary.dart';
import 'package:zeit/fee_performance/salary_template.dart';
import 'package:zeit/fee_performance/transaction.dart';
import 'package:zeit/functions/give_back_user.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/notification/notify_one.dart';
import 'package:zeit/provider/declare.dart';

class Payroll extends StatefulWidget {
  OrganisationModel user;
  Payroll({super.key,required this.user});

  @override
  State<Payroll> createState() => _PayrollState();
}

class _PayrollState extends State<Payroll> {
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Payroll",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body:Column(
        children:[
          SizedBox(height:12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child:Transactionn(id:_user!.source),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 100)));
                },
                child: q(context, "assets/transaction-record-svgrepo-com.svg", "Transactions")),
            InkWell(
              onTap:(){
                Navigator.push(
                    context,
                    PageTransition(
                        child: PayModelForm(user: widget.user,),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 100)));
              },
                child: q(context, "assets/purchase-buy-pay-transaction-svgrepo-com.svg", "Add Payroll")),
          ]),
          SizedBox(height:12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      PageTransition(
                          child:NSalary(id:_user!.source, user: widget.user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 100)));
                },
                child: q(context, "assets/transaction-money-svgrepo-com.svg", "Employee Salary")),
            InkWell(
              onTap:(){
                Navigator.push(
                    context,
                    PageTransition(
                        child: TemplateSS(b: false, id: _user!.source,),
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 100)));
              },
                child: q(context, "assets/briefcase-svgrepo-com.svg", "Salary Template")),
          ]),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              PageTransition(
                  child: PayModelForm(user: widget.user,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Widget q(BuildContext context, String asset, String str) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 135;
    return Container(
        width: d,
        height: d,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                asset,
                semanticsLabel: 'Acme Logo',
                height: h,
              ),
              SizedBox(height: 15),
              Text(str, style: TextStyle(fontWeight: FontWeight.w500)),
            ]));
  }
}


class PayModelForm extends StatefulWidget {

  OrganisationModel user;
  PayModelForm({required this.user});
  @override
  _PayModelFormState createState() => _PayModelFormState();
}

class _PayModelFormState extends State<PayModelForm> {
  // Define TextEditingControllers for each variable
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController picController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
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
  String token = " ";
  final String g =DateTime.now().microsecondsSinceEpoch.toString();
  // Helper function to create text fields
  Widget _buildTextField(TextEditingController controller, String label, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number ,
        decoration: InputDecoration(
          labelText: label,
          prefixText: "₹ ",
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          int all = int.tryParse(allowanceController.text) ?? 0;
          int ove = int.tryParse(overtimeController.text) ?? 0;
          int other = int.tryParse(otherController.text) ?? 0;
          int sta = int.tryParse(statuatoryController.text) ?? 0;
          int loan = int.tryParse(loanController.text) ?? 0;
          int pension = int.tryParse(pensionController.text) ?? 0;
          int payment = int.tryParse(paymentController.text) ?? 0;
          int month = int.tryParse(monthlyController.text) ?? 0;
          int basic = int.tryParse(basicController.text) ?? 0;
          // Add up all the integer values
          int total = basic + month + all + ove + other - sta - loan -pension-payment;
          // Set the Feef.text as the total converted to string
          netController.text = total.toString();
          setState(() {

          });
        },
      ),
    );
  }
  Widget _buildText(TextEditingController controller, String label, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        keyboardType:  TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
String pic ="";String tokenn="h";
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Add Payroll",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          padding: const EdgeInsets.all(1.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(Icons.accessibility_new, size: 30, color: Colors.blueAccent),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Employee Details",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              ),
              ListTile(
                onTap: () async {
                  UserModel s = await Navigator.push(
                      context,
                      PageTransition(
                          child: BackUser(user: widget.user,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 100)));
                  nameController.text=s.Name;
                  positionController.text=s.education;
                  typeController.text=s.uid;
                  tokenn=s.token;
                  monthlyController.text=s.salary.toString();
                  setState(() {
                    pic=s.pic;
                  });
                },
                tileColor: Colors.red.shade50,
                leading: Icon(Icons.work,color: Colors.blue,),
                title: Text("Find Employee",style:TextStyle(color: Colors.blue,fontWeight: FontWeight.w700)),
                subtitle: Text("Choose one of the Employee",style:TextStyle(color: Colors.blue)),
                trailing: Icon(Icons.arrow_forward_ios,color:Colors.blue),
              ),
              SizedBox(height: 10,),
              pic==""?SizedBox():Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(pic),
                ),
              ),
              SizedBox(height: 10,),
              _buildText(nameController, 'Name', false),
              _buildText(positionController, 'Position', false),
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
              ListTile(
                tileColor: Colors.blue.shade50,
                onTap: () async {
                  TemplateS s = await Navigator.push(
                      context,
                      PageTransition(
                          child: TemplateSS(id:_user!.source, b: true,),
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 100)));
                  basicController.text=s.basic.toString();
                  allowanceController.text=s.allowance.toString();
                  overtimeController.text=s.overtime.toString();
                  otherController.text=s.other.toString();
                  statuatoryController.text=s.statuatory.toString();
                  loanController.text=s.loan.toString();
                  pensionController.text=s.pension.toString();
                  paymentController.text=s.payment.toString();
                  setState(() {
                    int all = int.tryParse(allowanceController.text) ?? 0;
                    int ove = int.tryParse(overtimeController.text) ?? 0;
                    int other = int.tryParse(otherController.text) ?? 0;
                    int sta = int.tryParse(statuatoryController.text) ?? 0;
                    int loan = int.tryParse(loanController.text) ?? 0;
                    int pension = int.tryParse(pensionController.text) ?? 0;
                    int payment = int.tryParse(paymentController.text) ?? 0;
                    int month = int.tryParse(monthlyController.text) ?? 0;
                    int basic = int.tryParse(basicController.text) ?? 0;
                    // Add up all the integer values
                    int total = basic + month + all + ove + other - sta - loan -pension-payment;
                    // Set the Feef.text as the total converted to string
                    netController.text = total.toString();
                  });
                },
                leading: Icon(Icons.newspaper),
                title: Text("Add from Template",style:TextStyle(color: Colors.red,fontWeight: FontWeight.w700)),
                subtitle: Text("Choose from Premade Template",style:TextStyle(color: Colors.red)),
                trailing: Icon(Icons.arrow_forward_ios,color:Colors.red),
              ),
              SizedBox(height: 10,),
              _buildTextField(monthlyController, 'Monthly Salary', true),
              _buildTextField(basicController, 'Basic Salary', true),
              _buildTextField(netController, 'Net Salary', true),
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
              _buildTextField(allowanceController, 'Allowance', true),
              _buildTextField(overtimeController, 'Overtime', true),
              _buildTextField(otherController, 'Other', true),
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
              _buildTextField(statuatoryController, 'Statuatory', true),
              _buildTextField(loanController, 'Loan', true),
              _buildTextField(pensionController, 'Pension', true),
              _buildTextField(paymentController, 'Other', true),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 1.0, right: 1),
          child: SocialLoginButton(
              backgroundColor: Colors.blue,
              height: 40,
              text: 'Add Payroll  ₹${netController.text}  and Notify',
              borderRadius: 20,
              fontSize: 21,
              buttonType: SocialLoginButtonType.generalLogin,
              onPressed: () async{
                PayModel h = PayModel(
                  name: nameController.text,
                  id: g,
                  type: typeController.text,
                  pic: pic,
                  position: positionController.text,
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
                    .doc(_user!.source).collection("Payroll")
                    .doc(g).set(h.toJson());
                try{
                  NotifyOne.sendNotificationsToTokens("Congrats ${nameController.text}, your Payroll is Procced",
                      "HR had proceed your Payroll Application : Go Check",
                      tokenn
                  );
                }catch(e){
                  print(e);
                }
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }
}
