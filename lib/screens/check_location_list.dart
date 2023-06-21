import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/check_controller.dart';

class CheckLocationList extends GetView<CheckController> {
  const CheckLocationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Lokasi'),
        actions: [
          IconButton(
            onPressed: () => controller.showAddLocationModal(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: GetBuilder(
        init: controller,
        builder: (_) {
          return controller.locations.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada lokasi, silahkan tambahkan terlebih dahulu',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.locations.length,
                      itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onLongPress: () => controller.deleteLocation(
                              controller.locations[index]['id'].toString()),
                          leading: const Icon(Icons.place),
                          title: Text(
                            controller.locations[index]['name'].toString(),
                          ),
                        ),
                      ),
                    ),
                    UnconstrainedBox(
                      child: ElevatedButton(
                        onPressed: () => controller.onReportConfirmedButton(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber),
                        ),
                        child: const Text('Konfirmasi'),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}
