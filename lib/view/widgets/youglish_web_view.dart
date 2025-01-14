import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:eng_dict/view/utils/utils.dart';
import 'package:eng_dict/view/widgets/banner_ads_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class YouglishWebView extends StatefulWidget {
  String word;

  YouglishWebView({required this.word, super.key});

  @override
  State<YouglishWebView> createState() => _YouglishWebViewState();
}

class _YouglishWebViewState extends State<YouglishWebView> {
  bool isLoading = true;

  late WebViewController _controller;

  @override
  void initState() {
    initWebController();
    super.initState();
  }

  Future<void> initWebController() async {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Mobile Safari/537.36")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            if (isLoading) {
              setState(() {
                isLoading = false;
              });
            }
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
                  Page resource error:
                    code: ${error.errorCode}
                    description: ${error.description}
                    errorType: ${error.errorType}
                    isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      );

    _controller = controller;
    WebViewCookieManager().clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(left: Constant.kMarginLarge),
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close)),
              )
            ],
          ),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  gestureRecognizers: gestureRecognizers,
                  controller: _controller
                    ..loadHtmlString(
                      RequestHandler.buildYougLishHTML(
                          Utils.URLEncode(widget.word)),
                    ),
                ),
                if (isLoading) const Center(child: CircularProgressIndicator())
              ],
            ),
          ),
          BannerAdsBox(key: UniqueKey())
        ],
      ),
    );
  }
}
