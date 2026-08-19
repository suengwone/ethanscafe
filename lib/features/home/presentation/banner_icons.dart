import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// 배너 문서의 `icon` 값과 실제 아이콘을 잇는 표.
///
/// 관리자 화면의 아이콘 선택지도 여기서 나오므로, 쓸 수 있는 아이콘을 늘리려면
/// 이 표에만 항목을 더하면 홈 배너와 등록 화면이 함께 따라온다.
const bannerIconChoices = <String, ({String label, IconData icon})>{
  'sparkles': (label: '반짝임', icon: LucideIcons.sparkles),
  'snowflake': (label: '눈꽃', icon: LucideIcons.snowflake300),
  'bean': (label: '원두', icon: LucideIcons.bean300),
  'gift': (label: '선물', icon: LucideIcons.gift300),
};

const defaultBannerIcon = 'sparkles';

IconData bannerIcon(String icon) =>
    (bannerIconChoices[icon] ?? bannerIconChoices[defaultBannerIcon]!).icon;
