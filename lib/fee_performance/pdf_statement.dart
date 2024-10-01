import 'package:flutter/material.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/pay.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
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

class Pdf_Statement extends StatelessWidget {
  Pdf_Statement({super.key,required this.u,required this.o});
  PayModel u;OrganisationModel o;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Payroll Statement",
            style: TextStyle(color: Colors.white, fontSize: 23)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Center(child: Icon(
                Icons.arrow_back_rounded, color: Color(0xff1491C7), size: 22,)),
            ),
          ),
        ),
      ),
      body: ExportFrame(
        frameId: 'someFrameId',
        exportDelegate: exportDelegate,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.greenAccent,
                  width: 1
              )
          ),
          width: w, height: w * 1.35,
          child: Column(
            children: [
              Container(
                color: Color(0xff00CE9D),
                width: w,
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(o.logo),
                      radius: w / 14,
                    ),
                    SizedBox(width: 12,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.name, style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: w / 26)),
                        Text(o.desc, style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: w / 34)),
                        Text("Phone no. : " + o.phone,
                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: w / 34)),
                      ],
                    )
                  ],
                ),
              ),

              Container(
                width: w,
                height: 6,
                color: Colors.black,
              ),
              s(),
              Text("PAYROLL STATEMENT", style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: w / 22,
                  wordSpacing: 2,
                  letterSpacing: 5)),
              s(), s(),
              r(w, "Name", u.name, "Date", fo(u.id)),
              r(w, "Status", u.status, "Designation", u.position),
              s(),
              Container(
                color: Color(0xff00CE9D),
                width: w - 30,
                height: 20,
                child: Row(
                  children: [
                    Container(
                        width: w / 2 - 20,
                        child: Text("  Date & Time", style: TextStyle(
                            color: Colors.white, fontSize: w / 30))),
                    Container(
                        width: 70,
                        child: Text("  Category", style: TextStyle(
                            color: Colors.white, fontSize: w / 30))),
                    Spacer(),
                    Text("  Amount   ", style: TextStyle(
                        color: Colors.white, fontSize: w / 30)),
                  ],
                ),
              ),
              a1(w, "Basic Salary", u.basic),
              a1(w, "Monthly Salary", u.monthly),
              a1(w, "Basic Allowance", u.allowance),
              a1(w, "Overtime Pay", u.overtime),
              a1(w, "Other Payment", u.other),
              s(),
              a1(w, "Stautory Deduction", u.statuatory),
              a1(w, "Loan Deduction", u.loan),
              a1(w, "Pension Deduction", u.pension),
              a1(w, "Other Deduction", u.payment),
              s(),
              Container(
                color: Colors.greenAccent.shade100,
                width: w - 30,
                height: 20,
                child: Row(
                  children: [
                    Container(
                        width: w / 2 - 20,
                        child: Text("  Total Net Pay", style: TextStyle(
                            color: Colors.black, fontSize: w / 30))),
                    Spacer(),
                    Text("  ${u.net}   ", style: TextStyle(
                        color: Colors.black, fontSize: w / 30)),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  ss(),
                  ss(),
                  Text("Thanks", style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: w / 28)),
                  Spacer(),
                ],
              ),
              Container(
                color: Color(0xff00CE9D),
                width: w - 40,
                height: 5,
              ),
              s(),
              s(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Download as PDF' ,
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try{
                final ExportOptions overrideOptions = ExportOptions(
                  textFieldOptions: TextFieldOptions.uniform(
                    interactive: false,
                  ),pageFormatOptions:  PageFormatOptions.custom(width: w, height: w*1.35,
                    clip: true,marginAll: 0,marginBottom: 0,marginLeft: 0,marginRight: 0,marginTop: 0),
                  checkboxOptions: CheckboxOptions.uniform(
                    interactive: false,
                  ),
                );
                final pdf = await exportDelegate.exportToPdfDocument(
                    "someFrameId",
                    overrideOptions: overrideOptions);
                final filePath = await saveFile(pdf, u.name+ "_Transaction Slip");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Success ! File saved on Android>Data>com.starwish.student>data>'+u.name+ "_Transaction Slip"),
                  ),
                );
              }catch(e){
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${e}'),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
  String fo(String ii){
    try {
      int n = int.parse(ii);
      DateTime da = DateTime.fromMicrosecondsSinceEpoch(n);
      String h = DateFormat('dd/MM/yy \'on\' HH:mm').format(da);
      return h;
    }catch(e){
      return "Unknown";
    }
  }

  final ExportDelegate exportDelegate = ExportDelegate();
  Future<String?> saveFile( document, String name) async {
    try {
      final Directory? dir = await getExternalStorageDirectory();
      if (dir != null) {
        final String downloadsPath = '${dir.path}';
        final String filePath = '$downloadsPath/$name.pdf';

        final File file = File(filePath);
        await file.writeAsBytes(await document.save());

        debugPrint('Saved exported PDF at: $filePath');
        return filePath;
      } else {
        debugPrint('Could not access external storage directory.');
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }
  Widget r(double w,String s,String s2, String s3, String s4){
    return  Row(
      children: [
        ss(),
        ss(),
        t1(w,"$s - "+s2),
        Spacer(),
        t1(w,"$s3 - "+s4),
        ss(),
        ss(),
      ],
    );
  }
  int i=1;
  Widget  a1(double w,String str1,double str2){
    i+=1;
    return  Container(
      color:i%2==0?Colors.white:Colors.grey.shade50,
      width: w-30,
      height: 20,
      child: Row(
        children: [
          Container(
              width:w/2-20,
              child: Text("  $str1",style:TextStyle(color: Colors.black,fontSize: w/30))),
          Spacer(),
          Text("  ${str2}   ",style:TextStyle(color: Colors.black,fontSize: w/30)),
        ],
      ),
    );
  }
  Widget s()=>SizedBox(height:10);
  Widget ss()=>SizedBox(width:10);
  Widget t1(double w,String s)=>Text(s,style:TextStyle(fontWeight:FontWeight.w400,fontSize: w/29));
}


class I_Statement extends StatelessWidget {
  I_Statement({super.key,required this.u,required this.o});
  PayModel u;OrganisationModel o;
  final GlobalKey boundaryKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1491C7),
        title: Text("My Payroll Statement",style:TextStyle(color:Colors.white,fontSize: 23)),
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
      body: RepaintBoundary(
        key: boundaryKey,
        child: Container(
          decoration: BoxDecoration(
              color:Colors.white,
              border: Border.all(
                  color: Colors.greenAccent,
                  width: 1
              )
          ),
          width: w,height: w*1.35,
          child: Column(
            children: [
              Container(
                color:Color(0xff00CE9D),
                width: w,
                height: 80,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 10,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(o.logo),
                      radius: w/14,
                    ),
                    SizedBox(width: 12,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(o.name,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w900,fontSize: w/27)),
                        Text(o.address,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w600,fontSize: w/31)),
                        Text("Phone no. : "+o.phone,style:TextStyle(color:Colors.white,fontWeight: FontWeight.w800,fontSize: w/32)),
                      ],
                    )
                  ],
                ),
              ),

              Container(
                width: w,
                height: 6,
                color:Colors.black,
              ),
              s(),
              Text("PAYROLL STATEMENT",style:TextStyle(fontWeight:FontWeight.w800,fontSize: w/22,wordSpacing: 2,letterSpacing: 5)),
              s(),s(),
              r(w,"Name",u.name,"Date", fo(u.id)),
              r(w,"Status",u.status,"Designation",u.position),
              s(),
              Container(
                color:Color(0xff00CE9D),
                width: w-30,
                height: 20,
                child: Row(
                  children: [
                    Container(
                        width:w/2-20,
                        child: Text("  Date & Time",style:TextStyle(color: Colors.white,fontSize: w/30))),
                    Container(
                        width:70,
                        child: Text("  Category",style:TextStyle(color: Colors.white,fontSize: w/30))),
                    Spacer(),
                    Text("  Amount   ",style:TextStyle(color: Colors.white,fontSize: w/30)),
                  ],
                ),
              ),
              a1(w, "Basic Salary", u.basic),
              a1(w, "Monthly Salary", u.monthly),
              a1(w, "Basic Allowance", u.allowance),
              a1(w, "Overtime Pay", u.overtime),
              a1(w, "Other Payment", u.other),
              s(),
              a1(w, "Stautory Deduction", u.statuatory),
              a1(w, "Loan Deduction", u.loan),
              a1(w, "Pension Deduction", u.pension),
              a1(w, "Other Deduction", u.payment),
              s(),
              Container(
                color:Colors.greenAccent.shade100,
                width: w-30,
                height: 20,
                child: Row(
                  children: [
                    Container(
                        width:w/2-20,
                        child: Text("  Total Net Pay",style:TextStyle(color: Colors.black,fontSize: w/30))),
                    Spacer(),
                    Text("  ${u.net}   ",style:TextStyle(color: Colors.black,fontSize: w/30)),
                  ],
                ),
              ),
              Spacer(),
              Row(
                children: [
                  ss(),
                  ss(),
                  Text("Thanks",style:TextStyle(fontWeight:FontWeight.w800,fontSize: w/28)),
                  Spacer(),
                ],
              ),
              Container(
                color:Color(0xff00CE9D),
                width: w-40,
                height: 5,
              ),
              s(),
              s(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SocialLoginButton(
            backgroundColor: Color(0xff50008e),
            height: 40,
            text: 'Download JPEG',
            borderRadius: 20,
            fontSize: 21,
            buttonType: SocialLoginButtonType.generalLogin,
            onPressed: () async {
              try {
                var status = await Permission.storage.request();
                if (!status.isGranted) {
                  Send.message(context, "Permission denied", false);
                  print("Permission denied");
                  return;
                }

                RenderRepaintBoundary boundary = boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
                ui.Image image = await boundary.toImage(pixelRatio: 3.0); // Adjust pixel ratio for higher quality
                ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List pngBytes = byteData!.buffer.asUint8List();

                // Save the image to the gallery using image_gallery_saver_plus
                final result = await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100, name: "payroll_statement");
                print(result); // Check if saving is successful
                Send.message(context, "$result", true);
              } catch (e) {
                Send.message(context, "$e", false);
                print("Error capturing and saving image: $e");
              }
            },
          ),
        ),
      ],
    );
  }

  String fo(String ii){
    try {
      int n = int.parse(ii);
      DateTime da = DateTime.fromMicrosecondsSinceEpoch(n);
      String h = DateFormat('dd/MM/yy \'on\' HH:mm').format(da);
      return h;
    }catch(e){
      return "Unknown";
    }
  }

  Widget r(double w,String s,String s2, String s3, String s4){
    return  Row(
      children: [
        ss(),
        ss(),
        t1(w,"$s - "+s2),
        Spacer(),
        t1(w,"$s3 - "+s4),
        ss(),
        ss(),
      ],
    );
  }
  int i=1;
  Widget  a1(double w,String str1,double str2){
    i+=1;
    return  Container(
      color:i%2==0?Colors.white:Colors.grey.shade50,
      width: w-30,
      height: 20,
      child: Row(
        children: [
          Container(
              width:w/2-20,
              child: Text("  $str1",style:TextStyle(color: Colors.black,fontSize: w/30))),
          Spacer(),
          Text("  ${str2}   ",style:TextStyle(color: Colors.black,fontSize: w/30)),
        ],
      ),
    );
  }
  Widget s()=>SizedBox(height:10);
  Widget ss()=>SizedBox(width:10);
  Widget t1(double w,String s)=>Text(s,style:TextStyle(fontWeight:FontWeight.w400,fontSize: w/29));
}
