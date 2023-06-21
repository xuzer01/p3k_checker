import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/screens/printing_preview_screen.dart';
import 'package:p3k_checker/screens/report_additional.dart';
import 'package:p3k_checker/screens/report_date_screen.dart';
import 'package:p3k_checker/screens/report_detail_screen.dart';
import 'package:p3k_checker/screens/report_form.dart';
import 'package:p3k_checker/screens/report_locations_screen.dart';

import 'package:p3k_checker/screens/report_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:p3k_checker/screens/splash_screen.dart';

import 'screens/check_location_list.dart';
import 'screens/check_p3k_screen.dart';
import 'screens/home_screen.dart';
import 'utility.dart';

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'P3K Checker',
      theme: ThemeData(
        primarySwatch: Utility.generateMaterialColorFromColor(
          const Color(0xFF1D2A56),
        ),
      ),
      initialRoute: '/splash',
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/splash',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
          transition: Transition.cupertino,
        ),
        GetPage(
          name: '/check',
          page: () => const CheckP3kScreen(),
          binding: CheckBinding(),
        ),
        GetPage(
          name: '/check/location',
          page: () => const CheckLocationList(),
        ),
        GetPage(
          name: '/check/form',
          page: () => const ReportForm(),
        ),
        GetPage(
          name: '/report',
          page: () => const ReportScreen(),
          binding: ReportBinding(),
        ),
        GetPage(
          name: '/report/dates',
          page: () => const ReportDateScreen(),
          binding: ReportDateBinding(),
        ),
        GetPage(
          name: '/report/locations',
          page: () => const ReportLocationScreen(),
          binding: ReportLocationBinding(),
        ),
        GetPage(
          name: '/report/additional',
          page: () => const ReportAddtionalScreen(),
        ),
        GetPage(
          name: '/report/detail',
          page: () => const ReportDetailScreen(),
          binding: ReportDetailBinding(),
        ),
        GetPage(
          name: '/report/print',
          page: () => const PrintingPreviewScreen(),
          binding: PrintingBinding(),
        )
      ],
    );
  }
}
