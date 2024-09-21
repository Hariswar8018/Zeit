import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:zeit/fee_performance/expense_calculate.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart';
import 'package:zeit/provider/declare.dart';

class Kpi extends StatefulWidget {
  OrganisationModel user;
  Kpi({super.key,required this.user});

  @override
  State<Kpi> createState() => _KpiState();
}

class _KpiState extends State<Kpi> {
  void countp1() async {
    DateTime currentDate = DateTime.now();
    String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    int count = 0; int i=0,j=0;
    await FirebaseFirestore.instance
        .collection('Users').where("jobfollower1",arrayContains: formattedDate)
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      people1 = i;
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        j = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      people1 = j;
    });
    setState(() {
      dataMap1 = {
        "Present":i.toDouble(),
        "Total": j.toDouble()-i,
      };
    });
  }

  void countt() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;int j=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      taskk = i;
    });
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks").where("status",isEqualTo: "Active")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        j = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      taskk1 = i;
    });
    setState(() {
      dataMap2 = {
        "Active Task":j.toDouble(),
        "InActive Task": (i-j).toDouble(),
      };
    });
  }
  int taskk=0;
  int taskk1=0;
  void countt1() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    DateTime currentDate = DateTime.now();
    String formattedDate = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks").where("status",isEqualTo: "High")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      taskk1 = i;
    });
  }
  void counth() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Health")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      healthcount = i;
    });
  }
  int healthcount = 0;
  int people=0;
  int people1=0;
  void initState(){
    counth();
    countt();
    countp1();
    counttrain();
  }
  late Map<String, double> dataMap1 ;
  late Map<String, double> dataMap2 ;

  Widget se(String asset,String name)=> Row(
    children: [
      SizedBox(width:9),
      Container(
        height: 40,width: 40,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:Border.all(
                color: Colors.blue,
                width: 2
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
              asset,
              semanticsLabel: 'Acme Logo'
          ),
        ),
      ),
      SizedBox(width:9),
      Text(name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 20)),
    ],
  );
  int trainingp=0;
  void counttrain() async {
    UserModel? _user = Provider.of<UserProvider>(context,listen: false).getUser;
    int count = 0; int i=0;
    await FirebaseFirestore.instance
        .collection('Company').doc(_user!.source).collection("Tasks")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;
      setState(() {
        i = querySnapshot.docs.length;
      });
      print("Number of documents with in the 'Present' array: $count");
    }).catchError((error) {
      print("Error counting documents: $error");
    });
    setState(() {
      trainingp = i;
    });
  }
  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.width - 30;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("KPIs",style:TextStyle(color:Colors.white,fontSize: 23)),
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
            SizedBox(height:15),
            se("assets/calender-day-love-svgrepo-com.svg","Today Attendance"),
            SizedBox(height:15),
            PieChart(
              dataMap: dataMap1,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Employees",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage:false,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
            SizedBox(height:15),
            se("assets/calender-day-love-svgrepo-com.svg","Tasks"),
            SizedBox(height:15),
            PieChart(
              dataMap: dataMap2,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Tasks",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage:false,
                showChartValuesOutside: true,
                decimalPlaces: 0,
              ),
              // gradientList: ---To add gradient colors---
              // emptyColorGradient: ---Empty Color gradient---
            ),
            SizedBox(height:25),
            se("assets/calender-day-love-svgrepo-com.svg","Training & Health"),
            SizedBox(height:15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                c(d," Training",trainingp.toString(), Icon(Icons.pan_tool_rounded,size:d/22,color:Colors.white),2),
                c(d," Health Benefits","$healthcount", Icon(Icons.health_and_safety,size:d/22,color:Colors.white),3),
              ],
            ),
            SizedBox(height:17),
            SizedBox(height:25),
            se("assets/calender-day-love-svgrepo-com.svg","Budgets"),
            SizedBox(height:15),
            Container(
                height: 600,
                child: Expense_C(user: widget.user,hideAppBar: true,)),
          ],
        ),
      ),
    );
  }

  Widget c(double d,String str,String uiop,Widget tyu,int  kk){
    return Container(
        width: ((d+30)/2)-40,
        height:60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:tyuu(kk),
        ),
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                  children:[
                    tyu,
                    Text(str,style:TextStyle(fontSize: d/29,fontWeight: FontWeight.w500,color:Colors.white)),
                  ]
              ),
              Text(uiop.toString(),style:TextStyle(fontSize: d/17,fontWeight: FontWeight.w800,color:Colors.white)),
            ],
          ),
        )
    );
  }
  Color tyuu(int kk){
    if(kk==0){
      return Colors.purpleAccent;
    }else if(kk==1){
      return Colors.green;
    }else if(kk==2){
      return Colors.deepOrange;
    }else {
      return Colors.blueAccent;
    }
  }

}
