import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:zeitt/fee_performance/new_expense.dart';
import 'package:zeitt/model/usermodel.dart';

import '../provider/declare.dart';

class ExpenseScreen1 extends StatefulWidget {
  String id;
  ExpenseScreen1({super.key,required this.id});

  @override
  State<ExpenseScreen1> createState() => _ExpenseScreen1State();
}

class _ExpenseScreen1State extends State<ExpenseScreen1> {
  void initState(){
    DateTime now = DateTime.now();
    int Mo = now.month;
    int Ye = now.year;
    setState((){
      selectedValue = Ye.toString();
    });
    setState((){
      mo = Mo.toString();
    });
  }

  String selectedValue = "2023";

  String mo = "1";
  List<Expense> list = [];

  late Map<String, dynamic> userMap;
  final List<String> items = [
    '2019',
    '2020',
    '2021',
    '2022', '2023','2024','2025','2026','2027','2028','2029',
  ];

  final List<String> items1 = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  bool ishr(UserModel user){
    if(user.type=="Individual"){
      return false;
    }else{
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      floatingActionButton:  InkWell(
        onTap: (){
          Navigator.push(
              context,
              PageTransition(
                  child:ExpenseWidget(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 100)));
        },
        child: Container(
          width: 140, height : 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add_card_outlined,color :Colors.white),
                  Text("  Add Expense", style : TextStyle(color : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("All Expenses",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Company').doc(widget.id)
            .collection('Expense').where("useruid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data?.map((e) => Expense.fromJson(e.data())).toList() ?? [];
              if ( list.isEmpty){
                return Center(
                    child : Column(
                        mainAxisAlignment : MainAxisAlignment.center,
                        children : [
                          Icon(Icons.hourglass_empty, color : Colors.red, size : 80),
                          Text(textAlign : TextAlign.center, "Look Likes ! You haven't any Expense", style : TextStyle(color : Colors.red, fontSize : 17)),
                          SizedBox(height : 15),
                        ]
                    )
                );
              }else{
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(bottom: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Cha(user: list[index],);
                  },
                );
              }

          }
        },
      ),
    );
  }
}
class Cha extends StatelessWidget {
  Expense user;
  Cha({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(user.name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
            subtitle:  Text(user.explanation,style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
            trailing: Text("- "+user.cost.toString(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: Colors.red),),
          ),
          user.stname.isNotEmpty?Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.stpic),
                  radius: 10,
                ),
                Text(" Reimbursed to "+user.stname)
              ],
            ),
          ):SizedBox()
        ],
      ),
    );
  }
}
