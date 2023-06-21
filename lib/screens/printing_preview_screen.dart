import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/controllers/printing_controller.dart';
import 'package:printing/printing.dart';

class PrintingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrintingController());
  }
}

class PrintingPreviewScreen extends GetView<PrintingController> {
  const PrintingPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(),
      body: PdfPreview(
        build: (format) => controller.makePdf(),
      ),
    );
  }
}
