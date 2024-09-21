class PayModel {
  late final String name;
  late final String id;
  late final String type;
  late final String pic;
  late final String position;
  late final double basic;
  late final double net;
  late final String status;
  late final double allowance;
  late final double overtime;
  late final double other;
  late final double statuatory;
  late final double monthly;
  late final double loan;
  late final double pension;
  late final double payment;

  PayModel({
    required this.name,
    required this.id,
    required this.type,
    required this.pic,
    required this.position,
    required this.basic,
    required this.net,
    required this.status,
    required this.allowance,
    required this.overtime,
    required this.other,
    required this.statuatory,
    required this.monthly,
    required this.loan,
    required this.pension,
    required this.payment,
  });

  PayModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    id = json['id'] ?? '';
    type = json['type'] ?? '';
    pic = json['pic'] ?? '';
    position = json['position'] ?? '';
    basic = (json['basic'] ?? 0.0).toDouble();
    net = (json['net'] ?? 0.0).toDouble();
    status = json['status'] ?? '';
    allowance = (json['allowance'] ?? 0.0).toDouble();
    overtime = (json['overtime'] ?? 0.0).toDouble();
    other = (json['other'] ?? 0.0).toDouble();
    statuatory = (json['statuatory'] ?? 0.0).toDouble();
    monthly = (json['monthly'] ?? 0.0).toDouble();
    loan = (json['loan'] ?? 0.0).toDouble();
    pension = (json['pension'] ?? 0.0).toDouble();
    payment = (json['payment'] ?? 0.0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['type'] = type;
    data['pic'] = pic;
    data['position'] = position;
    data['basic'] = basic;
    data['net'] = net;
    data['status'] = status;
    data['allowance'] = allowance;
    data['overtime'] = overtime;
    data['other'] = other;
    data['statuatory'] = statuatory;
    data['monthly'] = monthly;
    data['loan'] = loan;
    data['pension'] = pension;
    data['payment'] = payment;
    return data;
  }
}
