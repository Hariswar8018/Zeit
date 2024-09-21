import 'package:cloud_firestore/cloud_firestore.dart';

class Events {
  Events({
    required this.name,
    required this.id,
    required this.descrip,
    required this.hrid,
    required this.benefit,
    required this.comid,
    required this.link,
    required this.date,
    required this.status,
    required this.followers,
    required this.address,
    required this.city,
    required this.state,
    required this.pic,
  });

  late final String name;
  late final String id;
  late final String descrip;
  late final String hrid;
  late final List benefit;
  late final String comid;
  late final String link;
  late final String date;
  late final String status;
  late final List followers;
  late final String address;
  late final String city;
  late final String state;
  late final String pic;

  Events.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    descrip = json['descrip'] ?? '';
    hrid = json['hrid'] ?? '';
    benefit = json['benefit'] ?? [];
    comid = json['comid'] ?? '';
    link = json['link'] ?? '';
    date = json['date'] ?? '';
    status = json['status'] ?? '';
    followers = json['followers'] ?? [];
    address = json['address'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    pic = json['pic'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['descrip'] = descrip;
    data['hrid'] = hrid;
    data['benefit'] = benefit;
    data['comid'] = comid;
    data['link'] = link;
    data['date'] = date;
    data['status'] = status;
    data['followers'] = followers;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['pic'] = pic;
    return data;
  }

  static Events fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Events.fromJson(snapshot);
  }
}
