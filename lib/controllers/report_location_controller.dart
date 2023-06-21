import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:p3k_checker/helpers/db_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class ReportLocationController extends GetxController {
  final db = DatabaseController.to.database;

  final String reportId = Get.arguments;
  List<Map<String, dynamic>> locations = [];
  List<Map<String, dynamic>> items = [];
  List<Map<String, Object?>> reportDetails = [];

  String? locationId;
  var locationController = TextEditingController();
  String locationInput = '';
  var detailFormKey = GlobalKey<FormState>();
  var controllers = [];
  ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    locations = await db
        .query('locations', where: 'report_id = ?', whereArgs: [reportId]);

    update();
  }

  deleteLocation(String locationId) async {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah anda ingin menghapus lokasi ini?',
      textCancel: 'Tidak',
      textConfirm: 'Ya',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await db.delete('locations', where: 'id = ?', whereArgs: [locationId]);
        getData();
        Get.back();
      },
    );
  }

  onAddButtonClicked() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Tambah Lokasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: locationController,
              decoration: const InputDecoration(
                label: Text('Nama Lokasi'),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                onLocationSubmited();
                Get.offNamed('/report/additional');
                locationInput = locationController.text;
                locationController.clear();
              },
              child: const Text('Tambah Lokasi'),
            ),
          ],
        ),
      ),
    );
  }

  onLocationSubmited() async {
    locationId = const Uuid().v4();
    items = await db.query('items');

    reportDetails.clear();
    controllers.clear();

    for (var item in items) {
      var value = {
        'id': const Uuid().v4(),
        'location_id': locationId,
        'item_id': item['id'],
        'exp_date': null,
        'leftover': item['initial_amount']
      };

      reportDetails.add(value);
      controllers.add(TextEditingController());
    }

    update();
  }

  onExpDateClicked(int index, String itemId) async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      int index =
          reportDetails.indexWhere((element) => element['item_id'] == itemId);

      reportDetails[index]['exp_date'] = formattedDate;
      controllers[index].text = formattedDate;

      update();
    } else {}
  }

  onLeftOverChanged(String itemId, String value) {
    int index =
        reportDetails.indexWhere((element) => element['item_id'] == itemId);

    if (value != '') {
      reportDetails[index]['leftover'] = int.parse(value);
    }
  }

  getImageFromGallery() async {
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    update();
  }

  handleSubmitReportButton() async {
    if (pickedImage == null) {
      Get.defaultDialog(middleText: 'Wajib melampirkan foto', textCancel: 'Ok');
    } else {
      if (detailFormKey.currentState!.validate()) {
        //Insert location to report
        var documentDir = await getApplicationDocumentsDirectory();
        var imagePath = '${documentDir.path}/${basename(pickedImage!.path)}';
        pickedImage?.saveTo(imagePath);
        var location = {
          'id': locationId,
          'report_id': reportId,
          'name': locationInput,
          'image_path': imagePath,
        };
        db.insert(
          'locations',
          location,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        //Insert report detail to database
        for (var detail in reportDetails) {
          await db.insert(
            'report_details',
            detail,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await Get.defaultDialog(
          middleText: 'Data berhasil ditambahkan',
          textConfirm: 'Oke',
          confirmTextColor: Colors.white,
          onConfirm: () {
            getData();
            Get.back();
            Get.back();
          },
        );
        pickedImage = null;
      }
    }
  }
}
