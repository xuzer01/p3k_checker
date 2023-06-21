import 'package:get/get.dart';
import 'package:p3k_checker/helpers/db_helper.dart';

class ReportController extends GetxController {
  final db = DatabaseController.to.database;

  List<Map<String, dynamic>> reportsGroup = [];
  late Map<dynamic, List<Map<String, dynamic>>> newReports;

  bool isLoaded = false;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    reportsGroup = await db.rawQuery(
        'SELECT strftime("%Y-%m", date) as date FROM reports GROUP BY strftime("%m-%Y", date)');

    isLoaded = true;
    update();
  }
}
