import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyMe extends StatefulWidget {
  @override
  _BuyMeState createState() => _BuyMeState();
}

class _BuyMeState extends State<BuyMe> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Buy Me a Coffee'),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: 'https://www.buymeacoffee.com/llJNUGq6UR',
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          onPageStarted: (url) {
            print('New Website: $url');
          },
        ),
      );
}
