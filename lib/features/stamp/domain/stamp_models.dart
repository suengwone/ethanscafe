import 'package:freezed_annotation/freezed_annotation.dart';

part 'stamp_models.freezed.dart';
part 'stamp_models.g.dart';

@freezed
abstract class StampData with _$StampData {
  const StampData._();

  const factory StampData({
    @Default(0) int count,
    @Default(0) int totalEarned,
    @Default(<StampHistoryEntry>[]) List<StampHistoryEntry> history,
  }) = _StampData;

  factory StampData.fromJson(Map<String, dynamic> json) =>
      _$StampDataFromJson(json);
}

@freezed
abstract class StampHistoryEntry with _$StampHistoryEntry {
  const factory StampHistoryEntry({
    required String id,
    required int cups,
    @Default(0) int rewards,
    required DateTime createdAt,
  }) = _StampHistoryEntry;

  factory StampHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$StampHistoryEntryFromJson(json);
}

@freezed
abstract class StampEarnResult with _$StampEarnResult {
  const factory StampEarnResult({
    required String membershipId,
    required int cups,
    required int count,
    required int totalEarned,
    required int rewardsIssued,
  }) = _StampEarnResult;

  factory StampEarnResult.fromJson(Map<String, dynamic> json) =>
      _$StampEarnResultFromJson(json);
}
