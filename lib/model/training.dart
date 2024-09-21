class TrainingProgram {
  TrainingProgram({
    required this.company,
    required this.trainer,
    required this.type,
    required this.start,
    required this.end,
    required this.cost,
    required this.desc,
    required this.status,
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.feedbackLink,
    required this.skills,
    required this.pic,
    required this.attendance,
    required this.star,
    required this.location,
    required this.feedback,
    required this.Completed,
    required this.Ignored,
    required this.Incompleted,
    required this.Pending,
  });

  late final String company;
  late final String trainer;
  late final String type;
  late final String start;
  late final String end;
  late final int cost;
  late final String desc;
  late final String status;
  late final String name;
  late final String id;
  late final String email;
  late final String phone;
  late final String feedbackLink;
  late final List<String> skills;
  late final String pic;
  late final List<String> attendance;
  late final int star;
  late final String location;
  late final String feedback;
  late final List Pending;
  late final List Completed;
  late final List Ignored;
  late final List Incompleted;
  TrainingProgram.fromJson(Map<String, dynamic> json) {
    Pending =json['Pending']??[];
    Completed=json['Completed']??[];
    Ignored=json['Ignored']??[];
    Incompleted=json['Incompleted']??[];
    company = json['company'] ?? '';
    trainer = json['trainer'] ?? '';
    type = json['type'] ?? '';
    start = json['start'] ?? '';
    end = json['end'] ?? '';
    cost = (json['cost'] ?? 0).toInt();
    desc = json['desc'] ?? '';
    status = json['status'] ?? '';
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    feedbackLink = json['feedback_link'] ?? '';
    skills = List<String>.from(json['skills'] ?? []);
    pic = json['pic'] ?? '';
    attendance = List<String>.from(json['attendance'] ?? []);
    star = (json['star'] ?? 0).toInt();
    location = json['location'] ?? '';
    feedback = json['feedback'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Pending']=Pending;
    data['Completed']=Completed;
    data['Ignored']=Ignored;
    data['Incompleted']=Incompleted;
    data['company'] = company;
    data['trainer'] = trainer;
    data['type'] = type;
    data['start'] = start;
    data['end'] = end;
    data['cost'] = cost;
    data['desc'] = desc;
    data['status'] = status;
    data['name'] = name;
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['feedback_link'] = feedbackLink;
    data['skills'] = skills;
    data['pic'] = pic;
    data['attendance'] = attendance;
    data['star'] = star;
    data['location'] = location;
    data['feedback'] = feedback;
    return data;
  }
}
