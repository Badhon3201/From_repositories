import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:testkj/feature/models/from_response.dart';
import 'package:testkj/feature/repositories/repository.dart';

import '../models/student_from_request.dart';

class ViewModels extends GetxController {
  final StudentRepository _repository = Get.find();
  final allData = Rxn<StudentFromResponse>();

  var subjectController = TextEditingController();
  final FocusNode focus = FocusNode();

  final chooseEquipment = <int, EqSnt>{}.obs;
  final chooseEquipment1 = <int, EqSnt>{};
  final isLoading = false.obs;

  var genderList1 = <bool, EqSnt>{}.obs;
  final checkYesList = <bool>[].obs;
  final checkNoList = <bool>[].obs;
  final checkStudentList = <int, EqSnt>{}.obs;
  // final checkStudentList = <EqSnt>[].obs;

  getData() async {
    final response = await _repository.getData();
    isLoading.value = true;
    allData.value = response;
    isLoading.value = false;
  }

  getCheckVal() {
    isLoading.value = true;
    for (int i = 0; i < allData.value!.student!.length; i++) {
      checkYesList.add(false);
      checkNoList.add(false);
    }
    isLoading.value = false;
  }

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    await getData();
    await getCheckVal();
    isLoading.value = false;
  }

  Future<void> onSubmit() async {
    final response = await _repository.saveData(StudentFromRequest(
      age: allData.value?.age,
      subject: subjectController.text,
      teacherName: allData.value?.teacherName,
      equipment: chooseEquipment.values.map((e) => e).toList(),
      student: checkStudentList.values.map((e) => e).toList(),
    ));
  }
}
