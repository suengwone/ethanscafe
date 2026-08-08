// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
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
  return _exchangeCode(
    clientId: clientId,
    redirectUri: redirectUri,
    code: code,
  );
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

  final popup = html.window.open(
    authUrl.toString(),
    'kakao_login',
    'width=480,height=700',
  );

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
        const AuthException('카카오 로그인에 실패했습니다. 다시 시도해주세요.'),
      );
    }
  });

  closeWatcher = Timer.periodic(const Duration(milliseconds: 500), (_) {
    if (popup.closed == true) {
      cleanUp();
      if (!completer.isCompleted) {
        completer.completeError(const AuthException('로그인이 취소되었습니다.'));
      }
    }
  });

  return completer.future;
}

Future<KakaoWebAuthResult> _exchangeCode({
  required String clientId,
  required String redirectUri,
  required String code,
}) async {
  final body = Uri(
    queryParameters: {
      'grant_type': 'authorization_code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'code': code,
    },
  ).query;

  final html.HttpRequest response;
  try {
    response = await html.HttpRequest.request(
      'https://kauth.kakao.com/oauth/token',
      method: 'POST',
      requestHeaders: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
      sendData: body,
    );
  } catch (_) {
    throw const AuthException('카카오 로그인에 실패했습니다. 다시 시도해주세요.');
  }

  final text = response.responseText;
  if (text == null || text.isEmpty) {
    throw const AuthException('카카오 인증 정보를 가져오지 못했습니다.');
  }
  final data = jsonDecode(text);
  if (data is! Map) {
    throw const AuthException('카카오 인증 정보를 가져오지 못했습니다.');
  }
  final idToken = data['id_token'];
  if (idToken is! String || idToken.isEmpty) {
    throw const AuthException('카카오 OpenID 설정이 필요합니다. 관리자에게 문의해주세요.');
  }
  final accessToken = data['access_token'];
  return KakaoWebAuthResult(
    idToken: idToken,
    accessToken: accessToken is String ? accessToken : null,
  );
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
