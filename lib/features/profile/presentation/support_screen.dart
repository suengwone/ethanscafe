import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _phone = '02-1234-5678';
  static const _email = 'hello@ethanscafe.com';

  Future<void> _call(BuildContext context) async {
    final uri = Uri(scheme: 'tel', path: _phone.replaceAll('-', ''));
    final launched = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).supportCallFailed(_phone)),
        ),
      );
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: _email);
    final launched = await canLaunchUrl(uri) && await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).supportMailFailed(_email)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).supportTitle)),
      body: ListView(
        padding: foxtrotListPadding,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              AppLocalizations.of(context).supportSectionContact,
              style: textTheme.titleSmall,
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(LucideIcons.phone),
                  title: Text(AppLocalizations.of(context).supportCall),
                  subtitle: Text(
                    AppLocalizations.of(context).supportCallHours(_phone),
                  ),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  onTap: () => _call(context),
                ),
                ListTile(
                  leading: const Icon(LucideIcons.mail),
                  title: Text(AppLocalizations.of(context).supportEmail),
                  subtitle: const Text(_email),
                  trailing: const Icon(LucideIcons.chevronRight, size: 18),
                  onTap: () => _sendEmail(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              AppLocalizations.of(context).supportSectionFaq,
              style: textTheme.titleSmall,
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (final faq in _faqs)
                  ExpansionTile(
                    leading: Icon(
                      LucideIcons.circleQuestionMark,
                      size: 20,
                      color: context.palette.muted,
                    ),
                    title: Text(faq.question, style: textTheme.labelLarge),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(faq.answer, style: textTheme.bodySmall)],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Faq {
  const _Faq({required this.question, required this.answer});

  final String question;
  final String answer;
}

const _faqs = [
  _Faq(
    question: '포인트는 어떻게 적립되나요?',
    answer:
        '매장 결제 시 결제 금액의 10%가 포인트로 적립됩니다. '
        '페이 탭의 멤버십 QR 코드를 결제 전에 제시해주세요.',
  ),
  _Faq(
    question: '적립한 포인트는 어떻게 사용하나요?',
    answer:
        '보유 포인트는 매장에서 현금처럼 사용할 수 있습니다. '
        '결제 시 직원에게 포인트 사용을 요청해주세요. 잔액 한도 내에서 차감됩니다.',
  ),
  _Faq(
    question: '쿠폰은 어디서 확인하나요?',
    answer:
        '마이 탭 > 쿠폰함에서 보유 중인 쿠폰과 사용 기한을 확인할 수 있습니다. '
        '만료된 쿠폰은 자동으로 사용 불가 처리됩니다.',
  ),
  _Faq(
    question: '원두 배송은 얼마나 걸리나요?',
    answer:
        '주문 후 로스팅을 진행하며, 보통 영업일 기준 2~3일 내에 발송됩니다. '
        '신선한 원두를 위해 주문 순서대로 로스팅해 보내드립니다.',
  ),
  _Faq(
    question: '회원 탈퇴는 어떻게 하나요?',
    answer:
        '고객센터 전화 또는 이메일로 탈퇴를 요청하실 수 있습니다. '
        '탈퇴 시 보유 포인트와 쿠폰은 모두 소멸되니 유의해주세요.',
  ),
];
