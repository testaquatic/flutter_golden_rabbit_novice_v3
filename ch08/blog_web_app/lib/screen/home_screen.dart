import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 이 위젯은 홈스크린을 표시한다.
class HomeScreen extends StatelessWidget {
  // 위젯에서 사용할 웹뷰 컨트롤러
  final WebViewController webViewController = WebViewController()
    // "https://blog.codefactory.ai"를 불러온다.
    ..loadRequest(Uri.parse("https://blog.codefactory.ai"))
    // Javascript 실행을 허용한다.
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 앱바 - 주황색, 가운데 정렬
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Code Factory"),
        centerTitle: true,
        actions: [
          // 홈버튼
          // 누르면 홈("https://blog.codefactory.ai")으로 이동한다.
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
      // 웹뷰
      body: WebViewWidget(controller: webViewController),
    );
  }
}
