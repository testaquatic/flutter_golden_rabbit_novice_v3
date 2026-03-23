import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  // 웹뷰 컨트롤러
  final WebViewController webViewController = WebViewController()
    ..loadRequest(Uri.parse("https://blog.codefactory.ai"))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  /// 홈스크린
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Code Factory"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              webViewController.loadRequest(
                Uri.parse("https://blog.codefactory.ai"),
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
