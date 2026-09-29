import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 웹뷰 컨트롤러 선언
  final webViewController = WebViewController();

  @override
  void initState() {
    webViewController
      ..loadRequest(Uri.parse('https://blog.codefactory.ai'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Code Factory'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              webViewController.loadRequest(
                Uri.parse('https://blog.codefactory.ai'),
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
