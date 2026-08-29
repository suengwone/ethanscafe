import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// 현재 온라인 여부. 아직 판정 전이거나 조회에 실패하면 온라인으로 간주해
/// 배너가 잘못 뜨지 않게 한다.
final isOnlineProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).watchOnline().handleError((
    Object e,
  ) {
    debugPrint('Connectivity watch failed: $e');
  });
});
