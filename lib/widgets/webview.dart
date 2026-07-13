import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  String url;
  void Function() onBack;
  WebView({super.key, required this.url,required this.onBack});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final controller = WebViewController.fromPlatformCreationParams(
      PlatformWebViewControllerCreationParams(),
    );
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },

          onHttpError: (HttpResponseError error) {},
          onUrlChange: (UrlChange change) {},
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Row(
          children: [
            BackButton(color: Color.fromRGBO(83, 83, 83, 1), onPressed: () {
              widget.onBack();
            }),
            const Text(
              'Order Checkout ',
              style: TextStyle(
                color: Color.fromRGBO(83, 83, 83, 1),
                fontSize: 16,
              ),
            ),
          ],
        ),

        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
