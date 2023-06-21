import 'package:get/get.dart';
import 'package:p3k_checker/helpers/db_helper.dart';

class ReportDetailController extends GetxController {
  final db = DatabaseController.to.database;

  late Map<String, dynamic> location;
  List<Map<String, dynamic>> reportDetails = [];

  bool isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    location = (await db
            .query('locations', where: 'id = ?', whereArgs: [Get.arguments]))
        .first;
    reportDetails = await db.rawQuery(
        'SELECT * FROM report_details INNER JOIN items ON items.id = report_details.item_id WHERE report_details.location_id = "${Get.arguments}"');
    isLoaded = true;
    update();
  }
}
