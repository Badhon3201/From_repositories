import 'dart:convert';

class StudentFromRequest {
  StudentFromRequest({
    this.teacherName,
    this.age,
    this.subject,
    this.student,
    this.equipment,
  });

  String? teacherName;
  int? age;
  String? subject;
  List<EqSnt>? student;
  List<EqSnt>? equipment;

  factory StudentFromRequest.fromRawJson(String str) =>
      StudentFromRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentFromRequest.fromJson(Map<String, dynamic> json) =>
      StudentFromRequest(
        teacherName: json["teacher_name"],
        age: json["age"],
        subject: json["subject"],
        student: json["student"] == null
            ? null
            : List<EqSnt>.from(json["student"].map((x) => EqSnt.fromJson(x))),
        equipment: json["equipment"] == null
            ? null
            : List<EqSnt>.from(json["equipment"].map((x) => EqSnt.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "teacher_name": teacherName,
        "age": age,
        "subject": subject,
        "student": student == null
            ? null
            : List<dynamic>.from(student!.map((x) => x.toJson())),
        "equipment": equipment == null
            ? null
            : List<dynamic>.from(equipment!.map((x) => x.toJson())),
      };
}

class EqSnt {
  EqSnt({
    this.key,
    this.name,
  });

  int? key;
  String? name;

  factory EqSnt.fromRawJson(String str) => EqSnt.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EqSnt.fromJson(Map<String, dynamic> json) => EqSnt(
        key: json["key"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "name": name,
      };
}
