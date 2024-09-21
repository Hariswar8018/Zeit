import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  Request({
    required this.name,
    required this.designation,
    required this.joining,
    required this.request,
    required this.change,
    required this.reason,
    required this.userid,
    required this.id,
    required this.topic,
    required this.queries,
    required this.description,
    required this.attachment,
    required this.status,
    required this.time,
    required this.response, required this.pic,required this.date1,required this.date2,
  });

  late final String name;
  late final String designation;
  late final String joining;
  late final String request;
  late final bool change;
  late final String reason;
  late final String userid;
  late final String id;
  late final String topic;
  late final bool queries;
  late final String description;
  late final String attachment;
  late final String status;
  late final String time;
  late final String response;
  late final String pic ;
  late final String date1 ;
  late final String date2 ;
  Request.fromJson(Map<String, dynamic> json) {
    date1=json['date1']??"";
    date2=json['date2']??'';
    name = json['name'] ?? '';
    designation = json['designation'] ?? '';
    joining = json['joining'] ?? '';
    request = json['request'] ?? '';
    change = json['change'] ?? false;
    reason = json['reason'] ?? '';
    userid = json['userid'] ?? '';
    id = json['id'] ?? '';
    pic = json['pic'] ?? "";
    topic = json['topic'] ?? '';
    queries = json['queries'] ?? false;
    description = json['description'] ?? '';
    attachment = json['attachment'] ?? '';
    status = json['status'] ?? '';
    time = json['time'] ?? '';
    response = json['response'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['designation'] = designation;
    data['joining'] = joining;
    data['request'] = request;
    data['date1']=date1;
    data['date2']=date2;
    data['change'] = change;
    data['reason'] = reason;
    data['userid'] = userid;
    data['pic']=pic;
    data['id'] = id;
    data['topic'] = topic;
    data['queries'] = queries;
    data['description'] = description;
    data['attachment'] = attachment;
    data['status'] = status;
    data['time'] = time;
    data['response'] = response;
    return data;
  }

  static Request fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Request.fromJson(snapshot);
  }
}
