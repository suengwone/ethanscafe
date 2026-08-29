import 'package:cloud_functions/cloud_functions.dart';

import '../../../l10n/app_localizations.dart';

/// 주문이 실패했을 때 고객에게 보여 줄 말.
///
/// 고객이 알아야 하는 건 두 가지다. 왜 안 됐는지, 그리고 **낸 돈은 어떻게 됐는지**.
/// 서버는 결제를 되돌렸는지를 오류 코드로 알려 준다 (`aborted`는 환불까지 끝난
/// 것, `internal`은 환불이 남은 것). 그 결말만 읽는 사람의 언어로 적고, 구체적인
/// 사유는 서버가 준 문장을 그대로 붙인다.
///
/// 사유가 한국어로만 오는 것은 아직 남은 한계다. 서버가 문구를 언어별로 갖고
/// 있어야 풀리는데, 지금은 환불 여부가 훨씬 급한 정보라 이렇게 둔다.
String orderFailureMessage(AppLocalizations l10n, Object error) {
  if (error is! FirebaseFunctionsException) {
    return l10n.orderFailedGeneric;
  }
  final reason = error.message?.trim() ?? '';
  if (reason.isEmpty) {
    return l10n.orderFailedGeneric;
  }
  return switch (error.code) {
    'aborted' => l10n.orderFailedRefunded(reason),
    'internal' => l10n.orderFailedRefundPending(reason),
    _ => reason,
  };
}
