import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/stamp_models.dart';
import '../domain/stamp_reward.dart';
import '../domain/stamps_repository.dart';

class LocalStampsRepository implements StampsRepository {
  static const _storageKey = 'stamp_data';

  @override
  Future<StampData> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      return StampData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
    return const StampData();
  }

  Future<StampData> earn({required int cups}) async {
    final prefs = await SharedPreferences.getInstance();
    var data = await load();
    final applied = applyStampEarn(count: data.count, cups: cups);

    data = data.copyWith(
      count: applied.newCount,
      totalEarned: data.totalEarned + cups,
      history: [
        StampHistoryEntry(
          id: _generateId(),
          cups: cups,
          rewards: applied.rewards,
          createdAt: DateTime.now(),
        ),
        ...data.history,
      ],
    );

    await prefs.setString(_storageKey, jsonEncode(data.toJson()));
    return data;
  }

  String _generateId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0xFFFF)}';
}
