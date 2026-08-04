import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final fb.FirebaseAuth _auth;

  FirebaseAuthRepository({fb.FirebaseAuth? auth})
      : _auth = auth ?? fb.FirebaseAuth.instance;

  @override
  Stream<AppUser?> authStateChanges() {
    return _auth.authStateChanges().map(_toAppUser);
  }

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Future<AppUser> signInWith(AuthProviderType provider) {
    switch (provider) {
      case AuthProviderType.kakao:
        return _signInWithKakao();
      case AuthProviderType.google:
        return _signInWithGoogle();
      case AuthProviderType.apple:
        return _signInWithApple();
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<AppUser> _signInWithKakao() async {
    try {
      final token = await _loginWithKakaoSdk();
      final idToken = token.idToken;
      if (idToken == null) {
        throw const AuthException(
          '카카오 OpenID 설정이 필요합니다. 관리자에게 문의해주세요.',
        );
      }
      final credential = fb.OAuthProvider('oidc.kakao').credential(
        idToken: idToken,
        accessToken: token.accessToken,
      );
      final result = await _auth.signInWithCredential(credential);
      return _requireUser(result.user);
    } on AuthException {
      rethrow;
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

  Future<AppUser> _signInWithApple() async {
    try {
      final appleProvider = fb.AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      final result = kIsWeb
          ? await _auth.signInWithPopup(appleProvider)
          : await _auth.signInWithProvider(appleProvider);
      return _requireUser(result.user);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_firebaseMessage(e));
    } catch (_) {
      throw const AuthException('Apple 로그인에 실패했습니다. 다시 시도해주세요.');
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
