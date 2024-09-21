import 'dart:typed_data' as lk ;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zeit/functions/flush.dart';
import 'package:zeit/main.dart';
import 'package:zeit/main_pages/navigation.dart';
import 'package:zeit/model/organisation.dart';
import 'package:zeit/model/usermodel.dart'  ;
import 'package:zeit/provider/upload.dart';
import 'package:im_stepper/stepper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';


class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step1State();
}

class _Step1State extends State<Step2> {

  List l5 = [];
  String drinkk = " ", smoke = " ", goall = " ", gen = " " , looki = " ", pic = " ";
  TextEditingController name = TextEditingController();
  TextEditingController bday = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController pan = TextEditingController();
  TextEditingController tan = TextEditingController();
  TextEditingController uid = TextEditingController();

  int activeStep = 0;
  int upperBound = 3;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff1491C7),
          title: Text("Make an Organisation",style:TextStyle(color:Colors.white,fontSize: 23)),
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              IconStepper(
                icons: [
                  Icon(Icons.face, color : activeStep == 0 ? Colors.white : Colors.black),
                  Icon(Icons.work, color : activeStep == 1 ? Colors.white : Colors.black),
                  Icon(Icons.info, color : activeStep == 2 ? Colors.white : Colors.black),
                  Icon(Icons.phone_android, color : activeStep == 3 ? Colors.white : Colors.black),
                ],
                activeStep: activeStep,stepColor: Colors.grey.shade200, activeStepColor:Colors.blue ,
                onStepReached: (index) {
                  setState(() {
                    activeStep = index;
                  });
                },
              ),
              header(),
              s(context),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  previousButton(),
                  nextButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget s(BuildContext context){
    switch (activeStep) {
      case 1:
        return r2(context);
      case 2 :
        return r4(context);
      case 3 :
        return r5(context);
      default:
        return r1(context);
    }
  }
  /// Returns the next button.
  Widget nextButton() {
    return InkWell(
      onTap: ()  async {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (activeStep < upperBound) {
          setState(() {
            activeStep ++ ;
          });
        }else {
          CollectionReference usersCollection = FirebaseFirestore.instance.collection('Company');
          String hk = FirebaseAuth.instance.currentUser!.uid ;
          print("No");
          try {
            OrganisationModel h = OrganisationModel(name: name.text, logo: pic,
                pan: pan.text, tan: tan.text, uid: uid.text,
                id: hk, type: gen, admin: [hk],
                hr: [], subadmin: [],
                phone: phone.text, email: email.text,
                address: address.text, incor: uid.text, bday: _singleDatePickerValueWithDefaultValue[0].toString(), pic1: '',
                people: [hk], desc: '', labourlink: '', comcases: '', compolicy: '', lawname: '', lawphone: '', lawemail: '', status: 'Waiting for Approval', 
                c1: 0.0, c2: 0.0, c3: 0.0, c4: 0.0, c6: 0.0, c5: 0.0,
                c7: 0.0, c8: 0.0, c9: 0.0, c10: 0.0, c11: 0.0, c12: 0.0, budget: 0.0, lat: 22.9, long: 23.97,
            );
            await FirebaseFirestore.instance.collection("Users").doc(hk).update({
              "type" : 'Organisation',
              "source":hk,
            });
            await usersCollection.doc(hk).set(h.toJson());
            Navigator.push(
                context, PageTransition(
                child: MyHomePage(title: 'hh',), type: PageTransitionType.rightToLeft, duration: Duration(milliseconds: 800)
            ));
            Send.message(context, "Your Organisation Account created", true);
            print("gh");
          } catch (e) {
            Send.message(context, "${e}", true);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Container(
              width : MediaQuery.of(context).size.width - 100, height : 60,
              decoration: BoxDecoration(
                color: Colors.blue , // Background color of the container
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(activeStep < upperBound?"Continue  ":"Submit   ", style : TextStyle( color : Colors.white)),
                  Icon(Icons.arrow_forward,  color : Colors.white),
                ],
              )
          ),
        ),
      ),
    );
  }
  Widget r4(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("When's your Organisation Incorporated?"),
          SizedBox(height : 18),
          _buildCalendarDialogButton(),
          SizedBox(height : 10),
          t1("Your Company type ?"),
          SizedBox(height : 4),
          Row(
            children: [
              rtn("LLP", 3), rtn("Private Limited", 3), rtn ("Public Limited", 3)
            ],
          ),
          Row(
            children: [
              rtn("Sole Priortor", 3), rtn("Private SPC", 3),
            ],
          ),
          SizedBox(height : 10),
        ],
      ),
    );
  }
  Widget r5(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height : 10),
          t1("Your Company Incorporation ID ?"),
          SizedBox(height : 7),
          t2("Required for Company Verification"),
          SizedBox(height : 18),
          sd(uid, context),
          SizedBox(height : 10),
          t1("Your Company Tan & Pan"),
          SizedBox(height : 7),
          t2("Tan Card of your Company"),
          SizedBox(height : 18),
          sd(pan, context),
          SizedBox(height : 7),
          t2("Pan Card of your Company"),
          sd(tan, context),
        ],
      ),
    );
  }
  /// Returns the previous button.
  Widget previousButton() {
    return InkWell(
      onTap: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (activeStep > 0) {
          setState(() {
            activeStep--;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue ,
            child: Icon(Icons.arrow_back, color : Colors.white),
          ),
        ),
      ),
    );
  }

  /// Returns the header wrapping the header text.
  Widget header() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        headerText(),
        style: TextStyle(
          color: Colors.black, fontWeight: FontWeight.w200,
          fontSize: 20,
        ),
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Your Work / Qualification';

      case 2:
        return 'Your BMI';

      case 3:
        return 'Your Birthday';

      case 4:
        return 'Hobbies';

      case 5:
        return 'Smoking / Drinking';

      case 6:
        return 'Your Goal';

      default:
        return 'Personal Information';
    }
  }

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  bool up = false ;
  void a (){
    setState((){
      up = !up ;
    });
  }
  Widget r1(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("Name your Organisation"),
          SizedBox(height : 7),
          t2("Let's start with naming your Organisation ?"),
          SizedBox(height : 18),
          sd(name, context),
          t1("Your Logo"),
          t2("Making an Logo for Organisation is Important. Let's make it"),
          SizedBox(height : 7),
          up ? Center(
              child : CircularProgressIndicator()
          ) : InkWell(
            onTap: () async {
              a();
              try {
                lk.Uint8List? file = await pickImage(ImageSource.gallery);
                if (file != null) {
                  String photoUrl = await StorageMethods().uploadImageToStorage(
                      'Users', file, true);
                  setState(() {
                    pic = photoUrl;
                  });
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Logo Uploaded"),
                  ),
                );
              }catch(e){
                print(e);
              }
              a();
            },
            child: pic == " "? Container(
                height:  140, width:  140,
                color : Colors.grey.shade300,
                child : Icon(Icons.camera_alt)
            ) : Container(
              height:  140, width:  140,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(pic),
                    fit: BoxFit.cover,
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =  TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
    TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400] ,
      fontWeight: FontWeight.w700 ,
      decoration: TextDecoration.underline ,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.single,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle ;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle ,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              final values = await showCalendarDatePicker2Dialog(
                context: context,
                config: config,
                dialogSize: const Size(325, 400),
                borderRadius: BorderRadius.circular(15),
                value: _singleDatePickerValueWithDefaultValue ,
                dialogBackgroundColor: Colors.white,
              );
              if (values != null) {
                // ignore: avoid_print
                print(_getValueText(
                  config.calendarType,
                  values,
                ));
                // Format the DateTime in the desired format (DD/MM/YYYY)
                setState(() {
                  _singleDatePickerValueWithDefaultValue  = values;
                  DateTime? date = _singleDatePickerValueWithDefaultValue.first ;
                  String dateTimeString = date.toString(); // Replace with your DateTime string

                  // Convert DateTime string to DateTime
                  DateTime dateTime = DateTime.parse(dateTimeString);

                  // Format the DateTime in the desired format (DD/MM/YYYY)
                  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
                  bday = TextEditingController(text: formattedDate);
                });
              }
            },
            child: const Text('Choose Date of Incorporation'),
          ),
        ],
      ),
    );
  }
  bool teac = false ;
  Widget r2(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          t1("What's Organisation Contact Details"),
          SizedBox(height : 7),
          t2("Phone/Landline Number"),
          SizedBox(height : 18),
          sd1(phone, context, 10),
          SizedBox(height : 7),
          t2("Business Email "),
          SizedBox(height : 18),
          sd(email, context,),
          SizedBox(height : 7),
          t2("Address of Organisation"),
          SizedBox(height : 18),
          sd(address, context),
        ],
      ),
    );
  }
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];

  Widget rt(String jh){
    return InkWell(
        onTap : (){
          if(l5.contains(jh)){
            setState(() {
              l5.remove(jh);
            });
            print(l5);
          }else{
            setState(() {
              l5 = l5 + [jh];
            });
            print(l5);
          }
        }, child : Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: l5.contains(jh) ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(jh, style : TextStyle(fontSize: 19, color : l5.contains(jh) ? Colors.white : Colors.black )),
          )
      ),
    )
    );
  }

  Widget rtn(String jh, int i ){
    if ( i == 0 ){
      return InkWell(
          onTap : (){
            setState(() {
              smoke = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: smoke == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : smoke == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 1 ){
      return InkWell(
          onTap : (){
            setState(() {
              drinkk = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: drinkk == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : drinkk == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 2){
      return InkWell(
          onTap : (){
            setState(() {
              goall = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: goall == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : goall == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else if ( i == 3 ){
      return InkWell(
          onTap : (){
            setState(() {
              gen = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: gen == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : gen == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }else{
      return InkWell(
          onTap : (){
            setState(() {
              looki = jh ;
            });
          }, child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: looki == jh ? Color(0xff6A9D40) : Colors.grey.shade100, // Background color of the container
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            child : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(jh, style : TextStyle(fontSize: 19, color : looki == jh ? Colors.white : Colors.black )),
            )
        ),
      )
      );
    }

  }

  Widget t1(String g){
    return Text(g, style : TextStyle(fontSize: 27, fontWeight: FontWeight.w700));
  }
  Widget t2(String g){
    return Text(g, style : TextStyle(fontSize: 18, fontWeight: FontWeight.w300));
  }
  String _getValueText(CalendarDatePicker2Type datePickerType, List<DateTime?> values,) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
          .map((v) => v.toString().replaceAll('00:00:00.000', ''))
          .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
  Widget sd (TextEditingController cg,  BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',

                ),
              ),
            )
        ),
      ),
    );
  }
  Widget sd1 (TextEditingController cg,  BuildContext context, int yu){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width : MediaQuery.of(context).size.width  , height : 50,
        decoration: BoxDecoration(
          color: Colors.blue.shade50, // Background color of the container
          borderRadius: BorderRadius.circular(15.0), // Rounded corners
        ),
        child: Padding(
            padding: const EdgeInsets.only( left :10, right : 18.0, top : 5, bottom: 5),
            child: Center(
              child: TextFormField(
                controller: cg, maxLength: yu,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none, // No border
                  counterText: '',

                ),
              ),
            )
        ),
      ),
    );
  }
}
