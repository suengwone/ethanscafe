import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/points_models.dart';
import 'points_providers.dart';

final _pointFormat = NumberFormat('#,###');

typedef QrScannerBuilder = Widget Function(
  BuildContext context,
  void Function(String code) onDetect,
);

class QrScanScreen extends ConsumerStatefulWidget {
  const QrScanScreen({super.key, this.scannerBuilder});

  final QrScannerBuilder? scannerBuilder;

  @override
  ConsumerState<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends ConsumerState<QrScanScreen> {
  bool _processing = false;
  bool _completed = false;

  Future<void> _handleCode(String code) async {
    if (_processing || _completed) return;
    setState(() => _processing = true);

    try {
      final result =
          await ref.read(pointsControllerProvider.notifier).earnFromQr(code);
      if (!mounted) return;
      setState(() {
        _completed = true;
        _processing = false;
      });
      await _showResultDialog(result);
      if (mounted) {
        context.pop();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(error))),
      );
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  Future<void> _showResultDialog(QrEarnResult result) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(LucideIcons.circleCheck, color: foxtrotGold, size: 40),
        title: const Text('적립 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${result.storeName}\n'
              '결제 ${_pointFormat.format(result.paymentAmount)}원',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '+${_pointFormat.format(result.earned)}P',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: foxtrotGold),
            ),
            const SizedBox(height: 4),
            Text(
              '잔액 ${_pointFormat.format(result.balance)}P',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is FirebaseFunctionsException) {
      return error.message ?? '적립에 실패했습니다. 다시 시도해주세요.';
    }
    if (error is FormatException) {
      return error.message;
    }
    return '적립에 실패했습니다. 다시 시도해주세요.';
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        _handleCode(code);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanner = widget.scannerBuilder?.call(context, _handleCode) ??
        MobileScanner(onDetect: _onDetect);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('스캔 적립'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          scanner,
          IgnorePointer(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '매장 결제 QR 코드를 스캔하면\n결제 금액의 10%가 자동으로 적립됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_processing)
            ColoredBox(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
