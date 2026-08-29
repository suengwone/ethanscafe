import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/points_lock_prompt.dart';
import '../../../l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context).pointsTitle)),
      body: pointsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).pointsLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(pointsControllerProvider),
                child: Text(AppLocalizations.of(context).retry),
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
              _SectionHeader(
                title: AppLocalizations.of(context).pointsSectionBarcode,
              ),
              _MembershipQrSection(membershipId: data.membershipId),
              const SizedBox(height: 24),
              _SectionHeader(
                title: AppLocalizations.of(context).pointsSectionHistory,
              ),
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
              AppLocalizations.of(context).pointsMine,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '${_pointFormat.format(data.balance)}P',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontSize: 36),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(
                context,
              ).pointsEarnNotice(pointsEarnRatePercent),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/points/charge'),
                    icon: const Icon(LucideIcons.batteryCharging, size: 20),
                    label: Text(
                      AppLocalizations.of(context).pointsChargeAction,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: data.balance > 0
                        ? () => _showUsePointsDialog(context, ref, data.balance)
                        : null,
                    icon: const Icon(LucideIcons.handCoins, size: 20),
                    label: Text(AppLocalizations.of(context).pointsUseAction),
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
        title: AppLocalizations.of(context).pointsUseAction,
        helperText: AppLocalizations.of(
          context,
        ).pointsUseHelper(_pointFormat.format(balance)),
        labelText: AppLocalizations.of(context).pointsUseField,
        confirmText: AppLocalizations.of(context).pointsUseConfirm,
        maxAmount: balance,
      ),
    );
    if (amount == null) return;
    if (!context.mounted) return;
    // 장바구니와 같은 잠금을 지난다. 여기만 열려 있으면 잠금을 켜 둬도
    // 폰을 주운 사람이 이 화면에서 잔액을 그대로 쓴다.
    if (!await confirmPointsLock(context, ref, amount)) return;
    if (!context.mounted) return;

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
              error is StateError
                  ? error.message
                  : AppLocalizations.of(context).pointsUseFailed,
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
            AppLocalizations.of(context).pointsUsed(
              _pointFormat.format(amount),
              _pointFormat.format(after.balance),
            ),
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
              return AppLocalizations.of(context).pointsAmountInvalid;
            }
            final maxAmount = widget.maxAmount;
            if (maxAmount != null && amount > maxAmount) {
              return AppLocalizations.of(context).pointsInsufficient;
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
              Text(
                AppLocalizations.of(context).pointsStaffMode,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).pointsStaffIntro,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/earn-scan'),
                icon: const Icon(LucideIcons.scanLine, size: 18),
                label: Text(AppLocalizations.of(context).pointsStaffScan),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/orders'),
                icon: const Icon(LucideIcons.clipboardList, size: 18),
                label: Text(AppLocalizations.of(context).pointsStaffOrders),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => context.push('/points/catalog'),
                icon: const Icon(LucideIcons.package, size: 18),
                label: Text(AppLocalizations.of(context).pointsStaffCatalog),
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
    _timer = Timer.periodic(
      membershipQrRefreshInterval,
      (_) => _refreshToken(),
    );
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
              AppLocalizations.of(context).pointsQrRefreshNotice,
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
                AppLocalizations.of(context).pointsHistoryEmpty,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 14),
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
                        ? AppLocalizations.of(context).pointsPaidWithBonus(
                            _pointFormat.format(paymentAmount),
                            _pointFormat.format(bonusAmount),
                          )
                        : AppLocalizations.of(context).pointsPaidAmount(
                            _pointFormat.format(paymentAmount),
                          ),
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
                  ? context.palette.accent
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
