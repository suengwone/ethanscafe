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

  /// 이름도 이메일도 없을 때 쓸 문구는 화면이 고른다.
  String? get displayLabel => displayName ?? email;
}
