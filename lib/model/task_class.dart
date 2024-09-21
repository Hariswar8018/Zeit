import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  Task({
    required this.name,
    required this.id,
    required this.hrid,
    required this.hrname,
    required this.comid,
    required this.followers,
    required this.benefit,
    required this.description,
    required this.startdate,
    required this.enddate,
    required this.priority,
    required this.status,
    required this.pic,
    required this.assigndate,
    required this.lat,
    required this.lon,
    required this.client_name,
    required this.client_id,
    required this.category,
    required this.invited,
    required this.complete,
    required this.progress,
    required this.Completed,
    required this.Ignored,
    required this.Incompleted,
    required this.Pending,

  });

  late final String name;
  late final String id;
  late final String hrid;
  late final String hrname;
  late final String comid;
  late final List followers;
  late final List benefit;
  late final String description;
  late final String startdate;
  late final String enddate;
  late final String priority;
  late final String status;
  late final String pic;
  late final String assigndate;
  late final double lat;
  late final double lon;
  late final String client_name;
  late final String client_id;
  late final String category;
  late final int invited;
  late final int complete;
  late final int progress;

  late final List Pending;
  late final List Completed;
  late final List Ignored;
  late final List Incompleted;

  Task.fromJson(Map<String, dynamic> json) {
    Pending =json['Pending']??[];
    Completed=json['Completed']??[];
    Ignored=json['Ignored']??[];
    Incompleted=json['Incompleted']??[];
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    hrid = json['hrid'] ?? '';
    hrname = json['hrname'] ?? '';
    comid = json['comid'] ?? '';
    followers = List<dynamic>.from(json['followers'] ?? []);
    benefit = List<dynamic>.from(json['benefit'] ?? []);
    description = json['description'] ?? '';
    startdate = json['startdate'] ?? '';
    enddate = json['enddate'] ?? '';
    priority = json['priority'] ?? '';
    status = json['status'] ?? '';
    pic = json['pic'] ?? '';
    assigndate = json['assigndate'] ?? '';
    lat = json['lat']?.toDouble() ?? 0.0;
    lon = json['lon']?.toDouble() ?? 0.0;
    client_name = json['client_name'] ?? '';
    client_id = json['client_id'] ?? '';
    category = json['category'] ?? '';
    invited = json['invited'] ?? 0;
    complete = json['complete'] ?? 0;
    progress = json['progress'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Pending']=Pending;
    data['Completed']=Completed;
    data['Ignored']=Ignored;
    data['Incompleted']=Incompleted;
    data['name'] = name;
    data['id'] = id;
    data['hrid'] = hrid;
    data['hrname'] = hrname;
    data['comid'] = comid;
    data['followers'] = followers;
    data['benefit'] = benefit;
    data['description'] = description;
    data['startdate'] = startdate;
    data['enddate'] = enddate;
    data['priority'] = priority;
    data['status'] = status;
    data['pic'] = pic;
    data['assigndate'] = assigndate;
    data['lat'] = lat;
    data['lon'] = lon;
    data['client_name'] = client_name;
    data['client_id'] = client_id;
    data['category'] = category;
    data['invited'] = invited;
    data['complete'] = complete;
    data['progress'] = progress;
    return data;
  }

  static Task fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Task.fromJson(snapshot);
  }
}
