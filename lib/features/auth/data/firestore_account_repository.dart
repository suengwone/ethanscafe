import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/firestore_converters.dart';
import '../domain/account_models.dart';
import '../domain/account_repository.dart';

class FirestoreAccountRepository implements AccountRepository {
  FirestoreAccountRepository({
    required this.uid,
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _functions = functions ?? FirebaseFunctions.instanceFor(region: _region);

  final String uid;
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  static const collectionPath = 'users';
  static const registerBusinessCallableName = 'registerBusinessProfile';
  static const _region = 'asia-northeast3';

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collectionPath).doc(uid);

  @override
  Future<AccountProfile> load() async {
    final snapshot = await _doc.get();
    final data = snapshot.data();
    if (data == null) {
      return const AccountProfile();
    }
    return accountProfileFromFirestore(data);
  }

  @override
  Future<AccountProfile> registerBusiness(BusinessProfile business) async {
    validateBusinessProfile(business);
    final normalized = normalizeBusinessProfile(business);
    try {
      await _functions
          .httpsCallable(registerBusinessCallableName)
          .call<Object?>({
            'companyName': normalized.companyName,
            'businessNumber': normalized.businessNumber,
            'managerName': normalized.managerName,
            'phone': normalized.phone,
          });
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? '사업자 등록에 실패했습니다. 다시 시도해주세요.');
    }
    return load();
  }

  @override
  Future<AccountProfile> switchToCustomer() async {
    final current = await load();
    await _doc.set({
      'accountType': AccountType.customer.name,
    }, SetOptions(merge: true));
    return current.copyWith(type: AccountType.customer);
  }

  @override
  Future<AccountProfile> switchToBusiness() async {
    final current = await load();
    if (current.business == null) {
      throw StateError('저장된 사업자 정보가 없습니다.');
    }
    await _doc.set({
      'accountType': AccountType.business.name,
    }, SetOptions(merge: true));
    return current.copyWith(type: AccountType.business);
  }

  @override
  Future<AccountProfile> saveBirthDate(DateTime birthDate) async {
    final normalized = normalizeBirthDate(birthDate);
    final current = await load();
    await _doc.set({
      'birthDate': Timestamp.fromDate(normalized),
    }, SetOptions(merge: true));
    return current.copyWith(birthDate: normalized);
  }
}

AccountProfile accountProfileFromFirestore(Map<String, dynamic> data) {
  final business = data['business'];
  final birthDate = data['birthDate'];
  return AccountProfile(
    type:
        AccountType.values.asNameMap()[data['accountType']] ??
        AccountType.customer,
    birthDate: birthDate == null ? null : firestoreDateTime(birthDate),
    business: business is Map
        ? BusinessProfile(
            companyName: business['companyName'] as String? ?? '',
            businessNumber: business['businessNumber'] as String? ?? '',
            managerName: business['managerName'] as String? ?? '',
            phone: business['phone'] as String? ?? '',
          )
        : null,
  );
}

Map<String, dynamic> accountProfileToFirestore(AccountProfile profile) {
  final business = profile.business;
  return {
    'accountType': profile.type.name,
    if (business != null)
      'business': {
        'companyName': business.companyName,
        'businessNumber': business.businessNumber,
        'managerName': business.managerName,
        'phone': business.phone,
      },
  };
}
