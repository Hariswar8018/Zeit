import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/model/organisation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zeit/update/update_user.dart';

class LabourLaws extends StatefulWidget {
   LabourLaws({super.key,required this.user,required this.hr});
   OrganisationModel user;bool hr;

  @override
  State<LabourLaws> createState() => _LabourLawsState();
}

class _LabourLawsState extends State<LabourLaws> {
   bool on = false;

  @override
  Widget build(BuildContext context) {
    double d = MediaQuery.of(context).size.width -20;
    double h = MediaQuery.of(context).size.width -20;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Legal Compilances",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          SizedBox(height : 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:[
              InkWell(
                  onTap:()async{
                    final Uri _url = Uri.parse(widget.user.labourlink);
                    if (!await launchUrl(_url)) {
                    throw Exception('Could not launch $_url');
                    }
                  },
                  child: q(context,"assets/law-book-law-svgrepo-com.svg","Labour Laws","labourlink")),
              InkWell(
                  onTap:()async{
                    final Uri _url = Uri.parse(widget.user.comcases);
                    if (!await launchUrl(_url)) {
                      throw Exception('Could not launch $_url');
                    }
                  },
                  child: q(context,"assets/law-round-svgrepo-com.svg","Company Cases","comcases")),
            ]
          ),
          SizedBox(height : 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                InkWell(
                    onTap:()async{
                      final Uri _url = Uri.parse(widget.user.compolicy);
                      if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                      }
                    },
                    child: q(context,"assets/law-auction-svgrepo-com.svg","Company Policy","compolicy")),
                InkWell(
                    onTap:()async{
                      setState((){
                        on = !on;
                      });
                    },
                    child: q(context,"assets/police-station-svgrepo-com.svg","Law Officer","lawname")),
              ]
          ),
          SizedBox(height : 20),
          on?Container(
              width: d,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/police-station-svgrepo-com.svg",
                            semanticsLabel: 'Acme Logo',
                            height: 40,
                          ),
                          Text("Law Officer",style:TextStyle(fontSize: 20))
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          widget.hr?InkWell(
                            onTap: (){
                              Navigator.push(
                                  context, PageTransition(
                                  child: Update(Name: "Law Officer Name", doc: widget.user.uid, Firebasevalue: "lawname", Collection: 'Company', ),
                                  type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                  height:20,width:20,
                                  color: Colors.orangeAccent,
                                  child: Icon(Icons.edit,size: 15,color: Colors.white,)),
                            ),
                          ):SizedBox(),
                          Text("Name",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 17)),    Spacer(),
                          Text(widget.user.lawname,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 19)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          widget.hr?InkWell(
                            onTap: (){
                              Navigator.push(
                                  context, PageTransition(
                                  child: Update(Name: "Law Officer Phone", doc: widget.user.uid, Firebasevalue: "lawphone", Collection: 'Company', ),
                                  type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                  height:20,width:20,
                                  color: Colors.orangeAccent,
                                  child: Icon(Icons.edit,size: 15,color: Colors.white,)),
                            ),
                          ):SizedBox(),
                          Text("Phone",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 17)),    Spacer(),
                          Text(widget.user.lawphone,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 19)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          widget.hr?InkWell(
                            onTap: (){
                              Navigator.push(
                                  context, PageTransition(
                                  child: Update(Name: "Law Officer Email", doc: widget.user.uid, Firebasevalue: "lawemail", Collection: 'Company', ),
                                  type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                  height:20,width:20,
                                  color: Colors.orangeAccent,
                                  child: Icon(Icons.edit,size: 15,color: Colors.white,)),
                            ),
                          ):SizedBox(),
                          Text("Email",style:TextStyle(fontWeight: FontWeight.w500,fontSize: 17)),    Spacer(),
                          Text(widget.user.lawemail,style:TextStyle(fontWeight: FontWeight.w700,fontSize: 19)),
                        ],
                      ),
                      SizedBox(height: 10),
                    ]),
              )) : SizedBox(),
          ]
      )
    );
  }

  Widget q(BuildContext context, String asset, String str,String name1) {
    double d = MediaQuery.of(context).size.width / 2 - 30;
    double h = MediaQuery.of(context).size.width / 2 - 135;
    return Stack(
      children: [
        Container(
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
                ])),
        widget.hr?Container(
          width: d,height: d,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Spacer(),
            name1=="lawname"?SizedBox(height: 3,):Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context, PageTransition(
                      child: Update(Name: str, doc: widget.user.uid, Firebasevalue: name1, Collection: 'Company', ),
                      type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 200)
                  ));
                },
                child: CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    radius: 15,
                    child: Icon(Icons.edit,color: Colors.white,size: 15,)),
              ),
            ),
          ],),
        ):Container(
          width: d,
          height: d,
        )
      ],
    );
  }
}
