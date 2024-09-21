class TimeModel {
  TimeModel({
    required this.time,
    required this.date,
    required this.month,
    required this.year,
    required this.duration,
    required this.x,
    required this.lastupdate,
    required this.started,
    required this.millisecondstos,
    required this.startaddress,
    required this.endaddress,
    required this.stlan,
    required this.stlon,
    required this.endlan,
    required this.endlong,
    required this.color,
  });
late final int color;
  late final String time;
  late final String date;
  late final String month;
  late final String year;
  late final int duration;
  late final int x;
  late final String lastupdate;
  late final bool started;
  late final String millisecondstos;
  late final String startaddress;
  late final String endaddress;
  late final double stlan;
  late final double stlon;
  late final double endlan;
  late final double endlong;

  TimeModel.fromJson(Map<String, dynamic> json) {
    color=json['color']??678;
    time = json['time'] ?? '';
    date = json['date'] ?? '';
    month = json['month'] ?? '';
    year = json['year'] ?? '';
    duration = json['duration'] ?? 0;
    x = json['x'] ?? 0;
    lastupdate = json['lastupdate'] ?? '2024-07-11 07:35:45.002137';
    started = json['started'] ?? false;
    millisecondstos = json['millisecondstos'] ?? "1720663545000";
    startaddress = json['startaddress'] ?? '';
    endaddress = json['endaddress'] ?? '';
    stlan = json['stlan']?.toDouble() ?? 0.0;
    stlon = json['stlon']?.toDouble() ?? 0.0;
    endlan = json['endlan']?.toDouble() ?? 0.0;
    endlong = json['endlong']?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['color']=color;
    data['time'] = time;
    data['date'] = date;
    data['month'] = month;
    data['year'] = year;
    data['duration'] = duration;
    data['x'] = x;
    data['lastupdate'] = lastupdate;
    data['started'] = started;
    data['millisecondstos'] = millisecondstos;
    data['startaddress'] = startaddress;
    data['endaddress'] = endaddress;
    data['stlan'] = stlan;
    data['stlon'] = stlon;
    data['endlan'] = endlan;
    data['endlong'] = endlong;
    return data;
  }
}
