import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
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
        const SnackBar(content: Text('상호명과 사업자등록번호를 입력해주세요.')),
      );
      return;
    }
    if (!isValidBusinessNumber(_businessNumberController.text)) {
      setState(
        () => _businessNumberError = '사업자등록번호 10자리를 다시 확인해주세요.',
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
        const SnackBar(content: Text('사업자 계정으로 전환되었습니다. 도매 홈으로 이동합니다.')),
      );
      context.go('/');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사업자 전환에 실패했습니다: $error')),
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
        const SnackBar(content: Text('사업자 계정으로 전환되었습니다. 도매 홈으로 이동합니다.')),
      );
      context.go('/');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('사업자 전환에 실패했습니다. 다시 시도해주세요.')),
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
        const SnackBar(content: Text('일반 고객 계정으로 전환되었습니다.')),
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
      appBar: AppBar(title: const Text('사업자 계정')),
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
                Icon(LucideIcons.building2,
                    color: context.palette.accent, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '사업자 계정으로 전환하면 홈 화면이 원두 도매(B2B) 화면으로 바뀌고, kg 단위 도매가로 견적을 요청할 수 있어요.'
                        .keepWord,
                    style: textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('사업자 정보', style: textTheme.titleSmall),
        const SizedBox(height: 12),
        TextField(
          controller: companyNameController,
          decoration: const InputDecoration(
            labelText: '상호명 *',
            hintText: '예) 카페 어라운드',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: businessNumberController,
          decoration: InputDecoration(
            labelText: '사업자등록번호 *',
            hintText: '000-00-00000',
            errorText: businessNumberError,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: managerNameController,
          decoration: const InputDecoration(labelText: '담당자명'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: '연락처',
            hintText: '010-0000-0000',
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: submitting ? null : onSubmit,
          child: const Text('사업자 계정으로 전환하기'),
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
                    Icon(LucideIcons.building2,
                        color: context.palette.accent, size: 22),
                    const SizedBox(width: 10),
                    Text('등록된 사업자 정보', style: textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '이전에 등록한 사업자 정보가 있어요. 다시 입력하지 않고 바로 사업자 계정으로 전환할 수 있어요.'
                      .keepWord,
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
          child: const Text('사업자 계정으로 전환'),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: submitting ? null : onEdit,
          child: const Text('사업자 정보 수정'),
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
    final textTheme = Theme.of(context).textTheme;
    final entries = [
      ('상호명', business.companyName),
      ('사업자등록번호', business.businessNumber),
      if (business.managerName.isNotEmpty) ('담당자명', business.managerName),
      if (business.phone.isNotEmpty) ('연락처', business.phone),
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
                Expanded(
                  child: Text(value, style: textTheme.bodyMedium),
                ),
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
                    Icon(LucideIcons.badgeCheck,
                        color: context.palette.accent, size: 22),
                    const SizedBox(width: 10),
                    Text('사업자 계정 사용 중', style: textTheme.titleMedium),
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
          '홈 화면에서 도매 원두 시세를 확인하고 견적을 요청할 수 있어요.',
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: submitting ? null : onSwitchToCustomer,
          child: const Text('일반 고객 계정으로 전환'),
        ),
      ],
    );
  }
}
