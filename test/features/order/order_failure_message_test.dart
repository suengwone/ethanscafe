import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafe_app/features/order/presentation/order_failure_message.dart';
import 'package:cafe_app/l10n/app_localizations.dart';

Future<AppLocalizations> _l10n(Locale locale) =>
    AppLocalizations.delegate.load(locale);

FirebaseFunctionsException _error(String code, String message) =>
    FirebaseFunctionsException(code: code, message: message);

void main() {
  test('환불까지 끝난 실패는 그렇다고 말한다', () async {
    final l10n = await _l10n(const Locale('ko'));
    final message = orderFailureMessage(
      l10n,
      _error('aborted', '주문에 실패해 결제를 자동 취소(환불)했습니다. (품절된 상품이 포함되어 있습니다.)'),
    );

    expect(message, contains('환불'));
    // 고객이 장바구니에서 뭘 빼야 하는지 알 수 있게 사유도 남긴다.
    expect(message, contains('품절'));
  });

  test('환불이 남은 실패는 고객센터로 보낸다', () async {
    final l10n = await _l10n(const Locale('ko'));
    final message = orderFailureMessage(
      l10n,
      _error('internal', '주문에 실패했고 결제 취소도 되지 않았습니다.'),
    );

    expect(message, contains('고객센터'));
  });

  test('영어로 읽는 사람에게는 결말을 영어로 말한다', () async {
    final l10n = await _l10n(const Locale('en'));
    final message = orderFailureMessage(l10n, _error('aborted', '품절'));

    expect(message, contains('refunded'));
  });

  test('결제와 무관한 실패는 그대로 보여 준다', () async {
    final l10n = await _l10n(const Locale('ko'));

    expect(
      orderFailureMessage(
        l10n,
        _error('failed-precondition', '장바구니가 비어 있습니다.'),
      ),
      '장바구니가 비어 있습니다.',
    );
  });

  test('콜러블이 아닌 오류는 일반 문구로 덮는다', () async {
    final l10n = await _l10n(const Locale('ko'));

    expect(
      orderFailureMessage(l10n, StateError('소켓 끊김')),
      l10n.orderFailedGeneric,
    );
    expect(
      orderFailureMessage(l10n, _error('aborted', '')),
      l10n.orderFailedGeneric,
    );
  });
}
