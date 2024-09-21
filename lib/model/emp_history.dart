import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EmploymentHistory {
  EmploymentHistory({
    required this.company,
    required this.location,
    required this.posting,
    required this.time1,
    required this.time2,
    required this.description,
    required this.logo,
    required this.zeit,
    required this.locationType,
  });

  late final String company;
  late final String location;
  late final String posting;
  late final String time1;
  late final String time2;
  late final String description;
  late final String logo;
  late final bool zeit;
  late final String locationType;

  EmploymentHistory.fromJson(Map<String, dynamic> json) {
    company = json['company'] ?? '';
    location = json['location'] ?? '';
    posting = json['posting'] ?? '';
    time1 = json['time1'] ?? '';
    time2 = json['time2'] ?? '';
    description = json['description'] ?? '';
    logo = json['logo'] ?? '';
    zeit = json['zeit'] ?? false;
    locationType = json['locationType'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['company'] = company;
    data['location'] = location;
    data['posting'] = posting;
    data['time1'] = time1;
    data['time2'] = time2;
    data['description'] = description;
    data['logo'] = logo;
    data['zeit'] = zeit;
    data['locationType'] = locationType;
    return data;
  }
}
