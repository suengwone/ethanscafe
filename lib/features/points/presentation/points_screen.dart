import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/points_models.dart';
import 'points_providers.dart';

final _pointFormat = NumberFormat('#,###');

class PointsScreen extends ConsumerWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pointsState = ref.watch(pointsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('포인트'),
      ),
      body: pointsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('포인트 정보를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(pointsControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (data) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _BalanceSection(data: data),
              const SizedBox(height: 24),
              _MembershipQrSection(membershipId: data.membershipId),
              const SizedBox(height: 24),
              _HistorySection(history: data.history),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceSection extends ConsumerWidget {
  const _BalanceSection({required this.data});

  final PointsData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '나의 포인트',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Text(
              '${_pointFormat.format(data.balance)}P',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              '결제 금액의 10%가 포인트로 적립됩니다.\n적립된 포인트는 현금처럼 사용할 수 있어요.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showRecordPaymentDialog(context, ref),
                    icon: const Icon(LucideIcons.plus600, size: 18),
                    label: const Text('결제 적립'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: data.balance > 0
                        ? () => _showUsePointsDialog(context, ref, data.balance)
                        : null,
                    icon: const Icon(LucideIcons.handCoins, size: 20),
                    label: const Text('포인트 사용'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRecordPaymentDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final amount = await showDialog<int>(
      context: context,
      builder: (context) => const _AmountInputDialog(
        title: '결제 적립',
        helperText: '결제 금액의 10%가 적립됩니다.',
        labelText: '결제 금액 (원)',
        confirmText: '적립',
      ),
    );
    if (amount == null) return;

    await ref
        .read(pointsControllerProvider.notifier)
        .recordPayment(paymentAmount: amount);
  }

  Future<void> _showUsePointsDialog(
    BuildContext context,
    WidgetRef ref,
    int balance,
  ) async {
    final amount = await showDialog<int>(
      context: context,
      builder: (context) => _AmountInputDialog(
        title: '포인트 사용',
        helperText: '사용 가능 포인트: ${_pointFormat.format(balance)}P',
        labelText: '사용할 포인트 (P)',
        confirmText: '사용',
        maxAmount: balance,
      ),
    );
    if (amount == null) return;

    await ref.read(pointsControllerProvider.notifier).usePoints(amount: amount);
  }
}

class _AmountInputDialog extends StatefulWidget {
  const _AmountInputDialog({
    required this.title,
    required this.helperText,
    required this.labelText,
    required this.confirmText,
    this.maxAmount,
  });

  final String title;
  final String helperText;
  final String labelText;
  final String confirmText;
  final int? maxAmount;

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
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: widget.labelText,
            helperText: widget.helperText,
          ),
          validator: (value) {
            final amount = int.tryParse(value ?? '');
            if (amount == null || amount <= 0) {
              return '1 이상의 숫자를 입력해주세요.';
            }
            final maxAmount = widget.maxAmount;
            if (maxAmount != null && amount > maxAmount) {
              return '포인트 잔액이 부족합니다.';
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
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}

class _MembershipQrSection extends StatelessWidget {
  const _MembershipQrSection({required this.membershipId});

  final String membershipId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '멤버십 바코드',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
              ),
              child: QrImageView(
                data: membershipId,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              membershipId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});

  final List<PointHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '포인트 히스토리',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              Text(
                '적립/사용 내역이 없습니다.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontSize: 14),
              )
            else
              ...history.map((entry) => _HistoryItem(entry: entry)),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.entry});

  final PointHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    final paymentAmount = entry.paymentAmount;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            DateFormat('yyyy.MM.dd').format(entry.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description),
                if (paymentAmount != null)
                  Text(
                    '결제 ${_pointFormat.format(paymentAmount)}원',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            entry.isEarn
                ? '+${_pointFormat.format(entry.amount)}P'
                : '${_pointFormat.format(entry.amount)}P',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: entry.isEarn
                  ? foxtrotGold
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
