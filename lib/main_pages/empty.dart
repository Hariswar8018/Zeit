import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zeit/functions/flush.dart';

import '../model/usermodel.dart';
import '../provider/declare.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? _user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network("https://cdn-icons-png.flaticon.com/512/7486/7486744.png",width:230),
          SizedBox(height: 7),
          Text(
            "No Zeit Account Exist for the User",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(textAlign:TextAlign.center,
              "You need to add your Account to a Organisation to access this Page",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(onPressed: (){
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 280,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 15),
                        Container(
                          width: 80, height: 10,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20)
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(textAlign: TextAlign.center,
                            "Company Exist in Zeit ▶️ ",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20)),
                        SizedBox(height: 9),
                        SizedBox(height: 9),
                        Text(textAlign: TextAlign.center,
                            "You could ask HR to add you to their Organisation by giving your ID. And you will be added Immediately",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18)),
                        SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Container(
                                width : MediaQuery.of(context).size.width , height : 60,
                                decoration: BoxDecoration(
                                  color: Color(0xffE9075B), // Background color of the container
                                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                                ),
                                child : InkWell(
                                  onTap: () {
                                    Clipboard.setData(
                                        new ClipboardData(text: "ZEIT"+_user!.uid));
                                    Navigator.pop(context);
                                    Send.message(context, "Copied to ClipBoard", true);
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child:Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.copy, color : Colors.white),
                                          SizedBox( width : 9),
                                          Text("ZEIT"+_user!.uid, style : TextStyle( fontSize : 17, color : Colors.white, fontWeight: FontWeight.w900)),
                                        ],
                                      )
                                  ),
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }, child: Text("My ID to share")),
          SizedBox(height: 10),
        ],
      ),
    );
  }
  void gj(BuildContext context) {


  }
}
