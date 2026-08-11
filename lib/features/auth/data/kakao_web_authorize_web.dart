// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:math';

import '../domain/auth_repository.dart';
import 'kakao_web_login.dart';

Future<KakaoWebAuthResult> authorizeWithKakaoWeb({
  required String clientId,
}) async {
  final origin = html.window.location.origin;
  final redirectUri = '$origin/auth/kakao/callback';
  final code = await _authorizeCode(
    clientId: clientId,
    origin: origin,
    redirectUri: redirectUri,
  );
  return KakaoWebAuthResult(code: code, redirectUri: redirectUri);
}

Future<String> _authorizeCode({
  required String clientId,
  required String origin,
  required String redirectUri,
}) {
  final state = _generateState();
  final authUrl = Uri.https('kauth.kakao.com', '/oauth/authorize', {
    'response_type': 'code',
    'client_id': clientId,
    'redirect_uri': redirectUri,
    'state': state,
    'scope': 'openid',
  });

  final html.WindowBase? popup;
  try {
    popup = html.window.open(
      authUrl.toString(),
      'kakao_login',
      'width=480,height=700',
    );
  } catch (_) {
    throw const AuthException('팝업이 차단되어 있습니다. 브라우저의 팝업 차단을 해제한 뒤 다시 시도해주세요.');
  }
  if (_isPopupClosed(popup)) {
    throw const AuthException('팝업이 차단되어 있습니다. 브라우저의 팝업 차단을 해제한 뒤 다시 시도해주세요.');
  }

  final completer = Completer<String>();
  StreamSubscription<html.MessageEvent>? subscription;
  Timer? closeWatcher;

  void cleanUp() {
    closeWatcher?.cancel();
    subscription?.cancel();
  }

  subscription = html.window.onMessage.listen((event) {
    if (event.origin != origin) {
      return;
    }
    final data = event.data;
    if (data is! Map || data['source'] != 'cafe-kakao-login') {
      return;
    }
    cleanUp();
    if (completer.isCompleted) {
      return;
    }
    final code = data['code'];
    final returnedState = data['state'];
    if (code is String && code.isNotEmpty && returnedState == state) {
      completer.complete(code);
    } else {
      completer.completeError(
        AuthException(_errorMessage(data['error'], data['errorDescription'])),
      );
    }
  });

  closeWatcher = Timer.periodic(const Duration(milliseconds: 500), (_) {
    if (_isPopupClosed(popup)) {
      cleanUp();
      if (!completer.isCompleted) {
        completer.completeError(const AuthException('로그인이 취소되었습니다.'));
      }
    }
  });

  return completer.future;
}

bool _isPopupClosed(html.WindowBase? popup) {
  if (popup == null) {
    return true;
  }
  try {
    return popup.closed ?? true;
  } catch (_) {
    return true;
  }
}

String _errorMessage(Object? error, Object? description) {
  if (error is! String || error.isEmpty) {
    return '카카오 로그인에 실패했습니다. 다시 시도해주세요.';
  }
  if (error == 'access_denied') {
    return '로그인이 취소되었습니다.';
  }
  final detail = description is String && description.isNotEmpty
      ? '$error: $description'
      : error;
  return '카카오 로그인에 실패했습니다. ($detail)';
}

String _generateState([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}
