import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:naver_login_sdk/naver_login_sdk.dart';

import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';
import 'kakao_web_authorize_stub.dart'
    if (dart.library.html) 'kakao_web_authorize_web.dart'
    as kakao_web;
import 'naver_web_authorize_stub.dart'
    if (dart.library.html) 'naver_web_authorize_web.dart'
    as naver_web;

const _kakaoJsAppKey = String.fromEnvironment('KAKAO_JS_APP_KEY');
const _naverClientId = String.fromEnvironment('NAVER_CLIENT_ID');

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  static const _functionsRegion = 'asia-northeast3';
  static const naverSignInCallableName = 'signInWithNaver';
  static const kakaoSignInCallableName = 'signInWithKakao';

  FirebaseAuthRepository({fb.FirebaseAuth? auth, FirebaseFunctions? functions})
    : _auth = auth ?? fb.FirebaseAuth.instance,
      _functions =
          functions ?? FirebaseFunctions.instanceFor(region: _functionsRegion);

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_toAppUser);
  }

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Future<bool> isAdmin() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      final token = await user.getIdTokenResult();
      return token.claims?['admin'] == true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AppUser> signInWith(AuthProviderType provider) {
    switch (provider) {
      case AuthProviderType.kakao:
        return _signInWithKakao();
      case AuthProviderType.naver:
        return _signInWithNaver();
      case AuthProviderType.google:
        return _signInWithGoogle();
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException('로그인이 필요합니다.');
    }
    try {
      await user.delete();
    } on fb.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          throw const AuthException('보안을 위해 다시 로그인한 뒤 탈퇴를 진행해주세요.');
        case 'network-request-failed':
          throw const AuthException('네트워크 연결을 확인해주세요.');
        default:
          throw const AuthException('계정 삭제에 실패했습니다. 다시 시도해주세요.');
      }
    }
  }

  Future<AppUser> _signInWithKakao() async {
    try {
      if (kIsWeb) {
        if (_kakaoJsAppKey.isEmpty) {
          throw const AuthException('카카오 로그인 설정이 필요합니다. 관리자에게 문의해주세요.');
        }
        final webAuth = await kakao_web.authorizeWithKakaoWeb(
          clientId: _kakaoJsAppKey,
        );
        final callableResult = await _functions
            .httpsCallable(kakaoSignInCallableName)
            .call({'code': webAuth.code, 'redirectUri': webAuth.redirectUri});
        final data = Map<String, dynamic>.from(callableResult.data as Map);
        final idToken = data['idToken'] as String?;
        if (idToken == null || idToken.isEmpty) {
          throw const AuthException('카카오 인증 정보를 가져오지 못했습니다.');
        }
        final credential = fb.OAuthProvider('oidc.kakao-web').credential(
          idToken: idToken,
          accessToken: data['accessToken'] as String?,
        );
        final result = await _auth.signInWithCredential(credential);
        return _requireUser(result.user);
      }
      final token = await _loginWithKakaoSdk();
      final idToken = token.idToken;
      if (idToken == null) {
        throw const AuthException('카카오 OpenID 설정이 필요합니다. 관리자에게 문의해주세요.');
      }
      final credential = fb.OAuthProvider(
        'oidc.kakao',
      ).credential(idToken: idToken, accessToken: token.accessToken);
      final result = await _auth.signInWithCredential(credential);
      return _requireUser(result.user);
    } on AuthException {
      rethrow;
    } on FirebaseFunctionsException catch (e) {
      throw AuthException(e.message ?? '카카오 로그인에 실패했습니다. 다시 시도해주세요.');
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_firebaseMessage(e));
    } catch (_) {
      throw const AuthException('카카오 로그인에 실패했습니다. 다시 시도해주세요.');
    }
  }

  Future<kakao.OAuthToken> _loginWithKakaoSdk() async {
    if (await kakao.isKakaoTalkInstalled()) {
      try {
        return await kakao.UserApi.instance.loginWithKakaoTalk();
      } catch (_) {
        return kakao.UserApi.instance.loginWithKakaoAccount();
      }
    }
    return kakao.UserApi.instance.loginWithKakaoAccount();
  }

  Future<AppUser> _signInWithNaver() async {
    if (_naverClientId.isEmpty) {
      throw const AuthException('네이버 로그인 설정이 필요합니다. 관리자에게 문의해주세요.');
    }
    try {
      final Map<String, dynamic> payload;
      if (kIsWeb) {
        final authResult = await naver_web.authorizeWithNaverWeb(
          clientId: _naverClientId,
        );
        payload = {'code': authResult.code, 'state': authResult.state};
      } else {
        await _loginWithNaverSdk();
        final accessToken = await NaverLoginSDK.getAccessToken();
        if (accessToken.isEmpty) {
          throw const AuthException('네이버 인증 정보를 가져오지 못했습니다.');
        }
        payload = {'accessToken': accessToken};
      }
      final result = await _functions
          .httpsCallable(naverSignInCallableName)
          .call(payload);
      final data = Map<String, dynamic>.from(result.data as Map);
      final customToken = data['token'] as String?;
      if (customToken == null || customToken.isEmpty) {
        throw const AuthException('네이버 로그인에 실패했습니다. 다시 시도해주세요.');
      }
      final credentialResult = await _auth.signInWithCustomToken(customToken);
      await credentialResult.user?.reload();
      return _requireUser(_auth.currentUser ?? credentialResult.user);
    } on AuthException {
      rethrow;
    } on FirebaseFunctionsException catch (e) {
      throw AuthException(e.message ?? '네이버 로그인에 실패했습니다. 다시 시도해주세요.');
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_firebaseMessage(e));
    } catch (_) {
      throw const AuthException('네이버 로그인에 실패했습니다. 다시 시도해주세요.');
    }
  }

  Future<void> _loginWithNaverSdk() {
    final completer = Completer<void>();
    NaverLoginSDK.login(
      callback: OAuthLoginCallback(
        onSuccess: () {
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        onFailure: (httpStatus, message) {
          if (!completer.isCompleted) {
            completer.completeError(
              const AuthException('네이버 로그인에 실패했습니다. 다시 시도해주세요.'),
            );
          }
        },
        onError: (errorCode, message) {
          if (completer.isCompleted) {
            return;
          }
          final cancelled =
              message.contains('user_cancel') ||
              message.contains('Canceled By User');
          completer.completeError(
            cancelled
                ? const AuthException('로그인이 취소되었습니다.')
                : const AuthException('네이버 로그인에 실패했습니다. 다시 시도해주세요.'),
          );
        },
      ),
    );
    return completer.future;
  }

  Future<AppUser> _signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final result = await _auth.signInWithPopup(fb.GoogleAuthProvider());
        return _requireUser(result.user);
      }
      final signIn = GoogleSignIn.instance;
      await signIn.initialize();
      final account = await signIn.authenticate();
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const AuthException('구글 인증 정보를 가져오지 못했습니다.');
      }
      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);
      return _requireUser(result.user);
    } on AuthException {
      rethrow;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException('로그인이 취소되었습니다.');
      }
      throw const AuthException('구글 로그인에 실패했습니다. 다시 시도해주세요.');
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_firebaseMessage(e));
    } catch (_) {
      throw const AuthException('구글 로그인에 실패했습니다. 다시 시도해주세요.');
    }
  }

  AppUser _requireUser(fb.User? user) {
    final appUser = _toAppUser(user);
    if (appUser == null) {
      throw const AuthException('로그인에 실패했습니다. 다시 시도해주세요.');
    }
    return appUser;
  }

  AppUser? _toAppUser(fb.User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      providerId: user.providerData.isNotEmpty
          ? user.providerData.first.providerId
          : null,
    );
  }

  String _firebaseMessage(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return '이미 다른 방법으로 가입된 계정입니다.';
      case 'user-disabled':
        return '사용이 중지된 계정입니다.';
      case 'network-request-failed':
        return '네트워크 연결을 확인해주세요.';
      case 'web-context-canceled':
      case 'canceled':
        return '로그인이 취소되었습니다.';
      default:
        return '로그인에 실패했습니다. 다시 시도해주세요.';
    }
  }
}
