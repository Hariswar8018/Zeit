import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/pay.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert'; // for base64Encode
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyPdf extends StatefulWidget {
  String str;
  MyPdf({required this.str});
  @override
  _MyPdfState createState() => _MyPdfState();
}

class _MyPdfState extends State<MyPdf> {
  String? pdfFlePath;
  Future<String> downloadAndSavePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/sample.pdf');
    if (await file.exists()) {
      return file.path;
    }
    final response = await http.get(Uri.parse(widget.str));
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  void initState(){
    v();
  }
  v() async{
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Color(0xff1491C7),
            title: Text("My Pdf",style:TextStyle(color:Colors.white,fontSize: 23)),
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
          body: Center(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  child: Text("Load pdf"),
                  onPressed: (){
                    v();
                  },
                ),
                Container(
                    width: w,height: h-133,
                  child: SfPdfViewer.network(
                      widget.str),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class MyPic extends StatelessWidget {
  String link;
   MyPic({super.key,required this.link});
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Pdf",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        actions: [
          IconButton(onPressed: () async {

          }, icon: Icon(Icons.download,color: Colors.white,))
        ],
      ),
      body: RepaintBoundary(
        key: boundaryKey,
        child: Center(
          child: Image.network(link,width: MediaQuery.of(context).size.width,),
        ),
      ),
    );
  }
}
