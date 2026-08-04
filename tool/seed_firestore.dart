import 'dart:convert';
import 'dart:io';

import 'package:cafe_app/features/beans/data/local_beans_repository.dart';
import 'package:cafe_app/features/coupon/data/local_coupons_repository.dart';
import 'package:cafe_app/features/home/data/local_banners_repository.dart';
import 'package:cafe_app/features/menu/data/local_menu_repository.dart';
import 'package:cafe_app/features/notice/data/local_notices_repository.dart';
import 'package:cafe_app/features/store/data/local_stores_repository.dart';

const projectId = 'foxtrot-3bdba';
const locationId = 'asia-northeast3';
const _firestoreBase = 'https://firestore.googleapis.com/v1';
const _databaseName = 'projects/$projectId/databases/(default)';

const _firebaseCliPublicClientId =
    '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com';
const _firebaseCliPublicClientSecret = 'j9iVZfS8kkCEFUPaAeJV0sAi';

Future<void> main() async {
  final client = HttpClient();
  try {
    final token = await _accessToken(client);
    await _ensureDatabase(client, token);
    final writes = await _buildWrites();
    await _commitWrites(client, token, writes);
    stdout.writeln('총 ${writes.length}개 문서를 업로드했습니다.');
    await _printCollectionCounts(client, token);
  } finally {
    client.close();
  }
}

Future<String> _accessToken(HttpClient client) async {
  final envToken = Platform.environment['FIREBASE_ACCESS_TOKEN'];
  if (envToken != null && envToken.isNotEmpty) {
    return envToken;
  }
  final home = Platform.environment['HOME'] ?? '';
  final configFile = File('$home/.config/configstore/firebase-tools.json');
  if (!configFile.existsSync()) {
    throw StateError(
      'firebase CLI 로그인 정보를 찾을 수 없습니다. `firebase login` 후 다시 실행하세요.',
    );
  }
  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, dynamic>;
  final tokens = config['tokens'] as Map<String, dynamic>?;
  final refreshToken = tokens?['refresh_token'] as String?;
  if (refreshToken == null || refreshToken.isEmpty) {
    throw StateError(
      'firebase CLI refresh token이 없습니다. `firebase login` 후 다시 실행하세요.',
    );
  }
  final result = await _request(
    client,
    'POST',
    'https://oauth2.googleapis.com/token',
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: Uri(
      queryParameters: {
        'client_id': _firebaseCliPublicClientId,
        'client_secret': _firebaseCliPublicClientSecret,
        'refresh_token': refreshToken,
        'grant_type': 'refresh_token',
      },
    ).query,
  );
  if (result.status != 200) {
    throw StateError('액세스 토큰 발급에 실패했습니다 (HTTP ${result.status}).');
  }
  return result.body['access_token'] as String;
}

Future<void> _ensureDatabase(HttpClient client, String token) async {
  const databaseUrl = '$_firestoreBase/$_databaseName';
  var result = await _authedRequest(client, token, 'GET', databaseUrl);
  if (result.status == 403) {
    stdout.writeln('Cloud Firestore API를 활성화하는 중...');
    await _authedRequest(
      client,
      token,
      'POST',
      'https://serviceusage.googleapis.com/v1/projects/$projectId/services/firestore.googleapis.com:enable',
      body: {},
    );
    result = await _poll(
      () => _authedRequest(client, token, 'GET', databaseUrl),
      until: (r) => r.status != 403,
    );
  }
  if (result.status == 404) {
    stdout.writeln('Firestore 데이터베이스를 생성하는 중 ($locationId)...');
    final create = await _authedRequest(
      client,
      token,
      'POST',
      '$_firestoreBase/projects/$projectId/databases?databaseId=(default)',
      body: {'type': 'FIRESTORE_NATIVE', 'locationId': locationId},
    );
    if (create.status != 200) {
      throw StateError('데이터베이스 생성에 실패했습니다 (HTTP ${create.status}).');
    }
    result = await _poll(
      () => _authedRequest(client, token, 'GET', databaseUrl),
      until: (r) => r.status == 200,
    );
  }
  if (result.status != 200) {
    throw StateError('Firestore 데이터베이스를 준비하지 못했습니다 (HTTP ${result.status}).');
  }
}

