import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/cards/usercards.dart';
import 'package:zeit/fee_performance/pdf_statement.dart';
import 'package:zeit/functions/task_health_events_training.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/pay.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class Transactionn extends StatefulWidget {
  String id;
  Transactionn({super.key,required this.id});

  @override
  State<Transactionn> createState() => _TransactionnState();
}

class _TransactionnState extends State<Transactionn> {
  List<PayModel> _list = [];
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
    '4', // This value is causing the error
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
        title: Text("All Payroll",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            child:StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Company')
                  .doc(widget.id).collection("Payroll")
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
                    PayModel.fromJson(e.data())).toList() ?? []);
                return ListView.builder(
                  itemCount: _list.length,
                  padding: EdgeInsets.only(top: 10),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Per(user: _list[index],id:widget.id );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class Per extends StatelessWidget {
  PayModel user;String id;
  Per({super.key,required this.user,required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: dfs(id=="NO",context),
    );
  }

  Widget dfs(bool tyt,BuildContext context){
    if(tyt){
      return ListTile(
          onTap: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 250,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height:8,width:90,decoration: BoxDecoration(
                            color:Colors.blue,borderRadius: BorderRadius.circular(15)
                        ),
                        ),SizedBox(
                          height: 8,
                        ),
                        Text("View or Download Payroll", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        as(3,context,Icon(Icons.now_wallpaper_sharp),"Download as PDF","See the Report Now as PDF",true),
                        as(4,context,Icon(Icons.download_done_outlined),"Download as JPEG","Download the Report",true),
                        SizedBox(height:10)
                      ],
                    ),
                  ),
                );
              },
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.pic),
          ),
          title: Text("+ " +(user.net.toInt()).toString(),style:TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Colors.green)),
          subtitle:  Text("Paid to you on "+format(user.id),style:TextStyle(fontSize: 11,fontWeight: FontWeight.w500)),
          trailing: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color:Colors.red,
                    width: 2
                )
            ),
            child:Padding(
              padding: const EdgeInsets.only(top:5.0,bottom: 5,left: 8,right: 8),
              child: Text(user.status.isEmpty?"PAID":user.status,style:TextStyle(color:Colors.red,fontWeight: FontWeight.w800)),
            ),
          )
      );
    }else{
      return ListTile(
          onTap: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 900,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:  <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height:8,width:90,decoration: BoxDecoration(
                            color:Colors.blue,borderRadius: BorderRadius.circular(15)
                        ),
                        ),SizedBox(
                          height: 8,
                        ),
                        Text("View or Download Payroll", textAlign : TextAlign.left, style : TextStyle(color : Colors.black, fontWeight : FontWeight.w900, fontSize: 20)),
                        SizedBox(
                          height: 10,
                        ),
                        as(0,context,Icon(Icons.no_food_rounded),"Mark Unpaid","Mark the Payroll Unpaid",true),
                        user.status=="PAID"?as(5,context,Icon(Icons.fastfood_outlined),"Mark Waiting","Mark still Waiting to Pay",true):
                        as(1,context,Icon(Icons.fastfood_outlined),"Mark Paid","Mark the Payroll Paid",true),
                        as(2,context,Icon(Icons.person),"View User","View the Employee Account",true),
                        as(3,context,Icon(Icons.now_wallpaper_sharp),"See the Report","See the Report Now",true),
                        as(4,context,Icon(Icons.download_done_outlined),"Download Report","Download the Report",true),
                        SizedBox(height:10)
                      ],
                    ),
                  ),
                );
              },
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.pic),
          ),
          title: Text("- " +user.net.toString(),style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.red)),
          subtitle:  Text(user.name+"    - ${user.position}",style:TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
          trailing: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color:Colors.red,
                    width: 2
                )
            ),
            child:Padding(
              padding: const EdgeInsets.only(top:5.0,bottom: 5,left: 8,right: 8),
              child: Text(user.status.isEmpty?"PAID":user.status,style:TextStyle(color:Colors.red,fontWeight: FontWeight.w800)),
            ),
          )
      );
    }
  }
  String format(String milliseconds) {
    // Convert millisecondsSinceEpoch to DateTime
    try {
      int ik = int.parse(milliseconds);
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(ik);

      // Format the DateTime to show only the date (e.g., "dd/MM/yyyy")
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

      return formattedDate;
    }catch(e){
      return "Long Time Ago";
    }
  }

  Widget as(int i,BuildContext context,Widget a,String s, String s1,bool gh){
    return ListTile(
      leading: a,
      onTap: (){
        ggh(context,i);
      },
      title:Text(s,style: TextStyle(fontWeight: FontWeight.w800),),
      subtitle: Text(s1),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
  void ggh(BuildContext context,int i) async{
    if(i==0){
      print(user.type);
      await  FirebaseFirestore.instance.collection("Company")
          .doc(id).collection("Payroll")
          .doc(user.id).update({
        "status":"UNPAID",
      });
      Navigator.pop(context);
    }else if(i==1){
      print(id);
      print(user.id);
      await  FirebaseFirestore.instance.collection("Company")
          .doc(id).collection("Payroll")
          .doc(user.id).update({
        "status":"PAID",
      });

      Navigator.pop(context);
    }else if(i==2){
      try {
        // Reference to the 'users' collection
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('Users');
        // Query the collection based on uid
        QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: user.type).get();
        // Check if a document with the given uid exists
        if (querySnapshot.docs.isNotEmpty) {
          // Convert the document snapshot to a UserModel
          UserModel user = UserModel.fromSnap(querySnapshot.docs.first);
          Navigator.push(
              context,
              PageTransition(
                  child: UserC(user: user,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 600)));
        } else {
          // No document found with the given uid
          print("No fhgh");
        }
      } catch (e) {
        print("Error fetching user by uid: $e");
        return null;
      }
    }else if(i==3){
      String  uid = FirebaseAuth.instance.currentUser!.uid ;
      try {
        // Reference to the 'users' collection
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
        // Query the collection based on uid
        QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
        // Check if a document with the given uid exists
        if (querySnapshot.docs.isNotEmpty) {
          // Convert the document snapshot to a UserModel
          OrganisationModel userr = OrganisationModel.fromSnap(querySnapshot.docs.first);
          Navigator.push(
              context,
              PageTransition(
                  child:Pdf_Statement( u: user, o: userr,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 100)));
        } else {
          // No document found with the given uid
          return null;
        }
      } catch (e) {
        print("Error fetching user by uid: $e");
        return null;
      }

    }else if(i==4){
      String  uid = FirebaseAuth.instance.currentUser!.uid ;
      try {
        // Reference to the 'users' collection
        CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
        // Query the collection based on uid
        QuerySnapshot querySnapshot = await usersCollection.where('people', arrayContains: uid).get();
        // Check if a document with the given uid exists
        if (querySnapshot.docs.isNotEmpty) {
          // Convert the document snapshot to a UserModel
          OrganisationModel userr = OrganisationModel.fromSnap(querySnapshot.docs.first);
          Navigator.push(
              context,
              PageTransition(
                  child:I_Statement( u: user, o: userr,),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 100)));
        } else {
          // No document found with the given uid
          return null;
        }
      } catch (e) {
        print("Error fetching user by uid: $e");
        return null;
      }

    }else{
      await  FirebaseFirestore.instance.collection("Company")
          .doc(id).collection("Payroll")
          .doc(user.id).update({
        "status":"Waiting",
      });
      Navigator.pop(context);
    }
  }
}
