import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/confirm_delete_dialog.dart';
import '../../auth/presentation/auth_providers.dart';
import '../data/firestore_payment_methods_repository.dart';
import '../data/local_payment_methods_repository.dart';
import '../domain/payment_method.dart';

final paymentMethodsRepositoryProvider =
    Provider<PaymentMethodsRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      final user = ref.watch(authStateProvider).value;
      if (user != null) {
        return FirestorePaymentMethodsRepository(uid: user.uid);
      }
    }
  } catch (_) {}
  return LocalPaymentMethodsRepository();
});

final paymentMethodsProvider = AsyncNotifierProvider<PaymentMethodsController,
    List<PaymentMethod>>(PaymentMethodsController.new);

class PaymentMethodsController extends AsyncNotifier<List<PaymentMethod>> {
  @override
  Future<List<PaymentMethod>> build() {
    return ref.watch(paymentMethodsRepositoryProvider).load();
  }

  Future<void> addCard({required String brand, required String last4}) async {
    final repository = ref.read(paymentMethodsRepositoryProvider);
    state = await AsyncValue.guard(
      () => repository.addCard(brand: brand, last4: last4),
    );
  }

  Future<void> removeCard(String id) async {
    final repository = ref.read(paymentMethodsRepositoryProvider);
    state = await AsyncValue.guard(() => repository.removeCard(id));
  }

  Future<void> setDefaultCard(String id) async {
    final repository = ref.read(paymentMethodsRepositoryProvider);
    state = await AsyncValue.guard(() => repository.setDefaultCard(id));
  }
}

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(paymentMethodsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('결제 수단 관리')),
      body: cardsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('결제 수단을 불러오지 못했습니다.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(paymentMethodsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (cards) {
          if (cards.isEmpty) {
            return const _EmptyPaymentMethods();
          }
          return ListView(
            padding: foxtrotListPadding,
            children: [
              ...cards.map((card) => _PaymentMethodCard(card: card)),
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
            onPressed: () => _showAddCardSheet(context, ref),
            icon: const Icon(LucideIcons.plus, size: 20),
            label: const Text('카드 추가'),
          ),
        ),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.palette.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _AddCardSheet(),
    );
  }
}

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.creditCard, size: 48, color: context.palette.muted),
          const SizedBox(height: 16),
          Text(
            '등록된 결제 수단이 없어요',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '카드를 추가하면 매장에서 빠르게 결제할 수 있어요.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends ConsumerWidget {
  const _PaymentMethodCard({required this.card});

  final PaymentMethod card;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await confirmDelete(
      context,
      title: '결제 수단 삭제',
      message: '${card.brand}(**** ${card.last4}) 카드를 삭제할까요? 삭제하면 되돌릴 수 없어요.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    await ref.read(paymentMethodsProvider.notifier).removeCard(card.id);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('결제 수단을 삭제했어요.')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final controller = ref.read(paymentMethodsProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.palette.surface,
                borderRadius: BorderRadius.circular(foxtrotRadiusMedium),
                border: Border.all(
                  color: card.isDefault ? context.palette.accent : context.palette.border,
                ),
              ),
              child: Icon(
                LucideIcons.creditCard,
                color: card.isDefault ? context.palette.accent : context.palette.muted,
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
                      Text(card.brand, style: textTheme.labelLarge),
                      if (card.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: context.palette.accent.withValues(alpha: 0.15),
                            borderRadius:
                                BorderRadius.circular(foxtrotRadiusSmall),
                          ),
                          child: Text(
                            '기본',
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
                    '**** **** **** ${card.last4}',
                    style: textTheme.bodySmall,
                  ),
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
                    controller.setDefaultCard(card.id);
                  case 'delete':
                    _delete(context, ref);
                }
              },
              itemBuilder: (context) => [
                if (!card.isDefault)
                  const PopupMenuItem(
                    value: 'default',
                    child: Text('기본 결제 수단으로 설정'),
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

class _AddCardSheet extends ConsumerStatefulWidget {
  const _AddCardSheet();

  @override
  ConsumerState<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends ConsumerState<_AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _last4Controller = TextEditingController();

  @override
  void dispose() {
    _brandController.dispose();
    _last4Controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref.read(paymentMethodsProvider.notifier).addCard(
          brand: _brandController.text.trim(),
          last4: _last4Controller.text.trim(),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('카드 추가', style: textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: '카드사',
                  hintText: '예: 신한카드',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '카드사를 입력해주세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _last4Controller,
                decoration: const InputDecoration(
                  labelText: '카드 번호 끝 4자리',
                  hintText: '1234',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().length != 4) {
                    return '카드 번호 끝 4자리를 입력해주세요.';
                  }
                  return null;
                },
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
    );
  }
}
