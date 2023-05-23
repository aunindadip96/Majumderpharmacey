class ModelClassForDoctorList {
  int id;
  String name;
  String description;
  String degree;
  String specialist;
  int specialistId;
  List<Schedule> schedule;
  List<Dates> dates;

  ModelClassForDoctorList({
    required this.id,
    required this.name,
    required this.description,
    required this.degree,
    required this.specialist,
    required this.specialistId,
    required this.schedule,
    this.dates = const [], // initialize dates field with an empty list
  });

  factory ModelClassForDoctorList.fromJson(Map<String, dynamic> json) {
    return ModelClassForDoctorList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      degree: json['degree'],
      specialist: json['specialist'],
      specialistId: json['specialist_id'],
      schedule: List<Schedule>.from(
        json['schedule'].map((x) => Schedule.fromJson(x)),
      ),
      dates: List<Dates>.from(
        json['dates'].map((x) => Dates.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['degree'] = this.degree;
    data['specialist'] = this.specialist;
    data['specialist_id'] = this.specialistId;
    data['schedule'] = List<dynamic>.from(this.schedule.map((x) => x.toJson()));
    data['dates'] = List<dynamic>.from(this.dates.map((x) => x.toJson()));
    return data;
  }
}

class Schedule {
  String day;
  String startingTime;
  String endingTime;

  Schedule({
    required this.day,
    required this.startingTime,
    required this.endingTime,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      day: json['day'],
      startingTime: json['starting_time'],
      endingTime: json['ending_time'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['day'] = this.day;
    data['starting_time'] = this.startingTime;
    data['ending_time'] = this.endingTime;
    return data;
  }
}

class Dates {
  List<String> date;

  Dates({required this.date});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      date: List<String>.from(json['date'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['date'] = List<dynamic>.from(this.date.map((x) => x));
    return data;
  }
}