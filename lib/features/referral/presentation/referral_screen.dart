import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/referral_models.dart';
import 'referral_providers.dart';

final _amountFormat = NumberFormat('#,###');

String invitationMessage(AppLocalizations l10n, ReferralSummary summary) =>
    l10n.referralInvitation(summary.code, _amountFormat.format(summary.reward));

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
          SnackBar(
            content: Text(AppLocalizations.of(context).referralCodeInvalid),
          ),
        );
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await ref
          .read(referralControllerProvider.notifier)
          .redeem(code);
      if (!mounted) {
        return;
      }
      _codeController.clear();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).referralRedeemed(_amountFormat.format(result.reward)),
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
          SnackBar(
            content: Text(AppLocalizations.of(context).referralRedeemFailed),
          ),
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
      appBar: AppBar(title: Text(AppLocalizations.of(context).referralTitle)),
      body: referralState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).referralLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(referralControllerProvider),
                child: Text(AppLocalizations.of(context).retry),
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
              onCopyCode: () => _copy(
                summary.code,
                AppLocalizations.of(context).referralCodeCopied,
              ),
              onCopyMessage: () => _copy(
                invitationMessage(AppLocalizations.of(context), summary),
                AppLocalizations.of(context).referralMessageCopied,
              ),
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
              Icon(
                LucideIcons.userPlus,
                color: context.palette.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).referralRewardTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: context.palette.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(
              context,
            ).referralRewardBoth(_amountFormat.format(summary.reward)).keepWord,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).referralRewardHow.keepWord,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.palette.muted,
            ),
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
          Text(
            AppLocalizations.of(context).referralMyCode,
            style: theme.textTheme.titleSmall,
          ),
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
                tooltip: AppLocalizations.of(context).referralCopyCode,
                icon: const Icon(LucideIcons.copy, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onCopyMessage,
            icon: const Icon(LucideIcons.share2, size: 18),
            label: Text(AppLocalizations.of(context).referralCopyMessage),
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
            label: AppLocalizations.of(context).referralInvitedCount,
            value: AppLocalizations.of(
              context,
            ).referralPeopleCount(summary.invitedCount),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: AppLocalizations.of(context).referralRewardEarned,
            value: '${_amountFormat.format(summary.earnedPoints)}P',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatTile(
            label: AppLocalizations.of(context).referralRemaining,
            value: AppLocalizations.of(
              context,
            ).referralPeopleCount(summary.remainingInvites),
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
            style: theme.textTheme.titleMedium?.copyWith(
              color: context.palette.accent,
            ),
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
          Text(
            AppLocalizations.of(context).referralEnterCode,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            enabled: !submitting,
            textCapitalization: TextCapitalization.characters,
            maxLength: referralCodeLength,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).referralCodeHint,
              counterText: '',
            ),
            style: theme.textTheme.titleMedium?.copyWith(letterSpacing: 4),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: submitting ? null : onSubmit,
            child: Text(
              submitting
                  ? AppLocalizations.of(context).referralChecking
                  : AppLocalizations.of(context).referralClaim,
            ),
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
          Icon(
            LucideIcons.circleCheck,
            color: context.palette.accent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).referralAlreadyRedeemed,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).referralRedeemedDetail(
                    summary.redeemedCode ?? '',
                    _amountFormat.format(summary.reward),
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: context.palette.muted,
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

class _ReferralNotice extends StatelessWidget {
  const _ReferralNotice({required this.summary});

  final ReferralSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notices = [
      AppLocalizations.of(context).referralRuleOnce,
      AppLocalizations.of(context).referralRuleNotSelf,
      AppLocalizations.of(context).referralRuleLimit(summary.inviteLimit),
      AppLocalizations.of(context).referralRuleImmediate,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).referralNoticeTitle,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        for (final notice in notices)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('· ', style: theme.textTheme.bodySmall),
                Expanded(
                  child: Text(
                    notice.keepWord,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
