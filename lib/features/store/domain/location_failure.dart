/// 내 위치를 얻지 못한 까닭.
///
/// provider에는 BuildContext가 없어 읽는 사람의 언어를 알 수 없다. 까닭만
/// 올려 보내고 문구는 화면이 자기 l10n에서 고른다.
enum LocationFailure { serviceOff, permissionDenied }

class LocationUnavailable implements Exception {
  const LocationUnavailable(this.reason);

  final LocationFailure reason;
}
