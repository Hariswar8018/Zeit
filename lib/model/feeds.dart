import 'package:cloud_firestore/cloud_firestore.dart';

class Feed {
  Feed({
    required this.name,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
    required this.announ,
    required this.hr,
    required this.pic,
    required this.link,
    required this.Ntname,
    required this.Ntpic,
    required this.id,
  });

  late final String name;
  late final String title;
  late final String description;
  late final List likes;
  late final List comments;
  late final bool announ;
  late final bool hr;
  late final String pic;
  late final String link;
  late final String Ntname;
  late final String Ntpic;
  late final String id;

  Feed.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    likes = json['likes'] ?? [];
    comments = json['comments'] ?? [];
    announ = json['announ'] ?? false;
    hr = json['hr'] ?? false;
    pic = json['pic'] ?? '';
    link = json['link'] ?? '';
    Ntname = json['Ntname'] ?? '';
    Ntpic = json['Ntpic'] ?? '';
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['title'] = title;
    data['description'] = description;
    data['likes'] = likes;
    data['comments'] = comments;
    data['announ'] = announ;
    data['hr'] = hr;
    data['pic'] = pic;
    data['link'] = link;
    data['Ntname'] = Ntname;
    data['Ntpic'] = Ntpic;
    data['id'] = id;
    return data;
  }

  static Feed fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Feed.fromJson(snapshot);
  }
}
