import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/l10n/locale_providers.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_providers.dart';
import '../../auth/domain/auth_models.dart';
import '../../auth/presentation/account_providers.dart';
import '../../auth/presentation/auth_providers.dart';
import '../../coupon/presentation/coupons_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../subscription/presentation/subscription_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const _SignOutDialog(),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    await ref.read(authControllerProvider.notifier).signOut();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).profileSignedOut)),
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const _DeleteAccountDialog(),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    final success = await ref
        .read(authControllerProvider.notifier)
        .deleteAccount();
    if (!context.mounted) {
      return;
    }
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).profileAccountDeleted),
        ),
      );
    } else {
      final error = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _pickBirthDate(BuildContext context, WidgetRef ref) async {
    final birthDate = ref
        .read(accountProfileControllerProvider)
        .value
        ?.birthDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: AppLocalizations.of(context).profileBirthdayHelp,
    );
    if (picked == null || !context.mounted) {
      return;
    }
    await ref
        .read(accountProfileControllerProvider.notifier)
        .saveBirthDate(picked);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).profileBirthdaySaved),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final birthDate = ref
        .watch(accountProfileControllerProvider)
        .value
        ?.birthDate;
    final usableCouponCount = ref.watch(usableCouponCountProvider).value ?? 0;
    final subscriptionCount = ref.watch(activeSubscriptionCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).profileTitle)),
      body: ListView(
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 8),
          _buildSection(
            context,
            AppLocalizations.of(context).profileSectionActivity,
            [
              _buildListTile(
                icon: LucideIcons.receiptText,
                title: AppLocalizations.of(context).orderHistoryTitle,
                onTap: () => context.push('/profile/orders'),
              ),
              _buildListTile(
                icon: LucideIcons.ticket,
                title: AppLocalizations.of(context).couponListTitle,
                trailing: usableCouponCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.palette.accent,
                          borderRadius: BorderRadius.circular(
                            foxtrotRadiusMedium,
                          ),
                        ),
                        child: Text(
                          '$usableCouponCount',
                          style: TextStyle(
                            color: context.palette.onAccent,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
                onTap: () => context.push('/profile/coupons'),
              ),
              _buildListTile(
                icon: LucideIcons.repeat,
                title: AppLocalizations.of(context).subscriptionListTitle,
                trailing: subscriptionCount > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: context.palette.accent,
                          borderRadius: BorderRadius.circular(
                            foxtrotRadiusMedium,
                          ),
                        ),
                        child: Text(
                          '$subscriptionCount',
                          style: TextStyle(
                            color: context.palette.onAccent,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : null,
                onTap: () => context.push('/profile/subscriptions'),
              ),
              _buildListTile(
                icon: LucideIcons.gift,
                title: AppLocalizations.of(context).giftHistoryTitle,
                onTap: () => context.push('/profile/gifts'),
              ),
              _buildListTile(
                icon: LucideIcons.heart,
                title: AppLocalizations.of(context).favoriteMenuTitle,
                onTap: () => context.push('/profile/favorites'),
              ),
              _buildListTile(
                icon: LucideIcons.userPlus,
                title: AppLocalizations.of(context).referralTitle,
                onTap: () => context.push('/profile/referral'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            context,
            AppLocalizations.of(context).profileSectionSettings,
            [
              _buildListTile(
                icon: LucideIcons.bell,
                title: AppLocalizations.of(context).notificationSettingsTitle,
                onTap: () => context.push('/profile/notifications'),
              ),
              _buildListTile(
                icon: LucideIcons.sunMoon,
                title: AppLocalizations.of(context).settingsAppearanceTitle,
                trailing: Text(
                  AppLocalizations.of(
                    context,
                  ).themeModeLabel(ref.watch(themeModeProvider)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () => context.push('/profile/appearance'),
              ),
              _buildListTile(
                icon: LucideIcons.languages,
                title: AppLocalizations.of(context).settingsLanguageTitle,
                trailing: Text(switch (ref.watch(localeProvider)) {
                  final locale? => localeName(locale),
                  null => AppLocalizations.of(context).settingsLanguageSystem,
                }, style: Theme.of(context).textTheme.bodySmall),
                onTap: () => context.push('/profile/language'),
              ),
              _buildListTile(
                icon: LucideIcons.cake,
                title: AppLocalizations.of(context).profileBirthday,
                trailing: birthDate != null
                    ? Text(
                        AppLocalizations.of(context).profileBirthdayValue(
                          birthDate.year,
                          birthDate.month,
                          birthDate.day,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : null,
                onTap: () => _pickBirthDate(context, ref),
              ),
              _buildListTile(
                icon: LucideIcons.creditCard,
                title: AppLocalizations.of(context).paymentMethodsTitle,
                onTap: () => context.push('/profile/payment-methods'),
              ),
              _buildListTile(
                icon: LucideIcons.mapPin,
                title: AppLocalizations.of(context).addressListTitle,
                onTap: () => context.push('/profile/addresses'),
              ),
              _buildListTile(
                icon: LucideIcons.briefcaseBusiness,
                title: AppLocalizations.of(context).profileBusinessAccount,
                onTap: () => context.push('/profile/business'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSection(
            context,
            AppLocalizations.of(context).profileSectionOther,
            [
              _buildListTile(
                icon: LucideIcons.circleQuestionMark,
                title: AppLocalizations.of(context).supportTitle,
                onTap: () => context.push('/profile/support'),
              ),
              _buildListTile(
                icon: LucideIcons.info,
                title: AppLocalizations.of(context).policyTermsTitle,
                onTap: () => context.push('/profile/terms'),
              ),
              _buildListTile(
                icon: LucideIcons.shieldCheck,
                title: AppLocalizations.of(context).policyPrivacyTitle,
                onTap: () => context.push('/profile/privacy'),
              ),
              _buildListTile(
                icon: LucideIcons.building2,
                title: AppLocalizations.of(context).profileCompanyInfo,
                onTap: () => _showBusinessInfo(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (user != null)
            _buildSection(
              context,
              AppLocalizations.of(context).profileSectionAccount,
              [
                _buildListTile(
                  icon: LucideIcons.logOut,
                  title: AppLocalizations.of(context).profileSignOut,
                  textColor: Theme.of(context).colorScheme.error,
                  onTap: () => _signOut(context, ref),
                ),
                _buildListTile(
                  icon: LucideIcons.userX,
                  title: AppLocalizations.of(context).profileDeleteAccount,
                  textColor: Theme.of(context).colorScheme.error,
                  onTap: () => _deleteAccount(context, ref),
                ),
              ],
            ),
          const SizedBox(height: 24),
          const Center(child: _AppVersionLabel()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showBusinessInfo(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _BusinessInfoSheet(),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: foxtrotScreenHPadding,
            vertical: 8,
          ),
          child: Text(title, style: Theme.of(context).textTheme.titleSmall),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: foxtrotScreenHPadding),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: trailing ?? const Icon(LucideIcons.chevronRight, size: 18),
      onTap: onTap,
    );
  }
}

class _SignOutDialog extends StatelessWidget {
  const _SignOutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).profileSignOut),
      content: Text(AppLocalizations.of(context).profileSignOutConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context).profileSignOut),
        ),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatelessWidget {
  const _DeleteAccountDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).profileDeleteAccount),
      content: Text(AppLocalizations.of(context).profileDeleteAccountConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Text(AppLocalizations.of(context).profileDeleteAccountAction),
        ),
      ],
    );
  }
}

class _BusinessInfoSheet extends StatelessWidget {
  const _BusinessInfoSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // 값은 사업자 등록 원부 그대로다. 이름표만 언어를 탄다.
    final entries = [
      (l10n.companyFieldName, "Ethan's Cafe"),
      (l10n.companyFieldOwner, '이단'),
      (l10n.companyFieldNumber, '123-45-67890'),
      (l10n.companyFieldAddress, '서울 성동구 연무장길 47 1층'),
      (l10n.companyFieldPhone, '02-1234-5678'),
      (l10n.companyFieldEmail, 'hello@ethanscafe.com'),
    ];
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).profileCompanyInfo,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            for (final (label, value) in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: Text(label, style: textTheme.bodySmall),
                    ),
                    Expanded(child: Text(value, style: textTheme.bodyMedium)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AppVersionLabel extends StatelessWidget {
  const _AppVersionLabel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version;
        return Text(
          version == null
              ? AppLocalizations.of(context).appVersionLoading
              : AppLocalizations.of(context).appVersion(version),
          style: Theme.of(context).textTheme.bodySmall,
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final AppUser? user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoUrl;
    final email = user?.email;

    return Container(
      padding: const EdgeInsets.all(24),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: context.palette.card,
            // 100pt 아바타에 원본을 그대로 디코딩하지 않는다.
            backgroundImage: photoUrl != null
                ? ResizeImage(
                    NetworkImage(photoUrl),
                    width: (100 * MediaQuery.devicePixelRatioOf(context))
                        .round(),
                  )
                : null,
            child: photoUrl == null
                ? Icon(
                    LucideIcons.user300,
                    size: 50,
                    color: context.palette.muted,
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            user?.displayLabel ?? AppLocalizations.of(context).profileGuest,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          if (user == null)
            TextButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(LucideIcons.logIn, size: 20),
              label: Text(AppLocalizations.of(context).profileSignIn),
            )
          else if (email != null)
            Text(
              email,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 14),
            ),
        ],
      ),
    );
  }
}
