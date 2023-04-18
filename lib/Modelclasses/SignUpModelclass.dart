class Signup {
  String? address;
  String? phone, email, username, password, patient, patient_id, external_id;

  Signup(
      {this.address,
      this.phone,
      this.email,
      this.username,
      this.password,
      this.patient,
      this.patient_id,
      this.external_id});

  Signup.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    patient = json['patient'];
    patient_id = json['patient_id'];
    external_id = json['External_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address.toString();
    data['phone'] = this.phone.toString();
    data['email'] = this.email.toString();
    data['username'] = this.username.toString();
    data['password'] = this.password.toString();
    data['patient'] = this.patient.toString();
    data['patient_id'] = this.patient_id.toString();
    data['external_id'] = this.external_id.toString();

    return data;
  }
}
