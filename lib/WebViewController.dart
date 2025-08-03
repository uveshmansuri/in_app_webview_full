import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebViewGetxController extends GetxController {
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var location_permission_ask = false.obs;
  var storage_permission_ask = false.obs;
  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    request_Permissions();
  }

  void request_Permissions() async{
    await requestStoragePermission();
    await requestLocationPermission();
  }

  void setController(InAppWebViewController controller) {
    webViewController = controller;
  }

  void reloadPage() {
    webViewController?.reload();
  }

  Future<void> goBackIfPossible() async {
    if (await webViewController?.canGoBack() ?? false) {
      webViewController?.goBack();
    } else {
      Get.back();
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      location_permission_ask.value = true;
    } else {
      final result = await Permission.location.request();
      location_permission_ask.value = result.isGranted;
      if (!result.isGranted) {
        Get.snackbar("Location Permission Denied",
            "This app requires location access to function properly.");
      }
    }
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      storage_permission_ask.value = true;
    } else {
      final result = await Permission.storage.request();
      storage_permission_ask.value = result.isGranted;
      if (!result.isGranted) {
        Get.snackbar("Storage Permission Denied",
            "This app requires storage access to function properly.");
      }
    }
  }
}