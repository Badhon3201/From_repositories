import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testkj/feature/models/student_from_request.dart';

import '../view_models/view_models.dart';

class FromView extends StatelessWidget {
  FromView({
    Key? key,
  }) : super(key: key) {
    controller = Get.put(ViewModels());
  }

  late final ViewModels controller;

  @override
  Widget build(BuildContext context) {
    var sizedBox = const SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student From"),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBox,
                    Text(
                      controller.allData.value?.teacherName ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    sizedBox,
                    Text(
                      controller.allData.value?.age.toString() ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    sizedBox,
                    TextFormField(
                      controller: controller.subjectController,
                      focusNode: controller.focus,
                      decoration: InputDecoration(
                        hintText: 'Subject',
                        contentPadding: const EdgeInsets.all(10),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                    sizedBox,
                    const Text(
                      "Equipment",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    sizedBox,
                    SizedBox(
                      height: 300,
                      width: Get.width,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            controller.allData.value?.equipment?.length ?? 0,
                        itemBuilder: (context, index) {
                          var item =
                              controller.allData.value?.equipment?[index];
                          return ListTile(
                            title: Text(item?.name ?? ""),
                            subtitle: Row(
                              children: [
                                Obx(() {
                                  return Radio<int>(
                                    value: 1,
                                    groupValue:
                                        controller.chooseEquipment[index]?.key,
                                    onChanged: (v) {
                                      controller.chooseEquipment1[index] =
                                          EqSnt(key: v, name: item?.name);
                                      controller.chooseEquipment
                                          .addAll(controller.chooseEquipment1);
                                      // controller.chooseEquipment.value = v!;
                                    },
                                  );
                                }),
                                Obx(() {
                                  return Radio<int>(
                                    value: 2,
                                    groupValue:
                                        controller.chooseEquipment[index]?.key,
                                    onChanged: (v) {
                                      controller.chooseEquipment1[index] =
                                          EqSnt(key: v, name: item?.name);
                                      controller.chooseEquipment
                                          .addAll(controller.chooseEquipment1);
                                      // controller.chooseEquipment.value = v!;
                                      print(controller.chooseEquipment);
                                    },
                                  );
                                })
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    sizedBox,
                    const Text(
                      "Student",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 300,
                      width: Get.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.allData.value?.student?.length,
                        itemBuilder: (context, index) {
                          var item = controller.allData.value?.student?[index];
                          return ListTile(
                            title: Text(item?.name ?? ""),
                            subtitle: Row(
                              children: [
                                Obx(() {
                                  return Checkbox(
                                    value: controller.checkYesList[index],
                                    onChanged: (bool? v) {
                                      controller.checkYesList[index] = v!;
                                      if (controller.checkYesList[index] ==
                                          true) {
                                        controller.checkNoList[index] = false;
                                      } else {
                                        // controller.checkYesList[index] = true;
                                      }
                                      controller.checkStudentList[index] =
                                          EqSnt(
                                              name: item?.name,
                                              key: controller
                                                          .checkNoList[index] ==
                                                      true
                                                  ? 0
                                                  : 1);
                                      print("Hlww${controller.checkYesList}");
                                      print("Hii$v");
                                      // controller.getAttendanceListErrorIndex();
                                    },
                                  );
                                }),
                                Obx(() {
                                  return Checkbox(
                                    value: controller.checkNoList[index],
                                    onChanged: (bool? v) {
                                      controller.checkNoList[index] = v!;
                                      if (controller.checkNoList[index] ==
                                          true) {
                                        controller.checkYesList[index] = false;
                                      }
                                      controller.checkStudentList[index] =
                                          EqSnt(
                                              name: item?.name,
                                              key: controller
                                                          .checkNoList[index] ==
                                                      true
                                                  ? 0
                                                  : 1);
                                      print(controller.checkYesList);
                                      print("Hlw${controller.checkNoList}");
                                      print("Hi$v");
                                    },
                                  );
                                }),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.onSubmit();
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        onLongPress: () {
                          controller.buttonFontColor.value = Colors.red;
                          // Timer(const Duration(seconds: 1), () {
                          //   controller.buttonFontColor.value = Colors.amber;
                          // });
                          Timer(const Duration(seconds: 2), () {
                            controller.buttonFontColor.value = Colors.orange;
                            controller.isSuccess.value = true;
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.buttonFontColor.value,
                                  width: 5),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100)),
                          child: Center(
                            child: controller.isSuccess.value
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30,
                                  )
                                : const Text(
                                    "2.45",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
