import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';

/// 배너 문서의 `icon` 값과 실제 아이콘을 잇는 표.
///
/// 관리자 화면의 아이콘 선택지도 여기서 나오므로, 쓸 수 있는 아이콘을 늘리려면
/// 이 표와 [bannerIconLabel]에만 항목을 더하면 홈 배너와 등록 화면이 함께
/// 따라온다.
const bannerIconChoices = <String, IconData>{
  'sparkles': LucideIcons.sparkles,
  'snowflake': LucideIcons.snowflake300,
  'bean': LucideIcons.bean300,
  'gift': LucideIcons.gift300,
};

const defaultBannerIcon = 'sparkles';

IconData bannerIcon(String icon) =>
    bannerIconChoices[icon] ?? bannerIconChoices[defaultBannerIcon]!;

String bannerIconLabel(AppLocalizations l10n, String icon) =>
    switch (icon) {
      'snowflake' => l10n.bannerIconSnowflake,
      'bean' => l10n.bannerIconBean,
      'gift' => l10n.bannerIconGift,
      _ => l10n.bannerIconSparkles,
    };
