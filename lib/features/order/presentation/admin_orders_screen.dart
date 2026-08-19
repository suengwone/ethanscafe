import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/admin_order_models.dart';
import '../domain/refund_failure_models.dart';
import 'admin_orders_providers.dart';

final _dateFormat = DateFormat('M/d HH:mm');
final _amountFormat = NumberFormat('#,###');

final _timeFormat = DateFormat('HH:mm');

/// 매장 관리자용 주문 처리 화면. 상태를 한 단계씩 진행시킨다.
class AdminOrdersScreen extends ConsumerWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('주문 관리'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '픽업'),
              Tab(text: '원두'),
              Tab(text: '환불 실패'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.refreshCw),
              tooltip: '새로고침',
              onPressed: () {
                ref.invalidate(activePickupOrdersProvider);
                ref.invalidate(activeBeanOrdersProvider);
                ref.invalidate(refundFailuresProvider);
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            _PickupOrdersTab(),
            _BeanOrdersTab(),
            _RefundFailuresTab(),
          ],
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
            final next = nextPickupStatus(entry.status);
            return _OrderCard(
              badge: '#${entry.pickupNumber}',
              summary: entry.summary,
              subtitle: entry.storeName,
              statusLabel: entry.status.label,
              createdAt: entry.createdAt,
              nextLabel: next?.label,
              onAdvance: next == null
                  ? null
                  : () => ref
                      .read(adminOrdersControllerProvider)
                      .advancePickup(entry),
              onCancel: isPickupStatusCancellable(entry.status)
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
              entry.status,
              entry.fulfillmentMethod,
            );
            return _OrderCard(
              badge: entry.fulfillmentMethod.label,
              summary: entry.summary,
              subtitle: entry.destinationLabel,
              statusLabel: entry.status.label,
              createdAt: entry.createdAt,
              nextLabel: next?.label,
              onAdvance: next == null
                  ? null
                  : () =>
                      ref.read(adminOrdersControllerProvider).advanceBean(entry),
              onCancel: isBeanStatusCancellable(entry.status)
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

/// 취소는 됐는데 환불만 실패한 주문. 고객 돈이 묶여 있어 눈에 띄게 두고 재시도를 건다.
class _RefundFailuresTab extends ConsumerWidget {
  const _RefundFailuresTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(refundFailuresProvider);
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        onRetry: () => ref.invalidate(refundFailuresProvider),
      ),
      data: (failures) {
        if (failures.isEmpty) {
          return const _EmptyView(message: '환불이 밀린 주문이 없습니다.');
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: failures.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final failure = failures[index];
            return _RefundFailureCard(
              failure: failure,
              onRetry: () =>
                  ref.read(adminOrdersControllerProvider).retryRefund(failure),
            );
          },
        );
      },
    );
  }
}

class _RefundFailureCard extends StatefulWidget {
  const _RefundFailureCard({required this.failure, required this.onRetry});

  final RefundFailure failure;
  final Future<void> Function() onRetry;

  @override
  State<_RefundFailureCard> createState() => _RefundFailureCardState();
}

class _RefundFailureCardState extends State<_RefundFailureCard> {
  bool _busy = false;

  Future<void> _retry() async {
    if (_busy) {
      return;
    }
    setState(() => _busy = true);
    try {
      await widget.onRetry();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('환불했습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('환불에 실패했습니다: $e')),
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
    final failure = widget.failure;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.triangleAlert, size: 16, color: Colors.redAccent),
              const SizedBox(width: 6),
              Text(
                '${failure.orderTypeLabel} · 환불 실패',
                style: textTheme.labelMedium
                    ?.copyWith(color: Colors.redAccent),
              ),
              const Spacer(),
              Text(
                _dateFormat.format(failure.failedAt),
                style: textTheme.bodySmall?.copyWith(color: context.palette.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            failure.summary,
            style: textTheme.titleMedium?.copyWith(
              color: context.palette.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${_amountFormat.format(failure.amount)}원',
            style: textTheme.bodySmall?.copyWith(color: context.palette.muted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Spacer(),
              FilledButton(
                onPressed: _busy ? null : _retry,
                child: _busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('환불 재시도'),
              ),
            ],
          ),
        ],
      ),
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
        color: context.palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.palette.border),
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
                  color: context.palette.accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.badge,
                  style: textTheme.labelMedium?.copyWith(
                    color: context.palette.accentSoft,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _timeFormat.format(widget.createdAt),
                style: textTheme.bodySmall?.copyWith(color: context.palette.muted),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.summary,
            style: textTheme.titleMedium?.copyWith(
              color: context.palette.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.subtitle,
            style: textTheme.bodySmall?.copyWith(color: context.palette.muted),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(LucideIcons.clock, size: 14, color: context.palette.muted),
              const SizedBox(width: 6),
              Text(
                widget.statusLabel,
                style: textTheme.bodySmall?.copyWith(color: context.palette.ink),
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
          Icon(LucideIcons.clipboardCheck, size: 40, color: context.palette.muted),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: context.palette.muted),
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
