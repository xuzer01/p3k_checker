import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:p3k_checker/controllers/initial_controller.dart';
import 'package:p3k_checker/helpers/db_helper.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(InitialController());
    Get.put(DatabaseController());
  }
}

class SplashScreen extends GetView<InitialController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/bumn_logo.png',
                    width: 100,
                  ),
                  Image.asset(
                    'assets/images/pelindo_logo.png',
                    width: 100,
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Image.asset('assets/images/splash_background.png'),
                Center(
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 300,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 200,
              child: TextField(
                onSubmitted: (value) => controller.login(value),
                obscureText: true,
                decoration: InputDecoration(
                  isDense: true,
                  label: const Text('Password'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  suffixIcon: const Icon(Icons.arrow_right_alt),
                ),
              ),
            ),
            Column(
              children: const [
                Text(
                  'PENGECEKAN KOTAK P3K ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'TERMINAL PETIKEMAS SEMARANG',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'SUBDIV HSSE',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
