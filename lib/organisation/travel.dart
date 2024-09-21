import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/add/add_travel.dart';
import 'package:zeit/functions/search.dart';
import 'package:zeit/model/usermodel.dart';

class TravelC extends StatelessWidget {
   TravelC({super.key,required this.id});String id;
  List<Travel> _list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("View Travel Events",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        stream: FirebaseFirestore.instance
            .collection('Company').doc(id).collection("Travel")
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
                  Icon(Icons.verified_outlined, color : Colors.red),
                  SizedBox(height: 7),
                  Text(
                    "No Travel Application found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Travel Application had been achieved by HR",
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
              Travel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Trav(user: _list[index],id:id );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context,
              PageTransition(
                  child: TravelWidget(),
                  type: PageTransitionType.rightToLeft,
                  duration: Duration(milliseconds: 200)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class Trav extends StatelessWidget {
  Travel user;String id;
   Trav({super.key,required this.id,required this.user});

  @override
  Widget build(BuildContext context) {
    double d=MediaQuery.of(context).size.width;
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            PageTransition(
                child: ChatUP(user:user),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200)));
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 140,
              width: d,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                  topRight: Radius.circular(10)
                ),
                image: DecorationImage(
                  image: NetworkImage(user.pic),
                  fit: BoxFit.cover
                )
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.train,color: Colors.white,),
              ),
              title: Text(user.name,style: TextStyle(fontWeight: FontWeight.w800),),
              subtitle: Text("From "+user.startdate+" to "+user.enddate),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatUP extends StatefulWidget {
  Travel user;
  ChatUP({super.key,required this.user});

  @override
  State<ChatUP> createState() => _ChatUPState();
}

class _ChatUPState extends State<ChatUP> {

  int active =0;
  @override
  Widget build(BuildContext context) {
    double d=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap:()=>Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Center(child: Icon(Icons.arrow_back_rounded,color:Colors.white,size: 18,)),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: d,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.user.pic),
                    fit: BoxFit.cover
                  )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.user.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 23),),
                  SizedBox(height: 10,),
                  Text("Start Date : "+widget.user.startdate,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800),),
                  Text("End Date : "+widget.user.enddate,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800),),
                  Container(
                    height: 51, width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      itemCount:4,scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int qIndex) {
                        return InkWell(
                          onTap: (){
                            setState((){
                              active = qIndex ;
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ayu(qIndex)
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                  ),
                  SizedBox(height:10),
                  mnu(active),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  mnu(int i){
    if(i==0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          t1("Travel Details"),
          h1("Key Details About Travel"),
          SizedBox(height:10),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.local_library_rounded,color:Colors.red),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Country", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.country),
                    )),
                  ],
                ),
              ],
            ),
          ),w2(),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_city,color:Colors.green),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("City", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200, // Background color of the container
                              borderRadius: BorderRadius.circular(10.0), // Rounded corners
                            ),child: Padding(
                          padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                          child: Text(widget.user.city),
                        )),
                        SizedBox(width:9),

                      ],
                    ),
                    SizedBox(height: 5,),
                  ],
                ),
              ],
            ),
          ),w2(),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on,color:Colors.blue),
                SizedBox(width:9),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Location", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                    Container(decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color of the container
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),child: Padding(
                      padding: const EdgeInsets.only(top:5.0,bottom:5,left:9,right:9),
                      child: Text(widget.user.location),
                    )),
                  ],
                ),
              ],
            ),
          ),
          w1(),

          sr(),
          t1("Flight Details"),
          w1(),
          Row(
            children: [
              Icon(Icons.accessible_forward,color:Colors.purpleAccent),
              Text(" Travel Mode : "+widget.user.flmode)
            ],
          ),
          Row(
            children: [
              Icon(Icons.numbers,color:Colors.tealAccent),
              Text(" Travel Number : "+widget.user.flno)
            ],
          ),
          sr(),
          t1("Flight Details"),
          w1(),
          Row(
            children: [
              Icon(Icons.meeting_room,color:Colors.pink),
              Text(" Room Type : "+widget.user.roomType)
            ],
          ),
          sr(),
          t1("Other Details"),
          w1(),
          Row(
            children: [
              Icon(Icons.paypal_sharp,color:Colors.deepPurpleAccent),
              Text(" Passport Needed : "+ (widget.user.passport ?"Yes":"No")),
            ],
          ),
          Row(
            children: [
              Icon(Icons.supervisor_account,color:Colors.orange),
              Text(" Visa Needed : "+ (widget.user.visa ?"Yes":"No")),
            ],
          ),
          SizedBox(height:15)
        ],
      );
    }else if(i==1){
      return Text(widget.user.descri);
    }else if(i==2){
    List<UserModel> _list = [];
    return  Container(
    width: MediaQuery.of(context).size.width,
    height: 400,
    child:  StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Users').where("jobfollower",arrayContains: "Travel"+widget.user.id)
        .snapshots() ,
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
    Text(
    "No Employees found",
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ),
    Text(
    "Looks likes we can't find any peers",
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    SizedBox(height: 10),
    ],
    ),
    );
    }

    final data = snapshot.data?.docs;
    _list.clear();
    _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);

    return GridView.builder(
    itemCount: _list.length,
    padding: EdgeInsets.only(top: 10),
    physics: BouncingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Number of columns
    ),
    itemBuilder: (context, index) {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ChatUser(user: _list[index]),
    );
    },
    );
    },
    )
    );
    }else {
    List<UserModel> _list = [];
    return  Container(
    width: MediaQuery.of(context).size.width,
    height: 400,
    child:  StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection('Users').where("jobfollower2",arrayContains: "Travel"+widget.user.id)
        .snapshots() ,
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
    Text(
    "No Employees completed",
    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    ),
    Text(
    "No Employees who have completed your Task",
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
    SizedBox(height: 10),
    ],
    ),
    );
    }

    final data = snapshot.data?.docs;
    _list.clear();
    _list.addAll(data?.map((e) => UserModel.fromJson(e.data())).toList() ?? []);

    return GridView.builder(
    itemCount: _list.length,
    padding: EdgeInsets.only(top: 10),
    physics: BouncingScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // Number of columns
    ),
    itemBuilder: (context, index) {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ChatUser(user: _list[index]),
    );
    },
    );
    },
    )
    );
    }
  }
  Widget sr(){
    return Column(
        children:[
          w1(),
          Divider(
            thickness: 0.5,
          ),
          SizedBox(height:10),
        ]
    );
  }
  Widget ayu(int i ){
    return Container(
      child :  Column(
        children: [
          Text(ga(i), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color : Colors.black),),
          active == i ? Container(
            height: 5,  width: 24, decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(70)
          ),
          ) : SizedBox(width : 2)
        ],
      ),
    );
  }
  String ga(int i){
    if ( i == 0 ){
      return "Overview";
    }else if ( i == 1){
      return "Decription";
    }else if ( i == 2){
      return "Employees";
    }else if ( i == 3){
      return "Completed";
    }else if ( i == 4){
      return "Employment History";
    }else if ( i == 5){
      return "Travel Requests";
    }else {
      return "Other";
    }
  }

  Widget w1()=>SizedBox(height:10);

  Widget w2()=>SizedBox(height:20);

  Widget t1(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w600,fontSize: 24),);

  Widget t2(String s1)=>  Text(s1, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),);

  Widget h1(String s2)=>Text(s2, style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),);
}
