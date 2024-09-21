import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:zeit/cards/profile_organisation.dart';
import 'package:zeit/model/organisation.dart';

class ViewCompanies extends StatefulWidget {
  bool view;
   ViewCompanies({super.key,required this.view});

  @override
  State<ViewCompanies> createState() => _ViewCompaniesState();
}

class _ViewCompaniesState extends State<ViewCompanies> {
  List<OrganisationModel> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View all Organisation"),
        actions: [
          IconButton(onPressed: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350,
                  child: SizedBox(
                    height: 350,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  <Widget>[
                          SizedBox(
                            height: 14,
                          ),
                          Container(height: 8,width: 100,decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue
                          ),),
                          SizedBox(height: 20,),
                          ListTile(
                            onTap: (){
                              setState((){
                                on=true;
                              });
                              Navigator.pop(context);
                            },
                            leading: Icon(Icons.all_inclusive),
                            title: Text("All Organisations",style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
                            subtitle: Text("View all Organisations without Filter"),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                          r("Approve",Icon(Icons.thumb_up_alt_rounded,color:Colors.green)),
                          r("Clarification Needed",Icon(Icons.wifi_tethering_error_outlined,color:Colors.orange)),
                          r("Block",Icon(Icons.thumb_down,color:Colors.red)),
                          SizedBox(height:10)
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }, icon: Icon(Icons.filter_alt_sharp))
        ],
      ),
      body:StreamBuilder(
        stream: on?FirebaseFirestore.instance
            .collection('Company')
            .snapshots():FirebaseFirestore.instance
            .collection('Company').where("status",isEqualTo: st)
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
                    "No Organisation found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Looks likes no Company found with this Filter",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          }
          final data = snapshot.data?.docs;
          _list.clear();
          _list.addAll(data?.map((e) => OrganisationModel.fromJson(e.data())).toList() ?? []);
          return ListView.builder(
            itemCount: _list.length,
            padding: EdgeInsets.only(top: 10),
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return OUser(user: _list[index],view:widget.view );
            },
          );
        },
      ),
    );
  }
bool on = true;
  String st="";
  Widget r(String str,Widget rt){
    return ListTile(
      onTap: (){
        setState((){
          on=false;
          st=str;
        });
        Navigator.pop(context);
      },
      leading: rt,
      title: Text(str,style:TextStyle(fontSize: 20,fontWeight: FontWeight.w800)),
      subtitle: Text("View all ${str}ed Organisation with Filter"),
      trailing: Icon(Icons.arrow_forward_ios),
    );
  }
}

class OUser extends StatelessWidget {
  OrganisationModel user;
  bool view;
  OUser({super.key,required this.view,required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  PageTransition(
                      child: ProO(user: user,),
                      type: PageTransitionType.bottomToTop,
                      duration: Duration(milliseconds: 200)));
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.logo),
            ),
            title: Text(user.name,style:TextStyle(fontWeight: FontWeight.w800,fontSize: 19)),
            subtitle: Text(user.address),
            trailing: Icon(Icons.arrow_forward_ios_outlined,color:Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.only(left:15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.red,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("Status : "+user.status),
              ),
            ),
          ),
          Row(
            children: [
              rt("Approve",user.status),
              rt("Clarification Needed",user.status),
              rt("Block",user.status),
            ],
          ),
        ],
      ),
    );
  }
  Widget rt(String jh,String st){
    return InkWell(
        onTap : () async {
          await FirebaseFirestore.instance.collection("Company").doc(user.id).update({
            "status":jh,
          });
        }, child : Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
          decoration: BoxDecoration(
            color: st==jh ? Colors.blue : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(jh, style : TextStyle(fontSize: 16, color :  st == jh ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }
}
