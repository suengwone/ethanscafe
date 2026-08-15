import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/points_models.dart';
import 'points_providers.dart';

final _amountFormat = NumberFormat('#,###');
final _timeFormat = DateFormat('HH:mm');

class StaffQrIssueScreen extends ConsumerStatefulWidget {
  const StaffQrIssueScreen({super.key});

  @override
  ConsumerState<StaffQrIssueScreen> createState() => _StaffQrIssueScreenState();
}

class _StaffQrIssueScreenState extends ConsumerState<StaffQrIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController(text: '폭스트롯');
  final _amountController = TextEditingController();

  IssuedQrToken? _issuedToken;
  bool _issuing = false;

  @override
  void dispose() {
    _storeNameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _issue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _issuing = true);

    try {
      final token = await ref.read(qrIssueRepositoryProvider).issue(
            paymentAmount: int.parse(_amountController.text),
            storeName: _storeNameController.text,
          );
      if (!mounted) return;
      setState(() {
        _issuedToken = token;
        _issuing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _issuing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('적립 QR 발급에 실패했습니다. 다시 시도해주세요.')),
      );
    }
  }

  void _reset() {
    setState(() {
      _issuedToken = null;
      _amountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    final issuedToken = _issuedToken;

    return Scaffold(
      appBar: AppBar(
        title: const Text('적립 QR 발급'),
      ),
      body: !isAdmin
          ? const Center(child: Text('직원 전용 기능입니다.'))
          : SingleChildScrollView(
              padding: foxtrotListPadding,
              child: issuedToken == null
                  ? _buildForm()
                  : _IssuedTokenSection(token: issuedToken, onReset: _reset),
            ),
    );
  }

  Widget _buildForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '고객 결제 금액을 입력하면 1회용 적립 QR이 발급됩니다.\n'
                '발급된 QR은 5분 동안 유효합니다.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(labelText: '매장명'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? '매장명을 입력해주세요.'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: '결제 금액 (원)',
                  helperText: '결제 금액의 10%가 적립됩니다.',
                ),
                validator: (value) {
                  final amount = int.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return '1 이상의 숫자를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _issuing ? null : _issue,
                icon: const Icon(LucideIcons.qrCode, size: 18),
                label: Text(_issuing ? '발급 중...' : '적립 QR 발급'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IssuedTokenSection extends StatelessWidget {
  const _IssuedTokenSection({required this.token, required this.onReset});

  final IssuedQrToken token;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '고객에게 아래 QR을 보여주세요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                ),
                child: QrImageView(
                  data: token.code,
                  version: QrVersions.auto,
                  size: 220.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${token.storeName}\n'
              '결제 ${_amountFormat.format(token.paymentAmount)}원 · '
              '적립 예정 ${_amountFormat.format((token.paymentAmount * 0.1).floor())}P',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '${_timeFormat.format(token.expiresAt)}까지 1회만 스캔할 수 있어요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(LucideIcons.rotateCcw, size: 18),
              label: const Text('새 QR 발급'),
            ),
          ],
        ),
      ),
    );
  }
}
