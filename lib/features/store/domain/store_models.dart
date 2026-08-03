import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_models.freezed.dart';

@freezed
abstract class CafeStore with _$CafeStore {
  const factory CafeStore({
    required String id,
    required String name,
    required String address,
    required String phone,
    required double latitude,
    required double longitude,
    required String weekdayHours,
    required String weekendHours,
    @Default(<String>[]) List<String> services,
  }) = _CafeStore;
}
