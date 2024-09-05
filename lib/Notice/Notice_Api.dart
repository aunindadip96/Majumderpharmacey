import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Nptice_Model.dart';

class NoticeCall{

  Future<List<Notice>> fetchNotice () async {
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/viewNotice");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    return list.map((e) => Notice.fromJson(e)).toList();



  }


}