import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/helpers/db_helper.dart';

class ReportDateController extends GetxController {
  final db = DatabaseController.to.database;

  String selectedDate = Get.arguments;

  List<Map<String, dynamic>> reports = [];

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  fetchData() async {
    reports = await db.query(
      'reports',
      orderBy: 'date ASC',
      where: 'strftime("%Y-%m", date) = ?',
      whereArgs: [Get.arguments],
    );

    update();
  }

  deleteReport(String reportId) {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah anda yakin?',
      textCancel: 'Tidak',
      textConfirm: 'Ya',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await db.delete('reports', where: 'id = ?', whereArgs: [reportId]);
        Get.back();
        fetchData();
      },
    );
  }
}
