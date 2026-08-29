import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/account_models.dart';
import '../domain/account_repository.dart';
import 'account_providers.dart';

class BusinessRegisterScreen extends ConsumerStatefulWidget {
  const BusinessRegisterScreen({super.key});

  @override
  ConsumerState<BusinessRegisterScreen> createState() =>
      _BusinessRegisterScreenState();
}

class _BusinessRegisterScreenState
    extends ConsumerState<BusinessRegisterScreen> {
  final _companyNameController = TextEditingController();
  final _businessNumberController = TextEditingController();
  final _managerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  var _submitting = false;
  var _editing = false;
  String? _businessNumberError;

  @override
  void dispose() {
    _companyNameController.dispose();
    _businessNumberController.dispose();
    _managerNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_submitting) {
      return;
    }
    if (_companyNameController.text.trim().isEmpty ||
        _businessNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).businessMissingFields),
        ),
      );
      return;
    }
    if (!isValidBusinessNumber(_businessNumberController.text)) {
      setState(
        () => _businessNumberError = AppLocalizations.of(
          context,
        ).businessNumberInvalid,
      );
      return;
    }

    setState(() {
      _submitting = true;
      _businessNumberError = null;
    });
    try {
      await ref
          .read(accountProfileControllerProvider.notifier)
          .registerBusiness(
            BusinessProfile(
              companyName: _companyNameController.text,
              businessNumber: _businessNumberController.text,
              managerName: _managerNameController.text,
              phone: _phoneController.text,
            ),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).businessSwitched)),
      );
      context.go('/');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).businessSwitchFailed('$error'),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _switchToBusiness() async {
    if (_submitting) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(accountProfileControllerProvider.notifier)
          .switchToBusiness();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).businessSwitched)),
      );
      context.go('/');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).businessSwitchFailedRetry),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _startEditing(BusinessProfile business) {
    _companyNameController.text = business.companyName;
    _businessNumberController.text = business.businessNumber;
    _managerNameController.text = business.managerName;
    _phoneController.text = business.phone;
    setState(() => _editing = true);
  }

  Future<void> _switchToCustomer() async {
    if (_submitting) {
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(accountProfileControllerProvider.notifier)
          .switchToCustomer();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).businessSwitchedBack),
        ),
      );
      context.go('/');
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(accountProfileControllerProvider).value;

    final savedBusiness = profile?.business;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).businessAccountTitle),
      ),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : profile.isBusiness
          ? _RegisteredView(
              business: profile.business!,
              submitting: _submitting,
              onSwitchToCustomer: _switchToCustomer,
            )
          : savedBusiness != null && !_editing
          ? _SavedBusinessView(
              business: savedBusiness,
              submitting: _submitting,
              onSwitchToBusiness: _switchToBusiness,
              onEdit: () => _startEditing(savedBusiness),
            )
          : _RegisterForm(
              companyNameController: _companyNameController,
              businessNumberController: _businessNumberController,
              managerNameController: _managerNameController,
              phoneController: _phoneController,
              businessNumberError: _businessNumberError,
              submitting: _submitting,
              onSubmit: _register,
            ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    required this.companyNameController,
    required this.businessNumberController,
    required this.managerNameController,
    required this.phoneController,
    required this.businessNumberError,
    required this.submitting,
    required this.onSubmit,
  });

  final TextEditingController companyNameController;
  final TextEditingController businessNumberController;
  final TextEditingController managerNameController;
  final TextEditingController phoneController;
  final String? businessNumberError;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: foxtrotListPadding,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.building2,
                  color: context.palette.accent,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context).businessIntro.keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          AppLocalizations.of(context).businessSectionInfo,
          style: textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: companyNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).businessFieldCompany,
            hintText: AppLocalizations.of(context).businessFieldCompanyHint,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: businessNumberController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).businessFieldNumber,
            hintText: '000-00-00000',
            errorText: businessNumberError,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: managerNameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).businessFieldManager,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).businessFieldPhone,
            hintText: '010-0000-0000',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: submitting ? null : onSubmit,
          child: Text(AppLocalizations.of(context).businessSwitchAction),
        ),
      ],
    );
  }
}

class _SavedBusinessView extends StatelessWidget {
  const _SavedBusinessView({
    required this.business,
    required this.submitting,
    required this.onSwitchToBusiness,
    required this.onEdit,
  });

  final BusinessProfile business;
  final bool submitting;
  final VoidCallback onSwitchToBusiness;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: foxtrotListPadding,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.building2,
                      color: context.palette.accent,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context).businessSavedTitle,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context).businessSavedIntro.keepWord,
                  style: textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                _BusinessInfoRows(business: business),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: submitting ? null : onSwitchToBusiness,
          child: Text(AppLocalizations.of(context).businessSavedSwitch),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: submitting ? null : onEdit,
          child: Text(AppLocalizations.of(context).businessSavedEdit),
        ),
      ],
    );
  }
}

class _BusinessInfoRows extends StatelessWidget {
  const _BusinessInfoRows({required this.business});

  final BusinessProfile business;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final entries = [
      (l10n.businessLabelCompany, business.companyName),
      (l10n.businessLabelNumber, business.businessNumber),
      if (business.managerName.isNotEmpty)
        (l10n.businessLabelManager, business.managerName),
      if (business.phone.isNotEmpty) (l10n.businessLabelPhone, business.phone),
    ];

    return Column(
      children: [
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
    );
  }
}

class _RegisteredView extends StatelessWidget {
  const _RegisteredView({
    required this.business,
    required this.submitting,
    required this.onSwitchToCustomer,
  });

  final BusinessProfile business;
  final bool submitting;
  final VoidCallback onSwitchToCustomer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: foxtrotListPadding,
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.badgeCheck,
                      color: context.palette.accent,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context).businessActiveTitle,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _BusinessInfoRows(business: business),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context).businessActiveDescription,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: submitting ? null : onSwitchToCustomer,
          child: Text(AppLocalizations.of(context).businessSwitchBackAction),
        ),
      ],
    );
  }
}
