class Signup {
  String? address;
  String? phone,email,username,password,patient,patient_id;




  Signup(
      {this.address,
        this.phone,
        this.email,
        this.username,
        this.password,
        this.patient,
        this.patient_id




      });

  Signup.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    phone = json['phone'];
    email= json['email'];
    username= json['username'];
    password= json['password'];
    patient= json['patient'];
    patient_id= json['patient_id'];



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] =this.email;
    data['username']=this.username;
    data['password']=this.password;
    data['patient']=this.patient;
    data['patient_id']=this.patient_id;


    return data;
  }
}