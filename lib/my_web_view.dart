import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';

class MyWebView extends StatefulWidget {
  const MyWebView({Key? key}) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  WebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'about:blank',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) async {
        _webViewController = webViewController;
        String fileContent = await rootBundle.loadString('assets/index.html');
        _webViewController?.loadUrl(Uri.dataFromString(fileContent,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
      },
      javascriptChannels: <JavascriptChannel>{
        JavascriptChannel(
          name: 'messageHandler',
          onMessageReceived: (JavascriptMessage message) {
            final script = buildResponseScript(message.message);
            _webViewController?.runJavascript(script);
          },
        )
      },
    );
  }

  String buildResponseScript(String toggleState) {
    return "document.getElementById('value').innerText=\"Toggle is $toggleState\"";
  }
}
