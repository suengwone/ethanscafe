import 'package:connectivity_plus/connectivity_plus.dart';

/// 연결 결과 목록에 실제 연결 수단이 하나라도 있으면 온라인으로 본다.
/// 목록이 비어 있거나 [ConnectivityResult.none]만 있으면 오프라인이다.
bool isOnlineFromResults(List<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Future<bool> isOnline() async {
    return isOnlineFromResults(await _connectivity.checkConnectivity());
  }

  Stream<bool> watchOnline() {
    return _connectivity.onConnectivityChanged
        .map(isOnlineFromResults)
        .distinct();
  }
}
