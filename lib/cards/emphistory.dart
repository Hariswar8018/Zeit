import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zeit/model/emp_history.dart';

class Emphistory extends StatelessWidget {
  EmploymentHistory user ;
   Emphistory({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0,right:15,bottom:10),
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.blue,
            width: 1
          )
        ),
        child: Column(
          children: [
            SizedBox(height: 15,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 15,),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://static.vecteezy.com/system/resources/previews/025/732/716/original/fiverr-logo-icon-online-platform-for-freelancers-free-vector.jpg"),
                    )
                  ),
                ),
                SizedBox(width: 12,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.posting,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                    Text(user.company+"  -  "+user.locationType,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
                    Text(user.location,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),),
                    Text(r(user.time1) + " to "+r(user.time2),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.grey),),
                    Text(calculateDateDifference(user.time1, user.time2),style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.grey),),
                    SizedBox(height: 15,),
                    Text(user.description),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
  String r(String date) {
    try {
      DateFormat inputFormat = DateFormat('dd/MM/yyyy');
      DateFormat outputFormat = DateFormat('MM, yyyy');

      DateTime dateTime = inputFormat.parse(date);
      return outputFormat.format(dateTime);
    }catch(e){
      return "08, 2022";
    }
  }
  String calculateDateDifference(String startDate, String endDate) {
    try {
      DateFormat dateFormat = DateFormat('dd/MM/yyyy');

      DateTime start = dateFormat.parse(startDate);
      DateTime end = dateFormat.parse(endDate);

      int yearDiff = end.year - start.year;
      int monthDiff = end.month - start.month;

      if (monthDiff < 0) {
        yearDiff--;
        monthDiff += 12;
      }

      return yearDiff.toString() + " year " + monthDiff.toString() +
          " month";
    }catch(e){
      return "1 year";
    }
  }
}
