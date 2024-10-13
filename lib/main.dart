import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'TakePictureScreen.dart';
import 'CardLoadingApp.dart';
import 'ButtonCamera.dart';
import 'HomePage.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      // Define routes here
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/camera': (context) => TakePictureScreen(camera: firstCamera),
        '/loading': (context) => CardLoadingApp(),
      },
    ),
  );
}
