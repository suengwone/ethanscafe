import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/payment_models.dart';
import '../domain/payments_repository.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

const tossClientKey = String.fromEnvironment(
  'TOSS_CLIENT_KEY',
  defaultValue: 'test_ck_D5GePWvyJnrK0W0k6q8gLzN97Eoq',
);

const _successUrl = 'https://ethanscafe.app/payments/success';
const _failUrl = 'https://ethanscafe.app/payments/fail';
const _cancelCode = 'PAY_PROCESS_CANCELED';

final _amountFormat = NumberFormat('#,###');

typedef PaymentWebViewBuilder = Widget Function(BuildContext context);

class TossPaymentScreen extends StatefulWidget {
  const TossPaymentScreen({
    super.key,
    required this.request,
    required this.repository,
    this.clientKey = tossClientKey,
    this.webViewBuilder,
  });

  final PaymentRequest request;
  final PaymentsRepository repository;
  final String clientKey;
  final PaymentWebViewBuilder? webViewBuilder;

  @override
  State<TossPaymentScreen> createState() => _TossPaymentScreenState();
}

class _TossPaymentScreenState extends State<TossPaymentScreen> {
  WebViewController? _controller;
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    if (widget.webViewBuilder == null) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(context.palette.background)
        ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: _handleNavigation),
        )
        ..loadHtmlString(_paymentHtml(), baseUrl: 'https://ethanscafe.app');
    }
  }

  String _paymentHtml() {
    final params = jsonEncode({
      'amount': widget.request.amount,
      'orderId': widget.request.orderId,
      'orderName': widget.request.orderName,
      'successUrl': _successUrl,
      'failUrl': _failUrl,
    });
    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="background-color:#181512">
<script src="https://js.tosspayments.com/v1/payment"></script>
<script>
  TossPayments(${jsonEncode(widget.clientKey)}).requestPayment('카드', $params);
</script>
</body>
</html>''';
  }

  FutureOr<NavigationDecision> _handleNavigation(NavigationRequest navigation) {
    final url = navigation.url;
    if (url.startsWith(_successUrl)) {
      _confirm(Uri.parse(url));
      return NavigationDecision.prevent;
    }
    if (url.startsWith(_failUrl)) {
      _handleFail(Uri.parse(url));
      return NavigationDecision.prevent;
    }
    final uri = Uri.tryParse(url);
    if (uri != null && !const {'http', 'https', 'about'}.contains(uri.scheme)) {
      unawaited(
        launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        ).catchError((_) => false),
      );
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _confirm(Uri uri) async {
    final paymentKey = uri.queryParameters['paymentKey'];
    final orderId = uri.queryParameters['orderId'];
    final amount = int.tryParse(uri.queryParameters['amount'] ?? '');
    if (paymentKey == null ||
        orderId != widget.request.orderId ||
        amount != widget.request.amount) {
      _finishWithError(AppLocalizations.of(context).paymentCheckFailed);
      return;
    }

    setState(() => _confirming = true);
    try {
      final approval = await widget.repository.confirmPayment(
        paymentKey: paymentKey,
        orderId: widget.request.orderId,
        amount: widget.request.amount,
      );
      if (!mounted) {
        return;
      }
      Navigator.pop(context, approval);
    } catch (_) {
      _finishWithError(AppLocalizations.of(context).paymentApproveFailed);
    }
  }

  void _handleFail(Uri uri) {
    if (uri.queryParameters['code'] == _cancelCode) {
      Navigator.pop(context);
      return;
    }
    _finishWithError(
      uri.queryParameters['message'] ??
          AppLocalizations.of(context).paymentFailed,
    );
  }

  void _finishWithError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).paymentTitle)),
      body: Column(
        children: [
          _PaymentSummary(request: widget.request),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (widget.webViewBuilder != null)
                  widget.webViewBuilder!(context)
                else if (controller != null)
                  WebViewWidget(controller: controller),
                if (_confirming)
                  ColoredBox(
                    color: context.palette.background.withValues(alpha: 0.8),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context).paymentApproving,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSummary extends StatelessWidget {
  const _PaymentSummary({required this.request});

  final PaymentRequest request;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        foxtrotScreenHPadding,
        14,
        foxtrotScreenHPadding,
        14,
      ),
      decoration: BoxDecoration(
        color: context.palette.surface,
        border: Border(bottom: BorderSide(color: context.palette.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.palette.card,
              borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
              border: Border.all(color: context.palette.border),
            ),
            child: Icon(
              LucideIcons.creditCard,
              color: context.palette.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request.orderName.keepWord,
                  style: textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  AppLocalizations.of(context).paymentProviderNotice,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            AppLocalizations.of(
              context,
            ).priceWon(_amountFormat.format(request.amount)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              color: context.palette.accentSoft,
            ),
          ),
        ],
      ),
    );
  }
}
