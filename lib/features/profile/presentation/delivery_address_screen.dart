import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../data/local_delivery_addresses_repository.dart';
import '../domain/delivery_address.dart';

final deliveryAddressesRepositoryProvider =
    Provider<DeliveryAddressesRepository>((ref) {
  return LocalDeliveryAddressesRepository();
});

final deliveryAddressesProvider = AsyncNotifierProvider<
    DeliveryAddressesController,
    List<DeliveryAddress>>(DeliveryAddressesController.new);

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
      appBar: AppBar(title: const Text('배송지 관리')),
      body: addressesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('배송지를 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(deliveryAddressesProvider),
                child: const Text('다시 시도'),
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
              ...addresses.map(
                (address) => _AddressCard(address: address),
              ),
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
            label: const Text('배송지 추가'),
          ),
        ),
      ),
    );
  }

  void _showAddAddressSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: foxtrotCard,
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
          const Icon(LucideIcons.mapPin, size: 48, color: foxtrotMuted),
          const SizedBox(height: 16),
          Text(
            '등록된 배송지가 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '배송지를 추가하면 원두 주문 시 바로 사용할 수 있어요.',
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
                color: foxtrotSurface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(
                  color: address.isDefault ? foxtrotGold : foxtrotBorder,
                ),
              ),
              child: Icon(
                address.label == '회사' ? LucideIcons.building2 : LucideIcons.house,
                color: address.isDefault ? foxtrotGold : foxtrotMuted,
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
                            color: foxtrotGold.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(foxtrotRadiusSmall),
                          ),
                          child: const Text(
                            '기본 배송지',
                            style: TextStyle(
                              fontSize: 11,
                              color: foxtrotGoldLight,
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
              icon: const Icon(
                LucideIcons.ellipsisVertical,
                size: 20,
                color: foxtrotMuted,
              ),
              color: foxtrotCard,
              onSelected: (value) {
                switch (value) {
                  case 'default':
                    controller.setDefaultAddress(address.id);
                  case 'delete':
                    controller.removeAddress(address.id);
                }
              },
              itemBuilder: (context) => [
                if (!address.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('기본 배송지로 설정'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('삭제'),
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
    await ref.read(deliveryAddressesProvider.notifier).addAddress(
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
                Text('배송지 추가', style: textTheme.titleLarge),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _labelController,
                  decoration: const InputDecoration(
                    labelText: '배송지 이름',
                    hintText: '예: 집, 회사',
                  ),
                  validator: (value) =>
                      _requiredValidator(value, '배송지 이름을 입력해주세요.'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(labelText: '받는 사람'),
                  validator: (value) =>
                      _requiredValidator(value, '받는 사람을 입력해주세요.'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '연락처',
                    hintText: '010-0000-0000',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      _requiredValidator(value, '연락처를 입력해주세요.'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address1Controller,
                  decoration: const InputDecoration(labelText: '주소'),
                  validator: (value) =>
                      _requiredValidator(value, '주소를 입력해주세요.'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _address2Controller,
                  decoration: const InputDecoration(
                    labelText: '상세 주소 (선택)',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('추가하기'),
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
