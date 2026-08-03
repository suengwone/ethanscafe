import '../domain/bean_models.dart';
import '../domain/beans_repository.dart';

class LocalBeansRepository implements BeansRepository {
  static const _beans = [
    Bean(
      id: 'foxtrot-house-blend',
      name: '폭스트롯 하우스 블렌드',
      origin: '브라질 · 콜롬비아 · 에티오피아',
      description: '매장 에스프레소에 사용하는 시그니처 블렌드',
      story:
          '폭스트롯 매장의 모든 에스프레소 메뉴에 사용하는 시그니처 블렌드입니다. '
          '다크초콜릿의 묵직한 단맛 위에 은은한 과일 산미가 얹혀, 우유와 만나도 '
          '커피의 존재감이 사라지지 않습니다. 매주 화요일 로스팅하여 가장 신선한 '
          '상태로 제공합니다.',
      roastLevel: RoastLevel.mediumDark,
      process: '블렌드 (워시드·내추럴)',
      tastingNotes: ['다크초콜릿', '캐러멜', '구운 아몬드'],
      acidity: 2,
      body: 4,
      sweetness: 4,
      recommendedBrews: ['에스프레소', '모카포트', '프렌치프레스'],
      price200: 13000,
      price500: 28000,
    ),
    Bean(
      id: 'ethiopia-yirgacheffe',
      name: '에티오피아 예가체프 G1',
      origin: '에티오피아 예가체프',
      description: '재스민 향과 복숭아 같은 화사한 산미',
      story:
          '커피의 고향 에티오피아, 그중에서도 예가체프는 화사한 커피의 대명사입니다. '
          '해발 1,900m 이상의 고지대에서 자란 체리를 워시드 방식으로 정제해 '
          '재스민 꽃향과 복숭아·베르가못의 산뜻한 과일 산미가 깨끗하게 표현됩니다. '
          '식으면서 홍차 같은 여운이 길게 이어집니다.',
      roastLevel: RoastLevel.light,
      process: '워시드',
      tastingNotes: ['재스민', '복숭아', '베르가못', '홍차'],
      acidity: 5,
      body: 2,
      sweetness: 4,
      recommendedBrews: ['핸드드립', '프렌치프레스'],
      price200: 18000,
      price500: 39000,
    ),
    Bean(
      id: 'colombia-supremo',
      name: '콜롬비아 수프레모',
      origin: '콜롬비아 우일라',
      description: '캐러멜의 단맛과 균형 잡힌 바디감',
      story:
          '콜롬비아 남부 우일라 지역의 수프레모 등급 원두입니다. 캐러멜과 '
          '밀크초콜릿의 단맛, 오렌지 같은 부드러운 산미가 균형을 이뤄 매일 마셔도 '
          '질리지 않습니다. 어떤 추출 도구와도 잘 어울리는 올라운더로, 원두 '
          '입문자에게 가장 먼저 추천하는 커피입니다.',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['캐러멜', '밀크초콜릿', '오렌지'],
      acidity: 3,
      body: 4,
      sweetness: 4,
      recommendedBrews: ['핸드드립', '에스프레소', '모카포트'],
      price200: 15000,
      price500: 33000,
    ),
    Bean(
      id: 'brazil-santos',
      name: '브라질 산토스 NY2',
      origin: '브라질 세하도',
      description: '고소한 너츠 향과 부드러운 초콜릿 피니시',
      story:
          '브라질 세하도 지역에서 내추럴 방식으로 가공한 산토스 NY2 등급 '
          '원두입니다. 헤이즐넛과 카카오의 고소함이 중심을 잡고 산미가 낮아 '
          '편안하게 마시기 좋습니다. 진하게 내려 우유를 곁들이면 카페라떼로도 '
          '훌륭합니다.',
      roastLevel: RoastLevel.mediumDark,
      process: '내추럴',
      tastingNotes: ['헤이즐넛', '카카오', '흑설탕'],
      acidity: 2,
      body: 4,
      sweetness: 3,
      recommendedBrews: ['에스프레소', '모카포트', '핸드드립'],
      price200: 14000,
      price500: 30000,
      isNew: true,
    ),
    Bean(
      id: 'guatemala-antigua',
      name: '과테말라 안티구아',
      origin: '과테말라 안티구아',
      description: '스모키한 향과 다크초콜릿의 묵직함',
      story:
          '화산 지대인 안티구아 계곡에서 자란 원두로, 미네랄이 풍부한 화산 토양이 '
          '만들어내는 특유의 스모키한 향이 매력입니다. 다크초콜릿의 묵직한 바디에 '
          '오렌지 필 같은 산미가 살짝 스치며, 깊고 클래식한 커피를 좋아하는 분께 '
          '추천합니다.',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['스모키', '다크초콜릿', '오렌지 필'],
      acidity: 3,
      body: 4,
      sweetness: 3,
      recommendedBrews: ['핸드드립', '프렌치프레스'],
      price200: 16000,
      price500: 35000,
    ),
    Bean(
      id: 'kenya-aa',
      name: '케냐 AA',
      origin: '케냐 니에리',
      description: '블랙커런트와 자몽의 진한 과즙미',
      story:
          '케냐 최고 등급인 AA 사이즈의 원두입니다. 블랙커런트와 자몽을 연상시키는 '
          '진하고 juicy한 산미, 와인 같은 복합적인 풍미가 특징입니다. 산미가 '
          '두렵지 않은 분이라면 케냐 특유의 강렬한 개성을 꼭 경험해 보세요.',
      roastLevel: RoastLevel.mediumLight,
      process: '워시드',
      tastingNotes: ['블랙커런트', '자몽', '레드와인'],
      acidity: 5,
      body: 3,
      sweetness: 4,
      recommendedBrews: ['핸드드립'],
      price200: 19000,
      price500: 42000,
      isNew: true,
    ),
    Bean(
      id: 'panama-geisha',
      name: '파나마 게이샤',
      origin: '파나마 보케테',
      description: '재스민과 열대과일, 꿀처럼 긴 여운',
      story:
          '세계에서 가장 비싼 커피로 꼽히는 게이샤 품종입니다. 파나마 보케테의 '
          '고지대 농장에서 소량 생산되며, 재스민·열대과일·꿀이 어우러진 향미의 '
          '층이 한 잔 안에서 계속 바뀝니다. 특별한 날, 특별한 사람과 나누기 좋은 '
          '커피입니다.',
      roastLevel: RoastLevel.light,
      process: '워시드',
      tastingNotes: ['재스민', '열대과일', '꿀', '얼그레이'],
      acidity: 5,
      body: 2,
      sweetness: 5,
      recommendedBrews: ['핸드드립'],
      price200: 45000,
      price500: 98000,
    ),
  ];

  @override
  Future<List<Bean>> loadBeans() async => _beans;
}
