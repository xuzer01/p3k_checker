import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseController extends GetxController {
  static DatabaseController get to => Get.find();

  late Database database;

  var itemTemplate = [
    {
      'id': const Uuid().v4(),
      'name': 'Kasa Steril Terbungkus',
      'initial_amount': 10,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Perban (Lebar 5cm)',
      'initial_amount': 2,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Perban (Lebar 10cm)',
      'initial_amount': 2,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Plester (Lebar 1.25cm)',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Perban Cepat',
      'initial_amount': 10,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Kapas (25 gram)',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Kain Segitiga / Mitela',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Gunting',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Peniti',
      'initial_amount': 10,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Sarung Tangan Sekali Pakai',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Masker',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Pinset',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Lampu Senter',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Gelas Cuci Mata',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Kantong Plastik Bersih',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Aquades (100 ml Larutan Saline)',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Povidone Iodine',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Alkohol 70%',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Buku Panduan P3K di Tempat Kerja',
      'initial_amount': 1,
    },
    {
      'id': const Uuid().v4(),
      'name': 'Buku Catatan Daftar Isi Kotak',
      'initial_amount': 1,
    },
  ];

  @override
  void onInit() async {
    super.onInit();
    await initializeDatabase();
  }

  initializeDatabase() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'p3k.db');

    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE items(id TEXT PRIMARY KEY, name TEXT, initial_amount INTEGER)');

        for (var item in itemTemplate) {
          await db.insert('items', item);
        }

        await db.execute(
            'CREATE TABLE locations(id TEXT PRIMARY KEY, report_id TEXT, name TEXT, image_path TEXT)');

        await db.execute(
            'CREATE TABLE reports(id TEXT PRIMARY KEY, checker_name TEXT, date TEXT)');

        await db.execute(
            'CREATE TABLE report_details(id TEXT PRIMARY KEY, location_id TEXT, item_id TEXT, exp_date TEXT NULLABLE, leftover INTEGER)');
      },
    );
    update();
  }

  @override
  void onClose() {
    super.onClose();
    database.close();
  }
}
