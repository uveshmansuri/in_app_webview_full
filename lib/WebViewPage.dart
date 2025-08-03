import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'WebViewController.dart';

class WebViewPage extends StatelessWidget {
  final webController = Get.put(WebViewGetxController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await webController.goBackIfPossible();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("In App WebView"),
        ),
        body: Obx(() {
          if (webController.hasError.value) {
            return Center(
              child: Text(
                "Error loading page:\n${webController.errorMessage.value}",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
          return Stack(
            children: [
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("https://the-internet.herokuapp.com/"),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  supportZoom: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  useOnDownloadStart: true,
                  useHybridComposition: true,
                  supportMultipleWindows: true,
                  geolocationEnabled: true,
                ),
                onWebViewCreated: (controller) {
                  webController.setController(controller);
                },
                onLoadStart: (controller, url) {
                  webController.isLoading.value = true;
                  webController.hasError.value = false;
                },
                onLoadStop: (controller, url) {
                  webController.isLoading.value = false;
                },
                shouldOverrideUrlLoading: (controller, navAction) async {
                  return NavigationActionPolicy.ALLOW;
                },
                onDownloadStartRequest: (controller, req) async {
                  final url = req.url.toString();
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  } else {
                    Get.snackbar("Download Error", "Cannot open download URL");
                  }
                },
                androidOnPermissionRequest: (controller, origin, resources) async {
                  return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT,
                  );
                },
                androidOnGeolocationPermissionsShowPrompt: (controller, origin) async {
                  return GeolocationPermissionShowPromptResponse(
                    origin: origin,
                    allow: true,
                    retain: true,
                  );
                },
                onJsAlert: (controller, jsAlertRequest) async {
                  await Get.defaultDialog(
                    title: "Alert",
                    content: Text(jsAlertRequest.message.toString()),
                    confirm: TextButton(
                      onPressed: () => Get.back(),
                      child: Text("OK"),
                    ),
                  );
                  return JsAlertResponse(
                    handledByClient: true,
                    action: JsAlertResponseAction.CONFIRM,
                  );
                },
                onCreateWindow: (controller, request) async {
                  controller.loadUrl(urlRequest: request.request);
                  return true;
                },
                onReceivedHttpAuthRequest: (controller, challenge) async {
                  String username = "";
                  String password = "";
                  bool confirmed = false;

                  await Get.dialog(
                    AlertDialog(
                      title: Text("HTTP Auth Required"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(labelText: "Username"),
                            onChanged: (value) => username = value,
                          ),
                          TextField(
                            decoration: InputDecoration(labelText: "Password"),
                            obscureText: true,
                            onChanged: (value) => password = value,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            confirmed = false;
                            Get.back();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            confirmed = true;
                            Get.back();
                          },
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  );

                  if (confirmed) {
                    return HttpAuthResponse(
                      action: HttpAuthResponseAction.PROCEED,
                      username: username,
                      password: password,
                      permanentPersistence: true,
                    );
                  } else {
                    return HttpAuthResponse(
                      action: HttpAuthResponseAction.CANCEL,
                    );
                  }
                },
              ),
              if (webController.isLoading.value)
                Center(child: CircularProgressIndicator()),
            ],
          );
        }),
      ),
    );
  }
}