import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../domain/referral_models.dart';
import 'referral_providers.dart';

final _amountFormat = NumberFormat('#,###');

String invitationMessage(ReferralSummary summary) =>
    '폭스트롯에서 커피 한 잔 어때요? 가입하고 초대 코드 ${summary.code}를 입력하면 '
    '${_amountFormat.format(summary.reward)}P를 드려요.';

class ReferralScreen extends ConsumerStatefulWidget {
  const ReferralScreen({super.key});

  @override
  ConsumerState<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends ConsumerState<ReferralScreen> {
  final _codeController = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _copy(String value, String message) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _redeem() async {
    if (_submitting) {
      return;
    }
    final code = normalizeReferralCode(_codeController.text);
    if (!isValidReferralCode(code)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('초대 코드 6자리를 다시 확인해주세요.')),
        );
      return;
    }

    setState(() => _submitting = true);
    try {
      final result =
          await ref.read(referralControllerProvider.notifier).redeem(code);
      if (!mounted) {
        return;
      }
      _codeController.clear();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              '${_amountFormat.format(result.reward)}P가 적립됐어요. '
              '친구도 같은 포인트를 받았습니다.',
            ),
          ),
        );
    } on ReferralException catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('초대 코드를 확인하지 못했습니다. 잠시 후 다시 시도해주세요.')),
        );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final referralState = ref.watch(referralControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('친구 초대')),
      body: referralState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('초대 코드를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(referralControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (summary) => ListView(
          padding: foxtrotListPadding,
          children: [
            _RewardHeader(summary: summary),
            const SizedBox(height: 16),
            _MyCodeCard(
              summary: summary,
              onCopyCode: () => _copy(summary.code, '초대 코드를 복사했어요.'),
              onCopyMessage: () =>
                  _copy(invitationMessage(summary), '초대 문구를 복사했어요.'),
            ),
            const SizedBox(height: 16),
            _InviteStats(summary: summary),
            const SizedBox(height: 16),
            if (summary.hasRedeemed)
              _RedeemedCard(summary: summary)
            else
              _RedeemForm(
                controller: _codeController,
                submitting: _submitting,
                onSubmit: _redeem,
              ),
            const SizedBox(height: 20),
            _ReferralNotice(summary: summary),
          ],
        ),
      ),
    );
  }
}

class _RewardHeader extends StatelessWidget {
  const _RewardHeader({required this.summary});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [context.palette.card, context.palette.surface],
        ),
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.userPlus, color: context.palette.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                '초대 리워드',
                style: theme.textTheme.titleSmall?.copyWith(color: context.palette.accent),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '친구도 나도 ${_amountFormat.format(summary.reward)}P'.keepWord,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '친구가 가입 후 내 초대 코드를 입력하면 두 사람 모두 포인트를 받습니다.'.keepWord,
            style: theme.textTheme.bodyMedium?.copyWith(color: context.palette.muted),
          ),
        ],
      ),
    );
  }
}

class _MyCodeCard extends StatelessWidget {
  const _MyCodeCard({
    required this.summary,
    required this.onCopyCode,
    required this.onCopyMessage,
  });

  final ReferralSummary summary;
  final VoidCallback onCopyCode;
  final VoidCallback onCopyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('나의 초대 코드', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.code,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    letterSpacing: 6,
                    color: context.palette.accent,
                  ),
                ),
              ),
              IconButton(
                onPressed: onCopyCode,
                tooltip: '코드 복사',
                icon: const Icon(LucideIcons.copy, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onCopyMessage,
            icon: const Icon(LucideIcons.share2, size: 18),
            label: const Text('초대 문구 복사'),
          ),
        ],
      ),
    );
  }
}

class _InviteStats extends StatelessWidget {
  const _InviteStats({required this.summary});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            label: '초대한 친구',
            value: '${summary.invitedCount}명',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: '받은 보상',
            value: '${_amountFormat.format(summary.earnedPoints)}P',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: '남은 초대',
            value: '${summary.remainingInvites}명',
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: context.palette.surface,
        borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(color: context.palette.accent),
          ),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RedeemForm extends StatelessWidget {
  const _RedeemForm({
    required this.controller,
    required this.submitting,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final bool submitting;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('받은 초대 코드 입력', style: theme.textTheme.titleSmall),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            enabled: !submitting,
            textCapitalization: TextCapitalization.characters,
            maxLength: referralCodeLength,
            decoration: const InputDecoration(
              hintText: '예: A2K9PX',
              counterText: '',
            ),
            style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 4),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: submitting ? null : onSubmit,
            child: Text(submitting ? '확인 중...' : '포인트 받기'),
          ),
        ],
      ),
    );
  }
}

class _RedeemedCard extends StatelessWidget {
  const _RedeemedCard({required this.summary});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(foxtrotRadiusLarge),
        border: Border.all(color: context.palette.border),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleCheck, color: context.palette.accent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('초대 코드 입력 완료', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  '${summary.redeemedCode} 코드로 '
                  '${_amountFormat.format(summary.reward)}P를 받았습니다.',
                  style:
                      theme.textTheme.bodyMedium?.copyWith(color: context.palette.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferralNotice extends StatelessWidget {
  const _ReferralNotice({required this.summary});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notices = [
      '초대 코드는 계정당 한 번만 입력할 수 있습니다.',
      '본인의 초대 코드는 사용할 수 없습니다.',
      '초대 보상은 최대 ${summary.inviteLimit}명까지 받을 수 있습니다.',
      '보상 포인트는 입력 즉시 적립되며 포인트 화면에서 확인할 수 있습니다.',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('안내', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        for (final notice in notices)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('· ', style: theme.textTheme.bodySmall),
                Expanded(
                  child: Text(notice.keepWord,
                      style: theme.textTheme.bodySmall),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
