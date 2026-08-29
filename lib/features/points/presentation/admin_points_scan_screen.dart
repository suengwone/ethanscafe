import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/qr_scanner_builder.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/membership_qr_failure.dart';
import '../domain/membership_qr_token.dart';
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
      final membershipId = decodeMembershipQrToken(code);

      final paymentAmount = await _showAmountDialog(membershipId);
      if (paymentAmount == null) {
        return;
      }

      final result = await ref
          .read(pointsControllerProvider.notifier)
          .earnByMembershipId(
            membershipId: membershipId,
            paymentAmount: paymentAmount,
          );
      if (!mounted) return;
      await _showResultDialog(result);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage(error))));
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
        icon: Icon(
          LucideIcons.circleCheck,
          color: context.palette.accent,
          size: 40,
        ),
        title: Text(AppLocalizations.of(context).pointsEarnDone),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${result.membershipId}\n'
              '${AppLocalizations.of(context).pointsPaidAmount(_pointFormat.format(result.paymentAmount))}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              '+${_pointFormat.format(result.earned)}P',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: context.palette.accent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(
                context,
              ).pointsBalanceNow(_pointFormat.format(result.balance)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).commonConfirm),
          ),
        ],
      ),
    );
  }

  String _errorMessage(Object error) {
    if (error is MembershipQrException) {
      return switch (error.reason) {
        MembershipQrFailure.malformed => AppLocalizations.of(
          context,
        ).qrMalformed,
        MembershipQrFailure.expired => AppLocalizations.of(context).qrExpired,
      };
    }
    if (error is FormatException) {
      return error.message;
    }
    if (error is StateError) {
      return error.message;
    }
    if (error is ArgumentError) {
      return error.message?.toString() ??
          AppLocalizations.of(context).pointsEarnFailed;
    }
    if (error is FirebaseException) {
      return error.message ?? AppLocalizations.of(context).pointsEarnFailed;
    }
    return AppLocalizations.of(context).pointsEarnFailed;
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
    final scanner =
        widget.scannerBuilder?.call(context, _handleCode) ??
        MobileScanner(onDetect: _onDetect);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pointsScanTitle),
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
                Text(
                  AppLocalizations.of(context).pointsScanIntro,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_processing)
            const ColoredBox(color: Colors.black54, child: SizedBox.expand()),
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
      title: Text(AppLocalizations.of(context).pointsEarnDialogTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).pointsPaidAmountField,
            helperText: widget.membershipId,
          ),
          validator: (value) {
            final amount = int.tryParse(value ?? '');
            if (amount == null || amount <= 0) {
              return AppLocalizations.of(context).pointsAmountInvalid;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(int.parse(_controller.text));
            }
          },
          child: Text(AppLocalizations.of(context).pointsEarnAction),
        ),
      ],
    );
  }
}
