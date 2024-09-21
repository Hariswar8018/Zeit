import 'package:cloud_firestore/cloud_firestore.dart';

class OrganisationModel {
  OrganisationModel({
    required this.name,
    required this.logo,
    required this.pan,
    required this.tan,
    required this.uid,
    required this.id,
    required this.type,
    required this.admin,
    required this.hr,
    required this.subadmin,
    required this.phone,
    required this.email,
    required this.address,
    required this.incor,
    required this.bday,
    required this.pic1,
    required this.people,
    required this.desc,
    required this.labourlink,
    required this.comcases,
    required this.compolicy,
    required this.lawname,
    required this.lawphone,
    required this.lawemail,
    required this.status,
    required this.c1,
    required this.c2,
    required this.c3,
    required this.c4,
    required this.c5,
    required this.c6,
    required this.c7,
    required this.c8,
    required this.c9,
    required this.c10,
    required this.c11,
    required this.c12,
    required this.budget,
    required this.lat,
    required this.long,
  });

  late final String name;
  late final String logo;
  late final String pan;
  late final String tan;
  late final String uid;
  late final String id;
  late final String type;
  late final List admin;
  late final List hr;
  late final List subadmin;
  late final String phone;
  late final String email;
  late final String address;
  late final String incor;
  late final String bday;
  late final String pic1;
  late final List people;
  late final String desc;
  late final String labourlink;
  late final String comcases;
  late final String compolicy;
  late final String lawname;
  late final String lawphone;
  late final String lawemail;
  late final String status;
  late final double c1;
  late final double c2;
  late final double c3;
  late final double c4;
  late final double c5;
  late final double c6;
  late final double c7;
  late final double c8;
  late final double c9;
  late final double c10;
  late final double c11;
  late final double c12;
  late final double budget;
  late final double lat;
  late final double long;

  OrganisationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "Waiting for Approval";
    name = json['name'] ?? '';
    logo = json['logo'] ?? '';
    pan = json['pan'] ?? '';
    tan = json['tan'] ?? '';
    uid = json['uid'] ?? '';
    id = json['id'] ?? '';
    type = json['type'] ?? '';
    admin = List.from(json['admin'] ?? []);
    hr = List.from(json['hr'] ?? []);
    subadmin = List.from(json['subadmin'] ?? []);
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    address = json['address'] ?? '';
    incor = json['incor'] ?? '';
    bday = json['bday'] ?? '';
    pic1 = json['pic1'] ?? '';
    people = List.from(json['people'] ?? []);
    desc = json['desc'] ?? '';
    labourlink = json['labourlink'] ?? 'https://starwish.fun';
    comcases = json['comcases'] ?? 'https://starwish.fun';
    compolicy = json['compolicy'] ?? 'https://starwish.fun';
    lawname = json['lawname'] ?? 'KIRTI NAYAK';
    lawphone = json['lawphone'] ?? '8093426979';
    lawemail = json['lawemail'] ?? 'law@starwish.fun';
    c1 = json['c1']?.toDouble() ?? 10.0;
    c2 = json['c2']?.toDouble() ?? 0.0;
    c3 = json['c3']?.toDouble() ?? 0.0;
    c4 = json['c4']?.toDouble() ?? 0.0;
    c5 = json['c5']?.toDouble() ?? 0.0;
    c6 = json['c6']?.toDouble() ?? 0.0;
    c7 = json['c7']?.toDouble() ?? 0.0;
    c8 = json['c8']?.toDouble() ?? 0.0;
    c9 = json['c9']?.toDouble() ?? 0.0;
    c10 = json['c10']?.toDouble() ?? 0.0;
    c11 = json['c11']?.toDouble() ?? 0.0;
    c12 = json['c12']?.toDouble() ?? 0.0;
    budget = json['budget']?.toDouble() ?? 1000.0;
    lat = json['lat']?.toDouble() ?? 0.0;
    long = json['long']?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['name'] = name;
    data['logo'] = logo;
    data['pan'] = pan;
    data['tan'] = tan;
    data['uid'] = uid;
    data['id'] = id;
    data['type'] = type;
    data['admin'] = admin;
    data['hr'] = hr;
    data['subadmin'] = subadmin;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['incor'] = incor;
    data['bday'] = bday;
    data['pic1'] = pic1;
    data['people'] = people;
    data['desc'] = desc;
    data['labourlink'] = labourlink;
    data['comcases'] = comcases;
    data['compolicy'] = compolicy;
    data['lawname'] = lawname;
    data['lawphone'] = lawphone;
    data['lawemail'] = lawemail;
    data['c1'] = c1;
    data['c2'] = c2;
    data['c3'] = c3;
    data['c4'] = c4;
    data['c5'] = c5;
    data['c6'] = c6;
    data['c7'] = c7;
    data['c8'] = c8;
    data['c9'] = c9;
    data['c10'] = c10;
    data['c11'] = c11;
    data['c12'] = c12;
    data['budget'] = budget;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }

  static OrganisationModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return OrganisationModel.fromJson(snapshot);
  }
}
