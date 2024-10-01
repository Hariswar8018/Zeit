import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.Email,
    required this.Name,
    required this.uid,
    required this.bday,
    required this.education,
    required this.gender,
    required this.empid,
    required this.address,
    required this.country,
    required this.state,
    required this.pic,
    required this.lastlogin,
    required this.online,
    required this.employee,
    required this.following,
    required this.pan,
    required this.adhaar,
    required this.bio,
    required this.reporting,
    required this.location,
    required this.role,
    required this.status,
    required this.type,
    required this.source,
    required this.joiningd,
    required this.exp,
    required this.totalexp,
    required this.identity,
    required this.resumelink,
    required this.resumetime,
    required this.link1,
    required this.link2,
    required this.link3,
    required this.shit,
    required this.salary,
    required this.meetlink,
    required this.meetname,
    required this.meetid,
    required this.meetby,
    required this.meetpic,
    required this.meetdesc,
  });

  late final String lastlogin;
  late final bool online;
  late final List employee;
  late final List following;
  late final String pic;
  late final String Email;
  late final List<dynamic> follower;
  late final List<dynamic> follower1;
  late final String Name;
  late final String uid;
  late final String education;
  late final String bday;
  late final String gender;
  late final String empid;
  late final String country;
  late final String state;
  late final String address;
  late final String pan;
  late final String adhaar;
  late final String bio;
  late final String reporting;
  late final String location;
  late final String role;
  late final String status;
  late final String type;
  late final String source;
  late final String joiningd;
  late final String exp;
  late final String totalexp;
  late final String identity;
  late final String resumelink;
  late final int resumetime;
  late final String link1;
  late final String link2;
  late final String link3;
  late final String shit;
  late final String token;
  late final double salary;

  // New meeting fields
  late final String meetlink;
  late final String meetname;
  late final String meetid;
  late final String meetby;
  late final String meetpic;
  late final String meetdesc;

  UserModel.fromJson(Map<String, dynamic> json) {
    follower = List<dynamic>.from(json['jobfollower'] ?? []);
    token = json['token'] ?? "j";
    follower1 = List<dynamic>.from(json['jobfollower1'] ?? []);
    lastlogin = json['last'] ?? "2024-08-24 12:12:38.951004";
    online = json['online'] ?? false;
    country = json['country'] ?? 'IN';
    state = json['state'] ?? 'Odisha';
    address = json['address'] ?? '45+ WT, Kolkata, Odisha';
    pic = json['pic'] ?? "";
    Email = json['email'] ?? 'haiswar@gmail.com';
    Name = json['name'] ?? 'Nijono Yume';
    uid = json['uid'] ?? '';
    education = json['education'] ?? '+2 Science';
    bday = json['bday'] ?? '';
    gender = json['gender'] ?? 'Male';
    empid = json['empid'] ?? 'Long Term Relationship';
    employee = json['employees'] ?? [];
    following = json['following'] ?? [];
    pan = json['pan'] ?? '';
    adhaar = json['adhaar'] ?? '';
    bio = json['bio'] ?? '';
    reporting = json['reporting'] ?? '';
    location = json['location'] ?? '';
    role = json['role'] ?? '';
    status = json['status'] ?? '';
    type = json['type'] ?? 'Employee';
    source = json['source'] ?? '';
    joiningd = json['joiningd'] ?? '';
    exp = json['exp'] ?? '';
    totalexp = json['totalexp'] ?? '';
    identity = json['identity'] ?? '';
    resumelink = json['resumelink'] ?? '';
    resumetime = json['resumetime'] ?? 966;
    link1 = json['link1'] ?? '';
    link2 = json['link2'] ?? '';
    link3 = json['link3'] ?? '';
    shit = json['shit'] ?? '';
    salary = (json['salary'] ?? 0.0).toDouble();

    // New meeting fields initialization
    meetlink = json['meetlink'] ?? '';
    meetname = json['meetname'] ?? '';
    meetid = json['meetid'] ?? '';
    meetby = json['meetby'] ?? '';
    meetpic = json['meetpic'] ?? '';
    meetdesc = json['meetdesc'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['employees'] = employee;
    data['following'] = following;
    data['country'] = country;
    data['state'] = state;
    data['address'] = address;
    data['email'] = Email;
    data['name'] = Name;
    data['uid'] = uid;
    data['education'] = education;
    data['bday'] = bday;
    data['gender'] = gender;
    data['empid'] = empid;
    data['pic'] = pic;
    data['online'] = online;
    data['last'] = lastlogin;
    data['pan'] = pan;
    data['adhaar'] = adhaar;
    data['bio'] = bio;
    data['reporting'] = reporting;
    data['location'] = location;
    data['role'] = role;
    data['status'] = status;
    data['type'] = type;
    data['source'] = source;
    data['joiningd'] = joiningd;
    data['exp'] = exp;
    data['totalexp'] = totalexp;
    data['identity'] = identity;
    data['resumelink'] = resumelink;
    data['resumetime'] = resumetime;
    data['link1'] = link1;
    data['link2'] = link2;
    data['link3'] = link3;
    data['shit'] = shit;
    data['salary'] = salary;

    // Adding new meeting fields to JSON
    data['meetlink'] = meetlink;
    data['meetname'] = meetname;
    data['meetid'] = meetid;
    data['meetby'] = meetby;
    data['meetpic'] = meetpic;
    data['meetdesc'] = meetdesc;
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel.fromJson(snapshot);
  }
}
