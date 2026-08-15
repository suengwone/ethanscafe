import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../../points/presentation/qr_scan_screen.dart' show QrScannerBuilder;
import '../domain/stamp_models.dart';
import '../domain/stamp_reward.dart';
import 'stamp_providers.dart';

class AdminStampScanScreen extends ConsumerStatefulWidget {
  const AdminStampScanScreen({super.key, this.scannerBuilder});

  final QrScannerBuilder? scannerBuilder;

  @override
  ConsumerState<AdminStampScanScreen> createState() =>
      _AdminStampScanScreenState();
}

class _AdminStampScanScreenState extends ConsumerState<AdminStampScanScreen> {
  bool _processing = false;

  Future<void> _handleCode(String code) async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      final cups = await _showCupsDialog(code);
      if (cups == null) {
        return;
      }

      final result = await ref
          .read(stampControllerProvider.notifier)
          .earnByMembershipId(membershipId: code, cups: cups);
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

  Future<int?> _showCupsDialog(String membershipId) {
    return showDialog<int>(
      context: context,
      builder: (context) => _CupsInputDialog(membershipId: membershipId),
    );
  }

  Future<void> _showResultDialog(StampEarnResult result) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(LucideIcons.circleCheck, color: foxtrotGold, size: 40),
        title: const Text('스탬프 적립 완료'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              result.membershipId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '+${result.cups}개',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: foxtrotGold),
            ),
            const SizedBox(height: 4),
            Text(
              '현재 스탬프 ${result.count} / $stampRewardThreshold',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (result.rewardsIssued > 0) ...[
              const SizedBox(height: 8),
              Text(
                '🎉 무료 음료 쿠폰 ${result.rewardsIssued}장이 발급되었습니다!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
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
        title: const Text('회원 스탬프 적립'),
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
                  '고객의 멤버십 QR 코드를 스캔한 뒤\n적립할 음료 잔 수를 입력해주세요.',
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

class _CupsInputDialog extends StatefulWidget {
  const _CupsInputDialog({required this.membershipId});

  final String membershipId;

  @override
  State<_CupsInputDialog> createState() => _CupsInputDialogState();
}

class _CupsInputDialogState extends State<_CupsInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController(text: '1');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('스탬프 적립'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: '음료 잔 수',
            helperText: widget.membershipId,
          ),
          validator: (value) {
            final cups = int.tryParse(value ?? '');
            if (cups == null || cups <= 0) {
              return '1 이상의 숫자를 입력해주세요.';
            }
            if (cups > 20) {
              return '한 번에 20잔까지 적립할 수 있습니다.';
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
