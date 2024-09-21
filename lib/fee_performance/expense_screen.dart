import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:zeit/fee_performance/new_expense.dart';

class ExpenseScreen extends StatefulWidget {
String id;
  ExpenseScreen({super.key,required this.id});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        children: [
          Container(height : 60, width : MediaQuery.of(context).size.width , color : Colors.deepPurple.shade200,
              child : Center (
                  child : Row(
                      children : [
                        Container(
                          width : MediaQuery.of(context).size.width / 2,
                          child : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Year',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: items
                                  .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14, color : Colors.black
                                  ),
                                ),
                              ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 140,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width : MediaQuery.of(context).size.width / 2,
                          child : DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Select Month',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: items1
                                  .map((String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14, color : Colors.black
                                  ),
                                ),
                              ))
                                  .toList(),
                              value: mo,
                              onChanged: (String? value) {
                                setState(() {
                                  mo = value!;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 40,
                                width: 140,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        )
                      ]
                  )
              )
          ),
          Container(
            height : MediaQuery.of(context).size.height - 145,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Company').doc(widget.id)
                  .collection('Expense').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list =
                        data?.map((e) => Expense.fromJson(e.data())).toList() ?? [];
                    if ( list.isEmpty){
                      return Center(
                          child : Column(
                              mainAxisAlignment : MainAxisAlignment.center,
                              children : [
                                Icon(Icons.hourglass_empty, color : Colors.red, size : 80),
                                Text(textAlign : TextAlign.center, "Look Likes ! No Transaction have occured during the Timeline", style : TextStyle(color : Colors.red, fontSize : 17)),
                                SizedBox(height : 15),
                                TextButton(onPressed:(){
                                  DateTime now = DateTime.now();
                                  int Mo = now.month;
                                  int Ye = now.year;
                                  setState((){
                                    selectedValue = Ye.toString();
                                  });
                                  setState((){
                                    mo = Mo.toString();
                                  });
                                }, child : Text("Go to Today")),
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
          ),
        ],
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
      child: ListTile(
        title: Text(user.name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
        subtitle:  Text(user.explanation,style:TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),
        trailing: Text("- "+user.cost.toString(),style:TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: Colors.red),),
      ),
    );
  }
}