Future<List<Map<String, dynamic>>> _buildWrites() async {
  final writes = <Map<String, dynamic>>[];

  final menuItems = await LocalMenuRepository().loadMenuItems();
  for (final (index, item) in menuItems.indexed) {
    writes.add(_write('menus', item.id, {
      'name': _s(item.name),
      'description': _s(item.description),
      'category': _s(item.category.name),
      'price': _i(item.price),
      'priceFrom': _b(item.priceFrom),
      'badge': _s(item.badge.name),
      'servingOptions': _l(item.servingOptions),
      if (item.detail != null) 'detail': _s(item.detail!),
      'isRecommended': _b(item.isRecommended),
      'sortOrder': _i(index),
    }));
  }

  final beans = await LocalBeansRepository().loadBeans();
  for (final (index, bean) in beans.indexed) {
    writes.add(_write('beans', bean.id, {
      'name': _s(bean.name),
      'origin': _s(bean.origin),
      'description': _s(bean.description),
      'story': _s(bean.story),
      'roastLevel': _s(bean.roastLevel.name),
      'process': _s(bean.process),
      'tastingNotes': _l(bean.tastingNotes),
      'acidity': _i(bean.acidity),
      'body': _i(bean.body),
      'sweetness': _i(bean.sweetness),
      'recommendedBrews': _l(bean.recommendedBrews),
      'price200': _i(bean.price200),
      'price500': _i(bean.price500),
      'isNew': _b(bean.isNew),
      'sortOrder': _i(index),
    }));
  }

  final banners = await LocalBannersRepository().loadBanners();
  for (final (index, banner) in banners.indexed) {
    writes.add(_write('banners', banner.id, {
      'title': _s(banner.title),
      'subtitle': _s(banner.subtitle),
      'icon': _s(banner.icon),
      'sortOrder': _i(index),
    }));
  }

  final notices = await LocalNoticesRepository().loadNotices();
  for (final notice in notices) {
    writes.add(_write('notices', notice.id, {
      'title': _s(notice.title),
      'body': _s(notice.body),
      'category': _s(notice.category.name),
      'createdAt': _t(notice.createdAt),
      'isImportant': _b(notice.isImportant),
    }));
  }

  final stores = await LocalStoresRepository().loadStores();
  for (final (index, store) in stores.indexed) {
    writes.add(_write('stores', store.id, {
      'name': _s(store.name),
      'address': _s(store.address),
      'phone': _s(store.phone),
      'latitude': _d(store.latitude),
      'longitude': _d(store.longitude),
      'weekdayHours': _s(store.weekdayHours),
      'weekendHours': _s(store.weekendHours),
      'services': _l(store.services),
      'sortOrder': _i(index),
    }));
  }

  final coupons = await LocalCouponsRepository().loadCoupons();
  for (final coupon in coupons) {
    writes.add(_write('coupons', coupon.id, {
      'title': _s(coupon.title),
      'description': _s(coupon.description),
      'expiresAt': _t(coupon.expiresAt),
      'isUsed': _b(coupon.isUsed),
    }));
  }

  return writes;
}

Future<void> _commitWrites(
  HttpClient client,
  String token,
  List<Map<String, dynamic>> writes,
) async {
  final result = await _authedRequest(
    client,
    token,
    'POST',
    '$_firestoreBase/$_databaseName/documents:commit',
    body: {'writes': writes},
  );
  if (result.status != 200) {
    throw StateError('문서 업로드에 실패했습니다 (HTTP ${result.status}): ${result.body}');
  }
}

Future<void> _printCollectionCounts(HttpClient client, String token) async {
  const collections = [
    'menus',
    'beans',
    'banners',
    'notices',
    'stores',
    'coupons',
  ];
  for (final collection in collections) {
    final result = await _authedRequest(
      client,
      token,
      'GET',
      '$_firestoreBase/$_databaseName/documents/$collection?pageSize=300',
    );
    final documents = result.body['documents'] as List<dynamic>? ?? const [];
    stdout.writeln('$collection: ${documents.length}개 문서');
  }
}

Map<String, dynamic> _write(
  String collection,
  String id,
  Map<String, dynamic> fields,
) {
  return {
    'update': {
      'name': '$_databaseName/documents/$collection/$id',
      'fields': fields,
    },
  };
}

Map<String, dynamic> _s(String value) => {'stringValue': value};

Map<String, dynamic> _i(int value) => {'integerValue': '$value'};

Map<String, dynamic> _d(double value) => {'doubleValue': value};

Map<String, dynamic> _b(bool value) => {'booleanValue': value};

Map<String, dynamic> _t(DateTime value) =>
    {'timestampValue': value.toUtc().toIso8601String()};

Map<String, dynamic> _l(List<String> values) =>
    {'arrayValue': {'values': values.map(_s).toList()}};

Future<_HttpResult> _poll(
  Future<_HttpResult> Function() action, {
  required bool Function(_HttpResult) until,
  int attempts = 30,
}) async {
  var result = await action();
  for (var i = 0; i < attempts && !until(result); i++) {
    await Future<void>.delayed(const Duration(seconds: 5));
    result = await action();
  }
  return result;
}

Future<_HttpResult> _authedRequest(
  HttpClient client,
  String token,
  String method,
  String url, {
  Object? body,
}) {
  return _request(
    client,
    method,
    url,
    headers: {
      'Authorization': 'Bearer $token',
      if (body != null) 'Content-Type': 'application/json',
    },
    body: body is String || body == null ? body as String? : jsonEncode(body),
  );
}

Future<_HttpResult> _request(
  HttpClient client,
  String method,
  String url, {
  Map<String, String> headers = const {},
  String? body,
}) async {
  final request = await client.openUrl(method, Uri.parse(url));
  headers.forEach(request.headers.set);
  if (body != null) {
    request.add(utf8.encode(body));
  }
  final response = await request.close();
  final text = await utf8.decoder.bind(response).join();
  Map<String, dynamic> json;
  try {
    json = jsonDecode(text) as Map<String, dynamic>;
  } catch (_) {
    json = {'raw': text};
  }
  return _HttpResult(response.statusCode, json);
}

class _HttpResult {
  _HttpResult(this.status, this.body);

  final int status;
  final Map<String, dynamic> body;
}
