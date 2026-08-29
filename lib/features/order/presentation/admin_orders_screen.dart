import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_theme.dart';
import '../../../features/order/presentation/order_labels.dart';
import '../../../features/pickup/presentation/pickup_labels.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/admin_order_models.dart';
import '../domain/order_models.dart';
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
          title: Text(AppLocalizations.of(context).adminOrdersTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context).orderTypePickup),
              Tab(text: AppLocalizations.of(context).orderTypeBean),
              Tab(
                text: AppLocalizations.of(context).adminOrdersTabRefundFailed,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.refreshCw),
              tooltip: AppLocalizations.of(context).adminOrdersRefresh,
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
      error: (error, _) =>
          _ErrorView(onRetry: () => ref.invalidate(activePickupOrdersProvider)),
      data: (orders) {
        if (orders.isEmpty) {
          return _EmptyView(
            message: AppLocalizations.of(context).adminOrdersNoPickup,
          );
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
              statusLabel: AppLocalizations.of(
                context,
              ).pickupStatusLabel(entry.status),
              createdAt: entry.createdAt,
              nextLabel: next == null
                  ? null
                  : AppLocalizations.of(context).pickupStatusLabel(next),
              onAdvance: next == null
                  ? null
                  : () => ref
                        .read(adminOrdersControllerProvider)
                        .advancePickup(entry),
              onCancel: isPickupStatusCancellable(entry.status)
                  ? () => ref
                        .read(adminOrdersControllerProvider)
                        .cancelPickup(entry)
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
      error: (error, _) =>
          _ErrorView(onRetry: () => ref.invalidate(activeBeanOrdersProvider)),
      data: (orders) {
        if (orders.isEmpty) {
          return _EmptyView(
            message: AppLocalizations.of(context).adminOrdersNoBean,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = orders[index];
            final next = nextBeanStatus(entry.status, entry.fulfillmentMethod);
            return _OrderCard(
              badge: AppLocalizations.of(
                context,
              ).fulfillmentLabel(entry.fulfillmentMethod),
              summary: entry.summary,
              subtitle:
                  entry.destination ??
                  (entry.fulfillmentMethod == BeanFulfillmentMethod.delivery
                      ? AppLocalizations.of(context).orderDestinationNoRecipient
                      : AppLocalizations.of(context).orderDestinationNoStore),
              statusLabel: AppLocalizations.of(
                context,
              ).beanOrderStatusLabel(entry.status),
              createdAt: entry.createdAt,
              nextLabel: next == null
                  ? null
                  : AppLocalizations.of(context).beanOrderStatusLabel(next),
              onAdvance: next == null
                  ? null
                  : () => ref
                        .read(adminOrdersControllerProvider)
                        .advanceBean(entry),
              onCancel: isBeanStatusCancellable(entry.status)
                  ? () => ref
                        .read(adminOrdersControllerProvider)
                        .cancelBean(entry)
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
      error: (error, _) =>
          _ErrorView(onRetry: () => ref.invalidate(refundFailuresProvider)),
      data: (failures) {
        if (failures.isEmpty) {
          return _EmptyView(
            message: AppLocalizations.of(context).adminOrdersNoRefundFailures,
          );
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
          SnackBar(
            content: Text(AppLocalizations.of(context).adminOrdersRefunded),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).adminOrdersRefundFailed('$e'),
            ),
          ),
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
              Icon(
                LucideIcons.triangleAlert,
                size: 16,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(context).adminOrdersRefundFailedLabel(
                  failure.orderType == 'pickup'
                      ? AppLocalizations.of(context).orderTypePickup
                      : AppLocalizations.of(context).orderTypeBean,
                ),
                style: textTheme.labelMedium?.copyWith(color: Colors.redAccent),
              ),
              const Spacer(),
              Text(
                _dateFormat.format(failure.failedAt),
                style: textTheme.bodySmall?.copyWith(
                  color: context.palette.muted,
                ),
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
            AppLocalizations.of(
              context,
            ).priceWon(_amountFormat.format(failure.amount)),
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
                    : Text(AppLocalizations.of(context).adminOrdersRetryRefund),
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

  Future<void> _advance() => _run(
    widget.onAdvance,
    AppLocalizations.of(context).adminOrdersAdvanceFailed,
  );

  /// 취소는 결제 환불까지 되돌리므로 한 번 더 확인받는다.
  Future<void> _cancel() async {
    if (widget.onCancel == null || _busy) {
      return;
    }
    // 다이얼로그를 기다린 뒤에는 이 위젯이 사라졌을 수 있어 context를 다시
    // 만지지 않는다. 실패 문구는 미리 꺼내 둔다.
    final failureMessage = AppLocalizations.of(context).adminOrdersCancelFailed;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).adminOrdersCancelTitle),
        content: Text(
          AppLocalizations.of(context).adminOrdersCancelBody(widget.summary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context).commonClose),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context).adminOrdersCancelAction),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await _run(widget.onCancel, failureMessage);
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$failure: $e')));
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
                style: textTheme.bodySmall?.copyWith(
                  color: context.palette.muted,
                ),
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
                style: textTheme.bodySmall?.copyWith(
                  color: context.palette.ink,
                ),
              ),
              const Spacer(),
              if (widget.onCancel != null)
                TextButton(
                  onPressed: _busy ? null : _cancel,
                  child: Text(AppLocalizations.of(context).commonCancel),
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
                      : Text(
                          AppLocalizations.of(
                            context,
                          ).adminOrdersAdvanceTo(widget.nextLabel!),
                        ),
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
          Icon(
            LucideIcons.clipboardCheck,
            size: 40,
            color: context.palette.muted,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.palette.muted),
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
          Text(AppLocalizations.of(context).adminOrdersLoadFailed),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}
