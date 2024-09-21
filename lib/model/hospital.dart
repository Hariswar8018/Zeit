import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  late final String pic;
  late final String type;
  late final String company;
  late final String name;
  late final String email;
  late final String link;
  late final String phone;
  late final String location;
  late final String feedbackLink;
  late final int rating;
  late final String desc;
  late final List<String> attendance;
  late final String id; // Added id field

  Hospital({
    required this.pic,
    required this.type,
    required this.company,
    required this.name,
    required this.email,
    required this.link,
    required this.phone,
    required this.location,
    required this.feedbackLink,
    required this.rating,
    required this.desc,
    required this.attendance,
    required this.id, // Added id to constructor
  });

  Hospital.fromJson(Map<String, dynamic> json) {
    pic = json['pic'] ?? '';
    type = json['type'] ?? '';
    company = json['company'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    link = json['link'] ?? '';
    phone = json['phone'] ?? '';
    location = json['location'] ?? '';
    feedbackLink = json['feedbackLink'] ?? '';
    rating = json['rating'] ?? 0;
    desc = json['desc'] ?? '';
    attendance = List<String>.from(json['attendance'] ?? []);
    id = json['id'] ?? ''; // Initialize id from json
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pic'] = pic;
    data['type'] = type;
    data['company'] = company;
    data['name'] = name;
    data['email'] = email;
    data['link'] = link;
    data['phone'] = phone;
    data['location'] = location;
    data['feedbackLink'] = feedbackLink;
    data['rating'] = rating;
    data['desc'] = desc;
    data['attendance'] = attendance;
    data['id'] = id; // Add id to JSON
    return data;
  }
}
