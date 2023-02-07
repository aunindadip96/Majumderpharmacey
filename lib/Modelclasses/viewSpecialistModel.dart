class catagoryModel {
  int? id;
  String? specialist;


  catagoryModel(
      {this.id,
        this.specialist,
       });

  catagoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    specialist = json['specialist'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['specialist'] = this.specialist;

    return data;
  }
}