import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/controllers/report_location_controller.dart';

class ReportLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportLocationController());
  }
}

class ReportLocationScreen extends GetView<ReportLocationController> {
  const ReportLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Lokasi'),
        actions: [
          IconButton(
            onPressed: () => controller.onAddButtonClicked(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: controller.locations.length,
          itemBuilder: (context, index) => Card(
            child: ListTile(
              onTap: () => Get.toNamed('/report/detail',
                  arguments: controller.locations[index]['id']),
              onLongPress: () =>
                  controller.deleteLocation(controller.locations[index]['id']),
              title: Text(controller.locations[index]['name'].toString()),
            ),
          ),
        ),
      ),
    );
  }
}
