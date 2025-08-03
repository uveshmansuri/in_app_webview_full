import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'WebViewPage.dart';
import 'WebViewController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(WebViewGetxController);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'In-App WebView',
      home: WebViewPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}