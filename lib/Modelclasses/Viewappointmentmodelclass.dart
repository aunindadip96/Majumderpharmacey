class viewappoinment {
  String? id;
  String? pId;
  String? dId;
  String? sId;
  String? appointmentDate;
  String? dNumber;
  String? appointmentTime;
  String? startingTime;
  String? endingTime;
  String? appointmentStatus;
  String? token;
  String ? deletedAt;
  String? createdAt;
  String? updatedAt;
  D? d;
  S? s;

  viewappoinment(
      {this.id,
        this.pId,
        this.dId,
        this.sId,
        this.appointmentDate,
        this.dNumber,
        this.appointmentTime,
        this.startingTime,
        this.endingTime,
        this.appointmentStatus,
        this.token,
        this.deletedAt,
        this.createdAt,
        this.updatedAt,
        this.d,
        this.s});

  viewappoinment.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    pId = json['p_id'].toString();
    dId = json['d_id'].toString();
    sId = json['s_id'].toString();
    appointmentDate = json['appointment_date'].toString();
    dNumber = json['d_number'].toString();
    appointmentTime = json['appointment_time'].toString();
    startingTime = json['starting_time'].toString();
    endingTime = json['ending_time'].toString();
    appointmentStatus = json['appointment_status'].toString();
    token = json['token'].toString();
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    d = json['d'] != null ? new D.fromJson(json['d']) : null;
    s = json['s'] != null ? new S.fromJson(json['s']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['p_id'] = this.pId;
    data['d_id'] = this.dId;
    data['s_id'] = this.sId;
    data['appointment_date'] = this.appointmentDate;
    data['d_number'] = this.dNumber;
    data['appointment_time'] = this.appointmentTime;
    data['starting_time'] = this.startingTime;
    data['ending_time'] = this.endingTime;
    data['appointment_status'] = this.appointmentStatus;
    data['token'] = this.token;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.d != null) {
      data['d'] = this.d!.toJson();
    }
    if (this.s != null) {
      data['s'] = this.s!.toJson();
    }
    return data;
  }
}

class D {
  String? id;
  String? doctor;
  String? specialistId;
  String? fees;
  String? earning;
  String? scheduleGap;
  String? appointmentTime;
  String? degree;
  String? description;
  String? phone;
  String? email;
  String? doctorId;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  D(
      {this.id,
        this.doctor,
        this.specialistId,
        this.fees,
        this.earning,
        this.scheduleGap,
        this.appointmentTime,
        this.degree,
        this.description,
        this.phone,
        this.email,
        this.doctorId,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  D.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    doctor = json['doctor'].toString();
    specialistId = json['specialist_id'].toString();
    fees = json['fees'].toString();
    earning = json['earning'].toString();
    scheduleGap = json['schedule_gap'].toString();
    appointmentTime = json['appointment_time'].toString();
    degree = json['degree'].toString();
    description = json['description'].toString();
    phone = json['phone'].toString();
    email = json['email'].toString();
    doctorId = json['doctor_id'].toString();
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor'] = this.doctor;
    data['specialist_id'] = this.specialistId;
    data['fees'] = this.fees;
    data['earning'] = this.earning;
    data['schedule_gap'] = this.scheduleGap;
    data['appointment_time'] = this.appointmentTime;
    data['degree'] = this.degree;
    data['description'] = this.description;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['doctor_id'] = this.doctorId;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class S {
  int? id;
  String? specialist;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  S({this.id, this.specialist, this.deletedAt, this.createdAt, this.updatedAt});

  S.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialist = json['specialist'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialist'] = this.specialist;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}