import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  final _progress = 0.obs;
  var argument = Get.arguments;
  var title = '';
  var url = '';
  var sessionToken = '';

  // late WebViewController _webViewController;

  @override
  void initState() {
    readArgument();
    // initializeWebController();
    super.initState();
  }

  void readArgument() {
    if (argument.keys.contains('argTitle')) {
      title = argument['argTitle']!;
    }
    if (argument.keys.contains('argUrl')) {
      url = argument['argUrl']!;
    }
    if (argument.keys.contains('argSessionToken')) {
      sessionToken = argument['argSessionToken']!;
    }
  }

  // void initializeWebController() {
  //   _webViewController = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           _progress.value = progress;
  //         },
  //         onWebResourceError: (WebResourceError error) {
  //           _showErrorDialog(context, error.description);
  //         },
  //         onNavigationRequest: (NavigationRequest request) {
  //           if (request.url.startsWith('https://www.youtube.com/')) {
  //             return NavigationDecision.prevent;
  //           }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     )
  //     ..loadRequest(Uri.parse(url));
  //
  //   // _webViewController.ges
  // }

  @override
  Widget build(BuildContext context) {
    // Ensuring URL starts with http/https
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    CookieManager cookieManager = CookieManager.instance();

    // Set session token cookie
    sessionToken = sessionToken.replaceAll('session_id=', '');
    Cookie cookie =
        Cookie(name: "session_id", value: sessionToken, domain: url);

    cookieManager.setCookie(
        url: WebUri(url), name: "session_id", value: sessionToken);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          title.isEmpty ? 'Web Page' : title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Customize your app bar color
      ),
      body: Stack(
        children: [
          ///TODO
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(url)),

            onGeolocationPermissionsShowPrompt:
                (InAppWebViewController controller, String origin) async {
              return GeolocationPermissionShowPromptResponse(
                origin: origin,
                allow: true,
                retain: true,
              );
            },
            initialSettings: InAppWebViewSettings(
              geolocationEnabled: true,
              // android: AndroidInAppWebViewOptions(
              //   useWideViewPort: true,
              //   geolocationEnabled: true,
              // ),
              // ios: IOSInAppWebViewOptions(
              //   allowsInlineMediaPlayback: true,
              // ),
            ),
            onPermissionRequest: (
              InAppWebViewController controller,
              PermissionRequest request,
            ) async {
              return PermissionResponse(resources: [
                PermissionResourceType.GEOLOCATION,
              ], action: PermissionResponseAction.GRANT);
            },
          ),
          // WebViewWidget(
          //   controller: _webViewController,
          //   // initialUrl: url,
          //   // javascriptMode: JavaScriptMode.unrestricted,
          //   // initialCookies: [cookie],
          //   // onWebViewCreated: (controller) {
          //   //   _webViewController = controller;
          //   // },
          //   // onProgress: (int progress) {
          //   //   _progress.value = progress;
          //   // },
          //   // onPageStarted: (String url) {
          //   //   // Handle page start if needed
          //   // },
          //   // onPageFinished: (String url) {
          //   //   // Handle page load complete
          //   // },
          //   // onWebResourceError: (WebResourceError error) {
          //   //   _showErrorDialog(context, error.description);
          //   // },
          //   // navigationDelegate: (NavigationRequest request) {
          //   //   if (request.url.startsWith('https://www.youtube.com/')) {
          //   //     return NavigationDecision.prevent;
          //   //   }
          //   //   return NavigationDecision.navigate;
          //   // },
          //   // gestureNavigationEnabled: true,
          //   // geolocationEnabled: true,
          // ),
          // Obx(() => _buildProgressIndicator()),
        ],
      ),
    );
  }

  // Setting cookies for session
  Future<void> _setCookie(String name, String value, String domain) async {
    // await _webViewController.runJavascriptReturningResult('''
    //     document.cookie = "$name=$value";
    //   ''');
  }

  // Error dialog display
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Error loading page: $errorMessage'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Get.back();
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  // Build progress indicator
  Widget _buildProgressIndicator() {
    if (_progress.value < 100) {
      return Center(
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: CircularProgressIndicator(
            value: _progress.value / 100,
            backgroundColor: Colors.blue.withOpacity(0.5),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
