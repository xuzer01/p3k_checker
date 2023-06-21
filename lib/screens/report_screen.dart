import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:p3k_checker/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportController());
  }
}

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Rekap Data'),
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return !controller.isLoaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.reportsGroup.isEmpty
                  ? const Center(child: Text('Tidak ada laporan'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.reportsGroup.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          onTap: () => Get.toNamed(
                            '/report/dates',
                            arguments: controller.reportsGroup[index]['date'],
                          ),
                          title: Text(
                            DateFormat('MMMM yyyy', 'id').format(
                              DateFormat('yyyy-MM').parse(
                                controller.reportsGroup[index]['date'],
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
