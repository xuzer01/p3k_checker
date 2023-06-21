import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:p3k_checker/helpers/db_helper.dart';
import 'package:p3k_checker/screens/report_form.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class CheckController extends GetxController {
  var db = DatabaseController.to.database;

  String reportId = '';
  String locationId = '';
  DateTime? pickedDate;
  List<Map<String, Object?>> items = [];
  List<TextEditingController> controllers = [];
  List<Map<String, Object?>> locations = [];

  var formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController personController = TextEditingController();

  var locationFormKey = GlobalKey<FormState>();
  TextEditingController locationController = TextEditingController();
  String? locationInput;

  final ImagePicker imagePicker = ImagePicker();
  XFile? pickedImage;
  List<Map<String, Object?>> reportDetails = [];
  var detailFormKey = GlobalKey<FormState>();

  @override
  onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    items = await db.query('items');
    locations = await db.query(
      'locations',
      where: 'report_id = ?',
      whereArgs: [reportId],
    );
    update();
  }

  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      this.pickedDate = pickedDate;

      //you can implement different kind of Date Format here according to your requirement
      dateController.text = formattedDate;
      update();
    } else {}
  }

  deleteLocation(String location_id) {
    Get.defaultDialog(
      title: 'Hapus lokasi',
      middleText: 'Apakah anda yakin?',
      textCancel: 'Tidak',
      textConfirm: 'Ya',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await db.delete('locations', where: 'id = ?', whereArgs: [location_id]);
        getData();
        Get.back();
      },
    );
  }

  handleAddReportButton() {
    if (formKey.currentState!.validate()) {
      reportId = const Uuid().v4();
      Get.toNamed('/check/location');
    }
  }

  showAddLocationModal() {
    Get.dialog(
      AlertDialog(
        title: const Text('Tambah Lokasi'),
        content: Form(
          key: locationFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: locationController,
                validator: (value) => value == '' ? 'Wajib diisi' : null,
                decoration: const InputDecoration(
                  label: Text('Nama lokasi'),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                  onPressed: () => handleAddLocationButton(),
                  child: const Text('Buat Laporan'))
            ],
          ),
        ),
      ),
    );
  }

  handleAddLocationButton() {
    if (locationFormKey.currentState!.validate()) {
      locationId = const Uuid().v4();
      pickedImage = null;
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
      locationInput = locationController.text;
      locationController.clear();
      Get.off(() => const ReportForm());
    }
  }

  onLeftOverChanged(String itemId, String value) {
    int index =
        reportDetails.indexWhere((element) => element['item_id'] == itemId);
    if (value != '') {
      reportDetails[index]['leftover'] = int.parse(value);
    }
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

  getImageFromGallery() async {
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    update();
  }

  handleSubmitReportButton() async {
    if (pickedImage == null) {
      Get.defaultDialog(middleText: 'Wajib melampirkan foto', textCancel: 'Ok');
    } else {
      if (detailFormKey.currentState!.validate()) {
        //Insert report to database
        var report = {
          'id': reportId,
          'checker_name': personController.text,
          'date': dateController.text,
        };
        await db.insert(
          'reports',
          report,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

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
      }
    }
  }

  onReportConfirmedButton() {
    Get.defaultDialog(
      middleText: 'Yakin?',
      textCancel: 'Tidak',
      textConfirm: 'Ya',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.offAllNamed('/');
      },
    );
  }
}
