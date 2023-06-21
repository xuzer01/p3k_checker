import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/check_controller.dart';

class ReportForm extends GetView<CheckController> {
  const ReportForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Buat Laporan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: controller.detailFormKey,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(2)
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                        'Tgl Exp',
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
                  for (int i = 0; i < controller.items.length; i++)
                    TableRow(
                      children: [
                        Text(
                          controller.items[i]['name'].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          controller: controller.controllers[i],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13),
                          readOnly: true,
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            // Show Date Picker Here
                            controller.onExpDateClicked(
                                i, controller.items[i]['id'].toString());
                          },
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          controller.items[i]['initial_amount'].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextFormField(
                          initialValue:
                              controller.items[i]['initial_amount'].toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) => value == '' ? 'Wajib' : null,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onChanged: (value) => controller.onLeftOverChanged(
                            controller.items[i]['id'].toString(),
                            value,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GetBuilder(
              init: controller,
              builder: (_) => controller.pickedImage == null
                  ? IconButton(
                      onPressed: () => controller.getImageFromGallery(),
                      iconSize: 50,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => controller.getImageFromGallery(),
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: Image.file(
                          File(controller.pickedImage!.path),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.handleSubmitReportButton(),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFFAD02C)),
                foregroundColor:
                    MaterialStatePropertyAll(Get.theme.primaryColor),
              ),
              child: const Text('Tambah Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}
