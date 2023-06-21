import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:p3k_checker/controllers/report_date_controller.dart';

class ReportDateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportDateController());
  }
}

class ReportDateScreen extends GetView<ReportDateController> {
  const ReportDateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Rekap Data'),
        actions: [
          IconButton(
              onPressed: () => Get.toNamed('/report/print',
                  arguments: controller.selectedDate),
              icon: const Icon(Icons.print))
        ],
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.reports.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                onTap: () => Get.toNamed(
                  '/report/locations',
                  arguments: controller.reports[index]['id'],
                ),
                onLongPress: () => controller.deleteReport(
                  controller.reports[index]['id'].toString(),
                ),
                title: Text(
                  DateFormat('dd MMMM yyyy', 'id').format(
                    DateTime.parse(
                      controller.reports[index]['date'],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
