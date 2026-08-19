import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_providers.dart';
import '../domain/membership_qr_token.dart';
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
          padding: foxtrotListPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BalanceSection(data: data),
              const _StaffSection(),
              const SizedBox(height: 24),
              const _SectionHeader(title: '멤버십 바코드'),
              _MembershipQrSection(membershipId: data.membershipId),
              const SizedBox(height: 24),
              const _SectionHeader(title: '포인트 히스토리'),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나의 포인트',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${_pointFormat.format(data.balance)}P',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              '매장 결제 후 아래 멤버십 QR을 직원에게 보여주시면 결제 금액의 $pointsEarnRatePercent%가 자동 적립됩니다.\n앱에서 주문하면 별도 절차 없이 자동으로 적립돼요.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/points/charge'),
                    icon: const Icon(LucideIcons.batteryCharging, size: 20),
                    label: const Text('충전하기'),
                  ),
                ),
                const SizedBox(width: 10),
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

    try {
      await ref
          .read(pointsControllerProvider.notifier)
          .usePoints(amount: amount);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error is StateError ? error.message : '포인트 사용에 실패했어요. 다시 시도해주세요.',
            ),
          ),
        );
      return;
    }
    final after = ref.read(pointsControllerProvider).value;
    if (after == null || !context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '${_pointFormat.format(amount)}P를 사용했어요. '
            '남은 포인트 ${_pointFormat.format(after.balance)}P',
          ),
        ),
      );
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

class _StaffSection extends ConsumerWidget {
  const _StaffSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.watch(isAdminProvider).value ?? false;
    if (!isAdmin) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('직원 모드', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(
                '고객 멤버십 QR을 스캔해 결제 금액 포인트 적립을 진행해주세요.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/earn-scan'),
                icon: const Icon(LucideIcons.scanLine, size: 18),
                label: const Text('회원 QR 스캔 포인트 적립'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/orders'),
                icon: const Icon(LucideIcons.clipboardList, size: 18),
                label: const Text('주문 관리'),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/catalog'),
                icon: const Icon(LucideIcons.package, size: 18),
                label: const Text('카탈로그 관리'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}

class _MembershipQrSection extends StatefulWidget {
  const _MembershipQrSection({required this.membershipId});

  final String membershipId;

  @override
  State<_MembershipQrSection> createState() => _MembershipQrSectionState();
}

class _MembershipQrSectionState extends State<_MembershipQrSection> {
  late String _token;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _token = encodeMembershipQrToken(widget.membershipId);
    _timer =
        Timer.periodic(membershipQrRefreshInterval, (_) => _refreshToken());
  }

  @override
  void didUpdateWidget(covariant _MembershipQrSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.membershipId != widget.membershipId) {
      _refreshToken();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refreshToken() {
    setState(() {
      _token = encodeMembershipQrToken(widget.membershipId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
              ),
              child: QrImageView(
                data: _token,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.membershipId,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              '보안을 위해 QR 코드는 1분마다 자동으로 갱신됩니다.',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
    final bonusAmount = entry.bonusAmount;
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
                    bonusAmount != null
                        ? '결제 ${_pointFormat.format(paymentAmount)}원 · '
                            '보너스 +${_pointFormat.format(bonusAmount)}P'
                        : '결제 ${_pointFormat.format(paymentAmount)}원',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            entry.isIncrease
                ? '+${_pointFormat.format(entry.amount)}P'
                : '${_pointFormat.format(entry.amount)}P',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: entry.isIncrease
                  ? foxtrotGold
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
