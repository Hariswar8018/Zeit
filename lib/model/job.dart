import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job({
    required this.name,
    required this.comn,
    required this.comi,
    required this.rating,
    required this.address,
    required this.type,
    required this.description,
    required this.respon,
    required this.key,
    required this.about,
    required this.experience,
    required this.qualification,
    required this.follower,
    required this.saved,
    required this.benefit,
    required this.hrname,
    required this.hrid,
    required this.comlogo,
    required this.hrlogo,
    required this.status,
    required this.time,
    required this.jem,
    required this.jtype,
    required this.shift,
    required this.work1,
    required this.follower1,
    required this.payment,
    required this.Intaddress,
    required this.lat,
    required this.lon,
    required this.phone,
    required this.mail,
    required this.note,
    required this.link,
    required this.meet,
    required this.time2,
  });
late final String time2;
  late final String name;
  late final String comn;
  late final String comi;
  late final double rating;
  late final String address;
  late final List<dynamic> type;
  late final String description;
  late final String respon;
  late final String key;
  late final String about;
  late final String experience;
  late final String qualification;
  late final List<dynamic> follower;
  late final List<dynamic> follower1;
  late final List<dynamic> saved;
  late final List<dynamic> benefit;
  late final String hrname;
  late final String hrid;
  late final String comlogo;
  late final String hrlogo;
  late final bool status;
  late final String time;
  late final String jtype;
  late final String jem;
  late final String status1;
  late final String work1;
  late final String shift;
  late final int payment;
  late final String Intaddress;
  late final double lat;
  late final double lon;
  late final String phone;
  late final String mail;
  late final String note;
  late final String link;
  late final bool meet;

  Job.fromJson(Map<String, dynamic> json) {
    time2=json['time2']??"jgh";
    status1 = json['status1'] ?? "Active";
    work1 = json['work1'] ?? "In Person";
    shift = json['shift'] ?? "Morning Shift";
    name = json['name'] ?? '';
    jtype = json['jtype'] ?? "Full Time";
    jem = json['jem'] ?? 'Permanent';
    comn = json['comn'] ?? '';
    comi = json['comi'] ?? '';
    rating = json['rating']?.toDouble() ?? 0.0;
    address = json['address'] ?? '';
    type = List<dynamic>.from(json['type'] ?? []);
    description = json['description'] ?? '';
    respon = json['respon'] ?? '';
    key = json['key'] ?? '';
    about = json['about'] ?? '';
    experience = json['experience'] ?? '';
    qualification = json['qualification'] ?? '';
    follower = List<dynamic>.from(json['follower'] ?? []);
    follower1 = List<dynamic>.from(json['follower1'] ?? []);
    saved = List<dynamic>.from(json['saved'] ?? []);
    benefit = List<dynamic>.from(json['benefit'] ?? []);
    hrname = json['hrname'] ?? '';
    hrid = json['hrid'] ?? '';
    comlogo = json['comlogo'] ?? '';
    hrlogo = json['hrlogo'] ?? '';
    status = json['status'] ?? false;
    time = json['time'] ?? '';
    payment = json['payment'] ?? 5000;
    Intaddress = json['Intaddress'] ?? '';
    lat = json['lat']?.toDouble() ?? 0.0;
    lon = json['lon']?.toDouble() ?? 0.0;
    phone = json['phone'] ?? '';
    mail = json['mail'] ?? '';
    note = json['note'] ?? '';
    link = json['link'] ?? '';
    meet = json['meet'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time2']=time2;
    data['work1'] = work1;
    data['shift'] = shift;
    data['jtype'] = jtype;
    data['jem'] = jem;
    data['name'] = name;
    data['comn'] = comn;
    data['comi'] = comi;
    data['rating'] = rating;
    data['address'] = address;
    data['type'] = type;
    data['description'] = description;
    data['respon'] = respon;
    data['key'] = key;
    data['about'] = about;
    data['experience'] = experience;
    data['qualification'] = qualification;
    data['follower'] = follower;
    data['follower1'] = follower1;
    data['saved'] = saved;
    data['benefit'] = benefit;
    data['hrname'] = hrname;
    data['hrid'] = hrid;
    data['comlogo'] = comlogo;
    data['hrlogo'] = hrlogo;
    data['status'] = status;
    data['time'] = time;
    data['payment'] = payment;
    data['Intaddress'] = Intaddress;
    data['lat'] = lat;
    data['lon'] = lon;
    data['phone'] = phone;
    data['mail'] = mail;
    data['note'] = note;
    data['link'] = link;
    data['meet'] = meet;
    return data;
  }

  static Job fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Job.fromJson(snapshot);
  }
}
