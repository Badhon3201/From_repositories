import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:testkj/feature/models/from_response.dart';
import 'package:testkj/feature/models/student_from_request.dart';

class StudentRepository {
  getData() async {
    try {
      var response = await rootBundle.loadString('assets/from_json.json');
      return StudentFromResponse.fromRawJson(response);
    } catch (e) {
      print(e);
    }
  }

  saveData(StudentFromRequest studentFromRequest) async {
    print(studentFromRequest.toRawJson());
    try {
      var response = await Dio().post("path");
      return response;
    } catch (e) {
      print(e);
    }
  }
}
