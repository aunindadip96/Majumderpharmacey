class modelclassfordoctor {
  String? name;
  String? specialist;
  int? specialistId;
  List<Schedule>? schedule;

  modelclassfordoctor(
      {this.name, this.specialist, this.specialistId, this.schedule});

  modelclassfordoctor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    specialist = json['specialist'];
    specialistId = json['specialist_id'];
    if (json['schedule'] != null) {
      schedule = <Schedule>[];
      json['schedule'].forEach((v) {
        schedule!.add(new Schedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['specialist'] = this.specialist;
    data['specialist_id'] = this.specialistId;
    if (this.schedule != null) {
      data['schedule'] = this.schedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  String? day;
  String? startingTime;
  String? endingTime;

  Schedule({this.day, this.startingTime, this.endingTime});

  Schedule.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startingTime = json['starting_time'];
    endingTime = json['ending_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['starting_time'] = this.startingTime;
    data['ending_time'] = this.endingTime;
    return data;
  }
}