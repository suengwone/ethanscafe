import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_delivery_addresses_repository.dart';
import '../data/local_delivery_addresses_repository.dart';
import '../domain/delivery_address.dart';

final deliveryAddressesRepositoryProvider =
    Provider<DeliveryAddressesRepository>((ref) {
      try {
        if (Firebase.apps.isNotEmpty) {
          final user = ref.watch(authStateProvider).value;
          if (user != null) {
            return FirestoreDeliveryAddressesRepository(uid: user.uid);
          }
        }
      } catch (_) {}
      return LocalDeliveryAddressesRepository();
    });

final deliveryAddressesProvider =
    AsyncNotifierProvider<DeliveryAddressesController, List<DeliveryAddress>>(
      DeliveryAddressesController.new,
    );

class DeliveryAddressesController extends AsyncNotifier<List<DeliveryAddress>> {
  @override
  Future<List<DeliveryAddress>> build() {
    return ref.watch(deliveryAddressesRepositoryProvider).load();
  }

  Future<void> addAddress({
    required String label,
    required String recipient,
    required String phone,
    required String address1,
    String address2 = '',
  }) async {
    final repository = ref.read(deliveryAddressesRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.addAddress(
        label: label,
        recipient: recipient,
        phone: phone,
        address1: address1,
        address2: address2,
      ),
    );
  }

  Future<void> removeAddress(String id) async {
    final repository = ref.read(deliveryAddressesRepositoryProvider);
    state = await AsyncValue.guard(() => repository.removeAddress(id));
  }

  Future<void> setDefaultAddress(String id) async {
    final repository = ref.read(deliveryAddressesRepositoryProvider);
    state = await AsyncValue.guard(() => repository.setDefaultAddress(id));
  }
}

class DeliveryAddressScreen extends ConsumerWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressesState = ref.watch(deliveryAddressesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addressListTitle),
      ),
      body: addressesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).addressLoadFailed),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(deliveryAddressesProvider),
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        ),
        data: (addresses) {
          if (addresses.isEmpty) {
            return const _EmptyAddresses();
          }
          return ListView(
            padding: foxtrotListPadding,
            children: [
              ...addresses.map((address) => _AddressCard(address: address)),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            foxtrotScreenHPadding,
            12,
            foxtrotScreenHPadding,
            16,
          ),
          child: FilledButton.icon(
            onPressed: () => _showAddAddressSheet(context),
            icon: const Icon(LucideIcons.plus, size: 20),
            label: Text(AppLocalizations.of(context).addressAdd),
          ),
        ),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddAddressSheet(),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  const _EmptyAddresses();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.mapPin, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).addressEmptyTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).addressEmptyDetail,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final DeliveryAddress address;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDelete(
      context,
      title: AppLocalizations.of(context).addressDeleteTitle,
      message: AppLocalizations.of(context).addressDeleteBody(address.label),
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await ref
        .read(deliveryAddressesProvider.notifier)
        .removeAddress(address.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).addressDeleted)),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final controller = ref.read(deliveryAddressesProvider.notifier);
    final fullAddress = address.address2.isEmpty
        ? address.address1
        : '${address.address1} ${address.address2}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(
                  color: address.isDefault
                      ? context.palette.accent
                      : context.palette.border,
                ),
              ),
              child: Icon(
                address.label == '회사'
                    ? LucideIcons.building2
                    : LucideIcons.house,
                color: address.isDefault
                    ? context.palette.accent
                    : context.palette.muted,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(address.label, style: textTheme.labelLarge),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.palette.accent.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(
                              foxtrotRadiusSmall,
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context).beanCartDefaultAddress,
                            style: TextStyle(
                              fontSize: 11,
                              color: context.palette.accentSoft,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${address.recipient} · ${address.phone}',
                    style: textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(fullAddress, style: textTheme.bodySmall),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                LucideIcons.ellipsisVertical,
                size: 20,
                color: context.palette.muted,
              ),
              color: context.palette.card,
              onSelected: (value) {
                switch (value) {
                  case 'default':
                    controller.setDefaultAddress(address.id);
                  case 'delete':
                    _delete(context, ref);
                }
              },
              itemBuilder: (context) => [
                if (!address.isDefault)
                  PopupMenuItem(
                    value: 'default',
                    child: Text(AppLocalizations.of(context).addressSetDefault),
                  ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(AppLocalizations.of(context).commonDelete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddAddressSheet extends ConsumerStatefulWidget {
  const _AddAddressSheet();

  @override
  ConsumerState<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends ConsumerState<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _recipientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _recipientController.dispose();
    _phoneController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(deliveryAddressesProvider.notifier)
        .addAddress(
          label: _labelController.text.trim(),
          recipient: _recipientController.text.trim(),
          phone: _phoneController.text.trim(),
          address1: _address1Controller.text.trim(),
          address2: _address2Controller.text.trim(),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).addressAdd,
                  style: textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).addressFieldLabel,
                    hintText: AppLocalizations.of(
                      context,
                    ).addressFieldLabelHint,
                  ),
                  validator: (value) => _requiredValidator(
                    value,
                    AppLocalizations.of(context).addressFieldLabelRequired,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _recipientController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(
                      context,
                    ).addressFieldRecipient,
                  ),
                  validator: (value) => _requiredValidator(
                    value,
                    AppLocalizations.of(context).addressFieldRecipientRequired,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).businessFieldPhone,
                    hintText: '010-0000-0000',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) => _requiredValidator(
                    value,
                    AppLocalizations.of(context).addressFieldPhoneRequired,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address1Controller,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).storeFieldAddress,
                  ),
                  validator: (value) => _requiredValidator(
                    value,
                    AppLocalizations.of(context).addressFieldAddressRequired,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address2Controller,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).addressFieldDetail,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: Text(AppLocalizations.of(context).addressSubmit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
