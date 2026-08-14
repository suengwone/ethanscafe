import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/account_models.dart';
import '../domain/account_repository.dart';

class FirestoreAccountRepository implements AccountRepository {
  FirestoreAccountRepository({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  static const collectionPath = 'users';

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
    final profile = AccountProfile(
      type: AccountType.business,
      business: normalizeBusinessProfile(business),
    );
    await _doc.set(accountProfileToFirestore(profile), SetOptions(merge: true));
    return profile;
  }

  @override
  Future<AccountProfile> switchToCustomer() async {
    await _doc.set(
      {
        'accountType': AccountType.customer.name,
        'business': FieldValue.delete(),
      },
      SetOptions(merge: true),
    );
    return const AccountProfile();
  }
}

AccountProfile accountProfileFromFirestore(Map<String, dynamic> data) {
  final business = data['business'];
  return AccountProfile(
    type: AccountType.values.asNameMap()[data['accountType']] ??
        AccountType.customer,
    business: business is Map<String, dynamic>
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
