import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:zeit/model/organisation.dart';

import '../update/update_user.dart';

class Expense_C extends StatelessWidget {
  final OrganisationModel user;
  final bool hideAppBar; // Optional boolean parameter
  Expense_C({super.key, required this.user,this.hideAppBar = false});

  @override
  Widget build(BuildContext context) {
    // Get the current month (1 = January, 12 = December)
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;

    // Function to retrieve the value of c1 to c12 dynamically
    double getMonthData(int month) {
      switch (month) {
        case 1:
          return user.c1;
        case 2:
          return user.c2;
        case 3:
          return user.c3;
        case 4:
          return user.c4;
        case 5:
          return user.c5;
        case 6:
          return user.c6;
        case 7:
          return user.c7;
        case 8:
          return user.c8;
        case 9:
          return user.c9;
        case 10:
          return user.c10;
        case 11:
          return user.c11;
        case 12:
          return user.c12;
        default:
          return 0.0;
      }
    }

    // Create a list to store the last 6 months' data
    List<SalesData> lastSixMonthsData = [];
    for (int i = 0; i < 6; i++) {
      int month = (currentMonth - i) <= 0 ? (12 + (currentMonth - i)) : (currentMonth - i);
      String monthName = getMonthName(month);
      lastSixMonthsData.add(SalesData(monthName, getMonthData(month)));
    }

    // Calculate the mean and highest values
    double total = lastSixMonthsData.fold(0.0, (sum, item) => sum + item.sales);
    double mean = total / lastSixMonthsData.length;
    // Identify the month with the highest value
    SalesData highestData = lastSixMonthsData.reduce((a, b) => a.sales > b.sales ? a : b);
    double highest = highestData.sales;
    String highestMonth = highestData.year;

    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: hideAppBar ? null : AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("Metrics", style: TextStyle(color: Colors.white, fontSize: 23)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xff1491C7),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            /*Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <LineSeries<SalesData, String>>[
                    LineSeries<SalesData, String>(
                      dataSource: lastSixMonthsData.reversed.toList(),
                      xValueMapper: (SalesData sales, _) => sales.year,
                      yValueMapper: (SalesData sales, _) => sales.sales,
                    ),
                  ],
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 25,top: 10),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: DChartBarO(
                  groupList: [
                    OrdinalGroup(
                      id: '1',
                      data: lastSixMonthsData.map((data) {
                        return OrdinalData(domain: data.year, measure: data.sales);
                      }).toList(),
                    ),
                  ],
                  // Customize the appearance and other properties as needed
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.2
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  width: w,height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Total Budget ( Monthly Budget )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Text("+ ₹ ${user.budget} ",style: TextStyle(
                                fontWeight: FontWeight.w800,color: Colors.green,fontSize: 25
                            ),),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context, PageTransition(
                                    child: Update(Name: 'Monthly Budget', doc: user.uid, Firebasevalue: 'budget', Collection: 'Company', ), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                                ));
                              },
                              child: Container(
                                height: 20,width: 20,
                                color: Colors.green,
                                child: Icon(Icons.edit,color: Colors.white,size: 10,),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 3,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 8),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.2
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  width: w,height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Total Cost ( This Month )",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Text("- ₹ ${getMonthData(DateTime.now().month)} ",style: TextStyle(
                                fontWeight: FontWeight.w800,color: Colors.red,fontSize: 25
                            ),),
                          ],
                        ),
                        Row(
                          children: [
                            Spacer(),
                            Text("Left over : ₹ ${(user.budget-getMonthData(DateTime.now().month))} ",style: TextStyle(
                                fontWeight: FontWeight.w800,color: Colors.red,fontSize: 15
                            ),),
                          ],
                        ),
                        SizedBox(height: 3,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.grey,
                          width: 0.2
                      ),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  width: w,height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" Total Last 6 Months Cost",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 21),),
                        Spacer(),
                        Row(
                          children: [
                            Spacer(),
                            Text("- ₹ $total ",style: TextStyle(
                                fontWeight: FontWeight.w800,color: Colors.red,fontSize: 25
                            ),),
                          ],
                        ),
                        SizedBox(height: 3,)
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8,bottom: 15),
              child: Container(
                height: 250,width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black,
                    ),color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:14.0),
                          child: Icon(Icons.timer_rounded,color:Colors.blue),
                        ),
                        Text("This Month",style: TextStyle(color: Colors.blue),)
                      ],
                    ),
                    io("This Month Cost",getMonthData(DateTime.now().month),true,0),
                    io("Total Days",30,false,0),
                    io("Per Day Cost",getMonthData(DateTime.now().month)/30,true,4),
                    SizedBox(height: 9,),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:14.0),
                          child: Icon(Icons.timeline_sharp,color:Colors.red),
                        ),
                        Text("Last 6 Month",style: TextStyle(color: Colors.red),)
                      ],
                    ),
                    io("Last 6 Month days", 180,false,0),
                    io("Per Day Cost on Company", mean/180,true,4),
                    io("Highest Cost ( by Month )", highest,true,0),
                    Padding(
                      padding: const EdgeInsets.only(bottom:9.0,left:15,right:15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Highest Costing Month : "),
                          Text(highestMonth),
                        ],
                      ),
                    ),
                    SizedBox(width: 9,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget io(String h, double h2, bool fneeded,int i){
    late String de;
    return Padding(
      padding: const EdgeInsets.only(bottom:9.0,left:15,right:15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$h : "),
          Text( (!fneeded? "":"₹ ")+(h2.toStringAsFixed(i)).toString()),
        ],
      ),
    );
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
