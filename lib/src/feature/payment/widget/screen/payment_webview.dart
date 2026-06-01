import 'dart:async';
import 'dart:io';

import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class const PaymentWebView({required final String url, super.key}) extends StatefulWidget {
  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState() extends State<PaymentWebView> {
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_initWebViewController());
  }

  Future<void> _initWebViewController() async {
    _controller = WebViewController();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    final controller = WebViewController.fromPlatformCreationParams(params);

    await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    await controller.setNavigationDelegate(
      NavigationDelegate(
        onWebResourceError: (error) {
          debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
  url: ${error.url}
          ''');
        },
        onNavigationRequest: (request) async {
          final String url = request.url;
          if (url.startsWith(RegExp('^bank.*')) ||
              url.startsWith(RegExp('^sberpay.*')) ||
              url.startsWith(RegExp('^mirpay.*'))) {
            context.pop();
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } else {
              if (mounted) {
                showErrorMessage(context, context.l10n.appOpeningFailed);
              }
            }
          }

          if (url.startsWith('https://yoomoney.ru/checkout/payments/v2/success')) {
            if (mounted) {
              context.pop(true);
            }
          }
          if (url.startsWith('https://your-return-url.com')) {
            if (mounted) {
              context.pop(false);
            }
          }

          return NavigationDecision.navigate;
        },
      ),
    );

    if (kIsWeb || !Platform.isMacOS) {
      await controller.setBackgroundColor(AppColors.baseBgPrimary);
    }

    if (controller.platform is AndroidWebViewController) {
      await AndroidWebViewController.enableDebugging(true);
      await (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    await controller.loadRequest(Uri.parse(widget.url));
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, surfaceTintColor: Colors.transparent),
      body: SafeArea(child: _controller != null ? WebViewWidget(controller: _controller!) : const SizedBox.shrink()),
    );
  }
}
