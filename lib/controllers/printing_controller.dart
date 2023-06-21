import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:p3k_checker/helpers/db_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PrintingController extends GetxController {
  static PrintingController get to => Get.find();

  final db = DatabaseController.to.database;

  DateTime currentMonth = DateFormat('yyyy-MM').parse(Get.arguments);
  var reports = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>> details = [];

  MemoryImage? bumnLogo;
  MemoryImage? pelindoLogo;

  @override
  onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    var reports = await db.rawQuery(
        'SELECT reports.date as date, reports.checker_name, locations.name as location_name, locations.id as location_id FROM reports INNER JOIN locations ON locations.report_id = reports.id WHERE strftime("%Y-%m", reports.date) = ?',
        [Get.arguments]);

    this.reports.assignAll(reports);

    details = await db.rawQuery(
        'SELECT locations.id as location_id, items.name as item_name, report_details.exp_date, items.initial_amount, report_details.leftover FROM reports INNER JOIN locations ON locations.report_id = reports.id INNER JOIN report_details ON report_details.location_id = locations.id INNER JOIN items ON items.id = report_details.item_id WHERE strftime("%Y-%m", reports.date) = ?',
        [Get.arguments]);

    // Utility.printPretty(
    //     details.groupListsBy((element) => element['location_id']));

    bumnLogo = MemoryImage(
        (await rootBundle.load('assets/images/bumn_logo.png'))
            .buffer
            .asUint8List());

    pelindoLogo = MemoryImage(
        (await rootBundle.load('assets/images/pelindo_logo.png'))
            .buffer
            .asUint8List());
  }

  buildItemNumber(List<Map<String, dynamic>> items) {
    List<Map<String, dynamic>> result = [];

    for (int i = 0; i < items.length; i++) {
      var values = {
        'no': i + 1,
        'item_name': items[i]['item_name'],
        'exp_date': items[i]['exp_date'],
        'initial_amount': items[i]['initial_amount'],
        'leftover': items[i]['leftover']
      };
      result.add(values);
    }
    return result;
  }

  Future<Uint8List> makePdf() async {
    await getData();
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        maxPages: 20,
        margin: const EdgeInsets.all(20),
        header: (context) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(bumnLogo!, width: 125),
            Column(
              children: [
                Text(
                  'CHEKLIST ISI KOTAK P3K \n PERIODE TAHUN ${currentMonth.year} \n PT PELINDO TERMINAL PETIKEMAS SEMARANG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Bulan ${DateFormat("MMMM", "id").format(currentMonth)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Image(pelindoLogo!, width: 125),
          ],
        ),
        build: (context) => [
          Center(
            child: Wrap(
              spacing: 50,
              runSpacing: 10,
              children: [
                for (var report in reports)
                  Container(
                    width: 500 / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Lokasi: ${report["location_name"]}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Tanggal: ${report["date"]}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Penanggung Jawab: ${report["checker_name"]}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Table(
                          border: TableBorder.all(),
                          columnWidths: {
                            0: const FixedColumnWidth(50),
                            1: const FixedColumnWidth(250),
                            2: const FixedColumnWidth(120),
                            3: const FixedColumnWidth(90),
                            4: const FixedColumnWidth(90)
                          },
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          children: [
                            TableRow(
                              children: [
                                Text(
                                  'No',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Nama Barang',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'EXP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Jumlah Awal',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Jumlah Akhir',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            for (var item in buildItemNumber(details
                                .where((element) =>
                                    element['location_id'] ==
                                    report['location_id'])
                                .toList()))
                              TableRow(
                                children: [
                                  Text(
                                    item['no'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                  Text(
                                    item['item_name'],
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                  Text(
                                    item['exp_date'] ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                  Text(
                                    item['initial_amount'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                  Text(
                                    item['leftover'].toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mengetahui,'),
                    Text('Superintendent HSSE'),
                    Align(
                      child: Text('ttd'),
                    ),
                    SizedBox(height: 50),
                    Align(
                      child: Text('Nasikhudin'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return pdf.save();
  }
}
