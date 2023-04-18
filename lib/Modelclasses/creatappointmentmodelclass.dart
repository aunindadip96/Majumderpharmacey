class creatappointmentmodelclass {
  String? p_id,
      d_id,
      s_id,
      appointment_date, d_number, token;

  creatappointmentmodelclass(
      {this.p_id,
      this.d_id,
      this.s_id,
      this.appointment_date,
      this.d_number,
      this.token});
  creatappointmentmodelclass.fromJson(Map<String, dynamic> json) {
    p_id = json['p_id'];
    d_id = json['d_id'];
    s_id = json['s_id'];
    appointment_date = json['appointment_date'];
    d_number = json['d_number'];
    token = json['token'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['p_id'] = this.p_id;
    data['d_id'] = this.d_id;
    data['s_id'] = this.s_id;
    data['appointment_date'] = this.appointment_date;
    data['d_number'] = this.d_number;
    data['token'] = this.token;

    return data;
  }
}
