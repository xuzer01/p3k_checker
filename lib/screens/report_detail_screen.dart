import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/controllers/report_detail_controller.dart';

class ReportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportDetailController());
  }
}

class ReportDetailScreen extends GetView<ReportDetailController> {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Detail'),
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return !controller.isLoaded
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(2)
                      },
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          children: [
                            Text(
                              'Nama Barang',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Exp Date',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Awal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Sisa',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ...controller.reportDetails.map(
                          (e) => TableRow(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  e['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                e['exp_date'] ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                e['initial_amount'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                e['leftover'].toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.file(
                        File(
                          controller.location['image_path'],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
