import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/check_controller.dart';

class CheckBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CheckController());
  }
}

class CheckP3kScreen extends GetView<CheckController> {
  const CheckP3kScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: Get.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 2),
                      ),
                      width: Get.width,
                      child: Text(
                        'Tanggal \n pengecekan \n & \n  penanggung \n jawab'
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.dateController,
                      validator: (value) =>
                          value == '' ? 'Tidak boleh kosong' : null,
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());

                        // Show Date Picker Here
                        controller.pickDate();
                      },
                      decoration: InputDecoration(
                        label: const Text('Tanggal, bulan, tahun'),
                        focusColor: Get.theme.primaryColor,
                        suffixIcon: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: controller.personController,
                      validator: (value) =>
                          value == '' ? 'Tidak boleh kosong' : null,
                      decoration: InputDecoration(
                        label: const Text('Penanggung Jawab'),
                        focusColor: Get.theme.primaryColor,
                        suffixIcon: const Icon(
                          Icons.person,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => controller.handleAddReportButton(),
                      child: const Text('Tambah'),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
