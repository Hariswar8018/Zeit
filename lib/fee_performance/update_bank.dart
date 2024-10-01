import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeitt/model/usermodel.dart';
import 'package:zeitt/update/update_user.dart';

class BankSee extends StatelessWidget {
  UserModel user;
  BankSee({super.key,required this.user});
  bool myuser(){
    String gh = FirebaseAuth.instance.currentUser!.uid;
    if(gh==user.uid){
      return true;
    }else{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text(myuser()?"My Bank Account Details":"User Bank Account Details",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          s(),
          Center(
            child: Container(
              width: w-30,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   t1("Bank Account Details"),
                    s(),
                    s(),
                    t2(user.bankaccountname,"Bank Account Name","bankname",context),
                    t3("Bank Account Name"),
                    s(),
                    t2(user.bankaccount,"Account Number","bankaccount",context),
                    t3("Account Number"),
                    s(),
                    t2(user.ifsccode,"IIFC Code","ifsccode",context),
                    t3("IIFC Code"),
                    s(),
                    t2(user.bankname,"Bank Name","bankaccountname",context),
                    t3("Bank Name ( Optional )"),
                  ],
                ),
              ),
            ),
          ),
          s(),
          Center(
            child: Container(
              width: w-30,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    t1("UPI Details"),
                    s(),
                    s(),
                    t2(user.upiname,"UPI ID","upiname",context),
                    t3("UPI ID"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget s()=>SizedBox(height: 14,);
  Widget t1(String s)=> Text(s,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w800),);
  Widget t2(String s,String gh,String gh1,BuildContext context) {
    return Row(
      children: [
        Text(s, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
        SizedBox(width: 8,),
        myuser()?InkWell(
          onTap: (){
            Navigator.push(
                context, PageTransition(
                child: Update(Name: gh, doc: user.uid, Firebasevalue: gh1, Collection: 'Users', ),
                type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
            ));
          },child: Icon(Icons.edit,color: Colors.green,),
        ):SizedBox(),
      ],
    );
  }
  Widget t3(String s)=> Text(s,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Colors.grey),);
}
