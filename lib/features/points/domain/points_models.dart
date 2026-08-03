import 'package:freezed_annotation/freezed_annotation.dart';

part 'points_models.freezed.dart';
part 'points_models.g.dart';

enum PointHistoryType { earn, use }

@freezed
abstract class PointsData with _$PointsData {
  const PointsData._();

  const factory PointsData({
    required String membershipId,
    @Default(0) int balance,
    @Default(<PointHistoryEntry>[]) List<PointHistoryEntry> history,
  }) = _PointsData;

  factory PointsData.fromJson(Map<String, dynamic> json) =>
      _$PointsDataFromJson(json);
}

@freezed
abstract class PointHistoryEntry with _$PointHistoryEntry {
  const PointHistoryEntry._();

  const factory PointHistoryEntry({
    required String id,
    required PointHistoryType type,
    required String description,
    required int amount,
    int? paymentAmount,
    required DateTime createdAt,
  }) = _PointHistoryEntry;

  factory PointHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$PointHistoryEntryFromJson(json);

  bool get isEarn => type == PointHistoryType.earn;
}
