import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/full_splash_background.png'),
              colorFilter: ColorFilter.mode(
                Colors.black45,
                BlendMode.darken,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'P3K \n CHECKER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    color: Color(0xFFFAD02C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed('/check'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFAD02C),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'CHECK P3K',
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Get.toNamed('/report'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 250,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFAD02C),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'REKAP DATA',
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'SUBDIV HSSE \n TPKS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    color: Color(0xFFFAD02C),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
