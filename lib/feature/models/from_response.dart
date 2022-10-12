import 'dart:convert';

class StudentFromResponse {
  StudentFromResponse({
    this.teacherName,
    this.age,
    this.student,
    this.equipment,
  });

  String? teacherName;
  int? age;
  List<Ent>? student;
  List<Ent>? equipment;

  factory StudentFromResponse.fromRawJson(String str) =>
      StudentFromResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StudentFromResponse.fromJson(Map<String, dynamic> json) =>
      StudentFromResponse(
        teacherName: json["teacher_name"],
        age: json["age"],
        student: json["student"] == null
            ? null
            : List<Ent>.from(json["student"].map((x) => Ent.fromJson(x))),
        equipment: json["equipment"] == null
            ? null
            : List<Ent>.from(json["equipment"].map((x) => Ent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "teacher_name": teacherName,
        "age": age,
        "student": student == null
            ? null
            : List<dynamic>.from(student!.map((x) => x.toJson())),
        "equipment": equipment == null
            ? null
            : List<dynamic>.from(equipment!.map((x) => x.toJson())),
      };
}

class Ent {
  Ent({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Ent.fromRawJson(String str) => Ent.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ent.fromJson(Map<String, dynamic> json) => Ent(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
