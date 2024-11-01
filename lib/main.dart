import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'views/TakePictureScreen.dart';
import 'views/CardLoadingApp.dart';
import 'views/ButtonCamera.dart';
import 'views/HomePage.dart';
import 'views/StartScreen.dart';
import 'views/LoginPage.dart';
import 'views/SignUpPage.dart';
import 'views/ProfilePage.dart';
import 'views/History.dart';
import 'views/TakePictureScreenEmotion.dart';
import 'controller/reservation_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  // Initialize the controller
  Get.put(ReservationController());

  runApp(
    GetMaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const StartScreen()),
        GetPage(name: '/home', page: () => const HomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUpPage()),
        GetPage(name: '/camera', page: () => TakePictureScreen()),
        GetPage(name: '/loading', page: () => const CardLoadingApp()),
        GetPage(name: '/profile', page: () => ProfilePage()),
        GetPage(name: '/history', page: () => History()),
        GetPage(name: '/cameraEmotion', page: () => TakePictureScreenEmotion()),
      ],
    ),
  );
}
