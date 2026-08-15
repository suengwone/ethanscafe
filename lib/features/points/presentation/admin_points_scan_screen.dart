import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/qr_scanner_builder.dart';
import '../domain/points_models.dart';
import 'points_providers.dart';

final _pointFormat = NumberFormat('#,###');

class AdminPointsScanScreen extends ConsumerStatefulWidget {
  const AdminPointsScanScreen({super.key, this.scannerBuilder});

  final QrScannerBuilder? scannerBuilder;

  @override
  ConsumerState<AdminPointsScanScreen> createState() =>
      _AdminPointsScanScreenState();
}

class _AdminPointsScanScreenState extends ConsumerState<AdminPointsScanScreen> {
  bool _processing = false;

  Future<void> _handleCode(String code) async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      final paymentAmount = await _showAmountDialog(code);
      if (paymentAmount == null) {
        return;
      }

      final result = await ref
          .read(pointsControllerProvider.notifier)
          .earnByMembershipId(membershipId: code, paymentAmount: paymentAmount);
      if (!mounted) return;
      await _showResultDialog(result);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(error))),
      );
      await Future<void>.delayed(const Duration(seconds: 2));
    } finally {
      if (mounted) {
        setState(() => _processing = false);
      }
    }
  }

  Future<int?> _showAmountDialog(String membershipId) {
    return showDialog<int>(
      context: context,
      builder: (context) => _AmountInputDialog(membershipId: membershipId),
    );
  }

  Future<void> _showResultDialog(PointsEarnResult result) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(LucideIcons.circleCheck, color: foxtrotGold, size: 40),
        title: const Text('포인트 적립 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${result.membershipId}\n'
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
    if (error is FormatException) {
      return error.message;
    }
    if (error is StateError) {
      return error.message;
    }
    if (error is ArgumentError) {
      return error.message?.toString() ?? '적립에 실패했습니다. 다시 시도해주세요.';
    }
    if (error is FirebaseException) {
      return error.message ?? '적립에 실패했습니다. 다시 시도해주세요.';
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
        title: const Text('회원 포인트 적립'),
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
                  '고객의 멤버십 QR 코드를 스캔한 뒤\n결제 금액을 입력하면 10%가 적립됩니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_processing)
            const ColoredBox(
              color: Colors.black54,
              child: SizedBox.expand(),
            ),
        ],
      ),
    );
  }
}

class _AmountInputDialog extends StatefulWidget {
  const _AmountInputDialog({required this.membershipId});

  final String membershipId;

  @override
  State<_AmountInputDialog> createState() => _AmountInputDialogState();
}

class _AmountInputDialogState extends State<_AmountInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('포인트 적립'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: '결제 금액 (원)',
            helperText: widget.membershipId,
          ),
          validator: (value) {
            final amount = int.tryParse(value ?? '');
            if (amount == null || amount <= 0) {
              return '1 이상의 숫자를 입력해주세요.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(int.parse(_controller.text));
            }
          },
          child: const Text('적립'),
        ),
      ],
    );
  }
}
