import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';

enum AuthProviderType { kakao, naver, google }

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? providerId,
  }) = _AppUser;

  String get displayLabel => displayName ?? email ?? '회원';
}
