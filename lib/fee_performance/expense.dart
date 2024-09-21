import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/fee_performance/expense_calculate.dart';
import 'package:zeit/fee_performance/expense_screen.dart';
import 'package:zeit/fee_performance/new_expense.dart';
import 'package:zeit/fee_performance/salary_template.dart';
import 'package:zeit/fee_performance/transaction.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class Expense extends StatelessWidget {
  OrganisationModel user;
   Expense({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Expense",style:TextStyle(color:Colors.white,fontSize: 23)),
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
                            child:Expense_C(user: user,),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 100)));
                  },
                  child: q(context, "assets/graph-svgrepo-com.svg", "Expense Screen")),
              InkWell(
                  onTap:(){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:ExpenseWidget(),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 100)));
                  },
                  child: q(context, "assets/transaction-finance-business-svgrepo-com.svg", "Add Expense")),
            ]),
            SizedBox(height:12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        PageTransition(
                            child:ExpenseScreen(id:_user!.source),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 100)));
                  },
                  child: q(context, "assets/money-svgrepo-com.svg", "All Expenses")),
              Container(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  height: MediaQuery.of(context).size.width / 2 - 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ]),
          ]
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
