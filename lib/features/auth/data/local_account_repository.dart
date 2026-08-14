import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/account_models.dart';
import '../domain/account_repository.dart';

class LocalAccountRepository implements AccountRepository {
  static const _storageKey = 'account_profile';

  @override
  Future<AccountProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) {
      return const AccountProfile();
    }
    return AccountProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<AccountProfile> registerBusiness(BusinessProfile business) async {
    validateBusinessProfile(business);
    final current = await load();
    final profile = current.copyWith(
      type: AccountType.business,
      business: normalizeBusinessProfile(business),
    );
    await _save(profile);
    return profile;
  }

  @override
  Future<AccountProfile> switchToCustomer() async {
    final current = await load();
    final profile = AccountProfile(birthDate: current.birthDate);
    await _save(profile);
    return profile;
  }

  @override
  Future<AccountProfile> saveBirthDate(DateTime birthDate) async {
    final current = await load();
    final profile = current.copyWith(birthDate: normalizeBirthDate(birthDate));
    await _save(profile);
    return profile;
  }

  Future<void> _save(AccountProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(profile.toJson()));
  }
}
