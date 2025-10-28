import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  WebViewController webViewController = WebViewController()
    ..loadRequest(Uri.parse("https://blog.codefactory.ai"))
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Code Factory"),
        // 가운데 정렬
        centerTitle: true,
        // 액션 버튼을 추가한다.
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
