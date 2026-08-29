import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/text_utils.dart';
import '../../../l10n/app_localizations.dart';

enum PolicyType { terms, privacy }

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key, required this.type});

  final PolicyType type;

  String _title(AppLocalizations l10n) => switch (type) {
    PolicyType.terms => l10n.policyTermsTitle,
    PolicyType.privacy => l10n.policyPrivacyTitle,
  };

  List<_PolicySection> get _sections => switch (type) {
    PolicyType.terms => _termsSections,
    PolicyType.privacy => _privacySections,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(_title(l10n))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          foxtrotScreenHPadding,
          16,
          foxtrotScreenHPadding,
          24,
        ),
        children: [
          Text(l10n.policyEffectiveDate, style: textTheme.bodySmall),
          const SizedBox(height: 6),
          Text(l10n.policyKoreanOnlyNotice, style: textTheme.bodySmall),
          const SizedBox(height: 16),
          for (final section in _sections) ...[
            Text(section.heading.keepWord, style: textTheme.titleSmall),
            const SizedBox(height: 8),
            Text(
              section.body.keepWord,
              style: textTheme.bodySmall?.copyWith(height: 1.6),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

/// 약관·방침 본문은 한국어 그대로 둔다. 법적 효력이 있는 문서라 옮겨 적는 순간
/// 원문과 다른 의무를 말할 위험이 있다. 번역이 필요하면 법률 검토를 거친 번역문을
/// 받아 여기에 로케일별로 나눠 넣는다.
class _PolicySection {
  const _PolicySection({required this.heading, required this.body});

  final String heading;
  final String body;
}

const _termsSections = [
  _PolicySection(
    heading: '제1조 (목적)',
    body:
        "본 약관은 Ethan's Cafe(이하 \"회사\")가 제공하는 멤버십 앱 서비스(이하 \"서비스\")의 "
        '이용 조건 및 절차, 회사와 회원 간의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.',
  ),
  _PolicySection(
    heading: '제2조 (정의)',
    body:
        '1. "회원"이란 본 약관에 동의하고 서비스에 가입한 자를 말합니다.\n'
        '2. "포인트"란 매장 결제 시 적립되어 현금처럼 사용할 수 있는 서비스 내 적립금을 말합니다.\n'
        '3. "쿠폰"이란 회사가 회원에게 제공하는 할인 또는 무료 교환 혜택을 말합니다.',
  ),
  _PolicySection(
    heading: '제3조 (약관의 효력 및 변경)',
    body:
        '1. 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 회원에게 공지함으로써 효력이 발생합니다.\n'
        '2. 회사는 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있으며, '
        '개정 시 적용일자 및 개정 사유를 명시하여 최소 7일 전에 공지합니다.',
  ),
  _PolicySection(
    heading: '제4조 (포인트 적립 및 사용)',
    body:
        '1. 포인트는 매장 결제 금액의 10%가 적립되며, 원 단위 미만은 내림 처리합니다.\n'
        '2. 포인트는 보유 잔액 한도 내에서 매장 결제 시 사용할 수 있습니다.\n'
        '3. 회원 탈퇴 시 보유 포인트는 소멸되며 복구되지 않습니다.',
  ),
  _PolicySection(
    heading: '제5조 (서비스의 중단)',
    body:
        '회사는 시스템 점검, 교체, 고장, 통신 두절 등의 사유가 발생한 경우 '
        '서비스 제공을 일시적으로 중단할 수 있으며, 사전에 공지함을 원칙으로 합니다.',
  ),
  _PolicySection(
    heading: '제6조 (회원의 의무)',
    body:
        '1. 회원은 관계 법령, 본 약관의 규정, 이용 안내 사항을 준수하여야 합니다.\n'
        '2. 회원은 타인의 계정 및 멤버십 QR 코드를 도용하여서는 안 됩니다.',
  ),
];

const _privacySections = [
  _PolicySection(
    heading: '1. 수집하는 개인정보 항목',
    body:
        '회사는 회원 가입 및 서비스 제공을 위해 다음의 개인정보를 수집합니다.\n'
        '- 필수: 이름(닉네임), 이메일 주소, 소셜 로그인 식별자\n'
        '- 선택: 프로필 사진, 배송지 정보(받는 사람, 연락처, 주소)',
  ),
  _PolicySection(
    heading: '2. 개인정보의 수집 및 이용 목적',
    body:
        '- 회원 식별 및 멤버십 서비스 제공\n'
        '- 포인트 적립·사용 내역 관리\n'
        '- 원두 상품 주문 및 배송\n'
        '- 이벤트, 프로모션 등 마케팅 정보 안내(동의 시)',
  ),
  _PolicySection(
    heading: '3. 개인정보의 보유 및 이용 기간',
    body:
        '회원 탈퇴 시 지체 없이 파기합니다. 단, 관계 법령에 따라 보존할 필요가 있는 경우 '
        '해당 법령에서 정한 기간 동안 보관합니다.\n'
        '- 계약 또는 청약철회 등에 관한 기록: 5년\n'
        '- 대금 결제 및 재화 등의 공급에 관한 기록: 5년\n'
        '- 소비자 불만 또는 분쟁 처리에 관한 기록: 3년',
  ),
  _PolicySection(
    heading: '4. 개인정보의 제3자 제공',
    body:
        '회사는 원칙적으로 회원의 개인정보를 외부에 제공하지 않습니다. '
        '다만, 회원이 사전에 동의하였거나 법령의 규정에 의한 경우는 예외로 합니다.',
  ),
  _PolicySection(
    heading: '5. 정보주체의 권리',
    body:
        '회원은 언제든지 자신의 개인정보를 조회·수정·삭제하거나 처리 정지를 요구할 수 있습니다. '
        '관련 문의는 고객센터(02-1234-5678, hello@ethanscafe.com)로 연락해주세요.',
  ),
  _PolicySection(
    heading: '6. 개인정보 보호책임자',
    body: '- 성명: 이단\n- 직책: 대표\n- 연락처: hello@ethanscafe.com',
  ),
];
