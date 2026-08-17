import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/admin_order_models.dart';
import '../domain/order_models.dart';
import 'admin_orders_providers.dart';

final _timeFormat = DateFormat('HH:mm');

/// 매장 관리자용 주문 처리 화면. 상태를 한 단계씩 진행시킨다.
class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('주문 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '픽업'),
              Tab(text: '원두'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.refreshCw),
              tooltip: '새로고침',
              onPressed: () {
                ref.invalidate(activePickupOrdersProvider);
                ref.invalidate(activeBeanOrdersProvider);
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [_PickupOrdersTab(), _BeanOrdersTab()],
        ),
      ),
    );
  }
}

class _PickupOrdersTab extends ConsumerWidget {
  const _PickupOrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activePickupOrdersProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        onRetry: () => ref.invalidate(activePickupOrdersProvider),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return const _EmptyView(message: '처리할 픽업 주문이 없습니다.');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = orders[index];
            final next = nextPickupStatus(entry.order.status);
            return _OrderCard(
              badge: '#${entry.order.pickupNumber}',
              summary: pickupOrderSummary(entry.order),
              subtitle: entry.order.storeName,
              statusLabel: entry.order.status.label,
              createdAt: entry.order.createdAt,
              nextLabel: next?.label,
              onAdvance: next == null
                  ? null
                  : () => ref
                      .read(adminOrdersControllerProvider)
                      .advancePickup(entry),
              onCancel: isPickupOrderCancellable(entry.order)
                  ? () =>
                      ref.read(adminOrdersControllerProvider).cancelPickup(entry)
                  : null,
            );
          },
        );
      },
    );
  }
}

class _BeanOrdersTab extends ConsumerWidget {
  const _BeanOrdersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(activeBeanOrdersProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        onRetry: () => ref.invalidate(activeBeanOrdersProvider),
      ),
      data: (orders) {
        if (orders.isEmpty) {
          return const _EmptyView(message: '처리할 원두 주문이 없습니다.');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = orders[index];
            final next = nextBeanStatus(
              entry.order.status,
              entry.order.fulfillmentMethod,
            );
            return _OrderCard(
              badge: entry.order.fulfillmentMethod.label,
              summary: beanOrderSummary(entry.order),
              subtitle: entry.order.fulfillmentMethod ==
                      BeanFulfillmentMethod.delivery
                  ? (entry.order.recipient ?? '수령인 미지정')
                  : (entry.order.storeName ?? '매장 미지정'),
              statusLabel: entry.order.status.label,
              createdAt: entry.order.createdAt,
              nextLabel: next?.label,
              onAdvance: next == null
                  ? null
                  : () =>
                      ref.read(adminOrdersControllerProvider).advanceBean(entry),
              onCancel: isBeanOrderCancellable(entry.order)
                  ? () =>
                      ref.read(adminOrdersControllerProvider).cancelBean(entry)
                  : null,
            );
          },
        );
      },
    );
  }
}

class _OrderCard extends StatefulWidget {
  const _OrderCard({
    required this.badge,
    required this.summary,
    required this.subtitle,
    required this.statusLabel,
    required this.createdAt,
    required this.nextLabel,
    required this.onAdvance,
    required this.onCancel,
  });

  final String badge;
  final String summary;
  final String subtitle;
  final String statusLabel;
  final DateTime createdAt;
  final String? nextLabel;
  final Future<void> Function()? onAdvance;
  final Future<void> Function()? onCancel;

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _busy = false;

  Future<void> _advance() => _run(widget.onAdvance, '상태를 바꾸지 못했습니다');

  /// 취소는 결제 환불까지 되돌리므로 한 번 더 확인받는다.
  Future<void> _cancel() async {
    if (widget.onCancel == null || _busy) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('주문을 취소할까요?'),
        content: Text(
          '${widget.summary} 주문을 취소합니다.\n'
          '사용한 포인트와 쿠폰을 돌려주고 결제한 금액을 환불합니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('닫기'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('주문 취소'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await _run(widget.onCancel, '주문을 취소하지 못했습니다');
  }

  Future<void> _run(Future<void> Function()? action, String failure) async {
    if (action == null || _busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$failure: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: foxtrotCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: foxtrotBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: foxtrotGold.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.badge,
                  style: textTheme.labelMedium?.copyWith(
                    color: foxtrotGoldLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeFormat.format(widget.createdAt),
                style: textTheme.bodySmall?.copyWith(color: foxtrotMuted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.summary,
            style: textTheme.titleMedium?.copyWith(
              color: foxtrotCream,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.subtitle,
            style: textTheme.bodySmall?.copyWith(color: foxtrotMuted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(LucideIcons.clock, size: 14, color: foxtrotMuted),
              const SizedBox(width: 6),
              Text(
                widget.statusLabel,
                style: textTheme.bodySmall?.copyWith(color: foxtrotCream),
              ),
              const Spacer(),
              if (widget.onCancel != null)
                TextButton(
                  onPressed: _busy ? null : _cancel,
                  child: const Text('취소'),
                ),
              if (widget.onCancel != null && widget.nextLabel != null)
                const SizedBox(width: 8),
              if (widget.nextLabel != null)
                FilledButton(
                  onPressed: _busy ? null : _advance,
                  child: _busy
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('${widget.nextLabel}로'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.clipboardCheck, size: 40, color: foxtrotMuted),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: foxtrotMuted),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('주문을 불러오지 못했습니다.'),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
