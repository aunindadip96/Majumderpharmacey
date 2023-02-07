class modelclassfordoctor {
  String? name;
  String? specialist;
  int? specialistId;
  List<AppointmentSchedule>? appointmentSchedule;

  modelclassfordoctor(
      {this.name,
        this.specialist,
        this.specialistId,
        this.appointmentSchedule});

  modelclassfordoctor.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    specialist = json['specialist'];
    specialistId = json['specialist_id'];
    if (json['appointment_schedule'] != null) {
      appointmentSchedule = <AppointmentSchedule>[];
      json['appointment_schedule'].forEach((v) {
        appointmentSchedule!.add(new AppointmentSchedule.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['specialist'] = this.specialist;
    data['specialist_id'] = this.specialistId;
    if (this.appointmentSchedule != null) {
      data['appointment_schedule'] =
          this.appointmentSchedule!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppointmentSchedule {
  String? day;
  String? startTime;
  String? endTime;

  AppointmentSchedule({this.day, this.startTime, this.endTime});

  AppointmentSchedule.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    return data;
  }
}