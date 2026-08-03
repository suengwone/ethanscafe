import '../domain/bean_models.dart';
import '../domain/beans_repository.dart';

class LocalBeansRepository implements BeansRepository {
  static const _beans = [
    Bean(
      id: 'nicaragua-finca-libre-geisha',
      name: '니카라과 핀카 리브레 게이샤',
      origin: '니카라과 누에바 세고비아',
      description: '자스민과 청포도, 홍차처럼 우아한 게이샤',
      story:
          '니카라과 핀카 리브레 농장의 게이샤 품종입니다. 자스민 꽃향 위로 '
          '레몬그라스와 복숭아, 청포도의 산뜻한 과즙미가 이어지고, 꿀 같은 단맛과 '
          '다즐링 홍차의 여운으로 마무리됩니다. 이번 시즌 새로 들어온 컬렉션의 '
          '얼굴입니다.',
      roastLevel: RoastLevel.light,
      process: '워시드',
      tastingNotes: ['자스민', '레몬그라스', '복숭아', '청포도', '허니', '다즐링'],
      acidity: 5,
      body: 2,
      sweetness: 5,
      recommendedBrews: ['핸드드립'],
      price200: 38000,
      price500: 82000,
      isNew: true,
    ),
    Bean(
      id: 'kenya-muranga-thangaini-aa',
      name: '케냐 무랑가 탕가이니 AA TOP',
      origin: '케냐 무랑가',
      description: '실론티와 메이플 시럽, 미디엄 헤비 바디',
      story:
          '케냐 무랑가 지역 탕가이니 팩토리의 AA TOP 등급 워시드 원두입니다. '
          '실론티를 연상시키는 홍차 같은 결 위에 메이플 시럽의 단맛, 오렌지와 '
          '베리의 과일 산미가 층층이 쌓입니다. 미디엄 헤비 바디로 마시는 내내 '
          '무게감이 살아 있습니다.',
      roastLevel: RoastLevel.mediumLight,
      process: '워시드',
      tastingNotes: ['실론티', '메이플 시럽', '오렌지', '베리'],
      acidity: 5,
      body: 4,
      sweetness: 4,
      recommendedBrews: ['핸드드립', '프렌치프레스'],
      price200: 19000,
      price500: 42000,
      isNew: true,
    ),
    Bean(
      id: 'peru-el-babaco-bourbon',
      name: '페루 엘 바바코 버번',
      origin: '페루 카하마르카',
      description: '토피의 단맛과 감귤류, 누룽지캔디의 고소함',
      story:
          '페루 엘 바바코 농장의 버번 품종을 워시드 방식으로 정제했습니다. '
          '토피의 진득한 단맛에 감귤류의 산미가 균형을 잡고, 식으면서 누룽지캔디 '
          '같은 구수한 단맛이 올라옵니다. 부담 없이 매일 마시기 좋은 데일리 '
          '커피입니다.',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['토피', '감귤류', '누룽지캔디'],
      acidity: 3,
      body: 3,
      sweetness: 4,
      recommendedBrews: ['핸드드립', '에스프레소'],
      price200: 16000,
      price500: 35000,
    ),
    Bean(
      id: 'indonesia-mandheling-g1',
      name: '인도네시아 만델링 G1 TP',
      origin: '인도네시아 수마트라',
      description: '갈색 설탕과 브랜디, 묵직한 초코 시럽',
      story:
          '수마트라 섬의 전통적인 만델링 커피로, G1 등급에 트리플 피크드(TP)로 '
          '결점두를 골라낸 원두입니다. 갈색 설탕과 브랜디의 깊은 향, 건포도의 '
          '단맛과 초코 시럽처럼 진한 바디가 특징입니다. 묵직한 커피를 좋아하는 '
          '분께 추천합니다.',
      roastLevel: RoastLevel.mediumDark,
      process: '세미 워시드',
      tastingNotes: ['갈색 설탕', '브랜디', '건포도', '초코 시럽'],
      acidity: 2,
      body: 5,
      sweetness: 3,
      recommendedBrews: ['프렌치프레스', '모카포트', '에스프레소'],
      price200: 15000,
      price500: 33000,
    ),
    Bean(
      id: 'colombia-la-pradera-red-berries',
      name: '콜롬비아 퀸디오 라 프라데라 레드베리즈',
      origin: '콜롬비아 퀸디오',
      description: '체리 콜라와 와인처럼 juicy한 인기 원두',
      story:
          '콜롬비아 퀸디오 카르니세로스 조합의 라 프라데라 농장에서 온 '
          '레드베리즈 로트입니다. 체리와 체리 콜라, 석류의 juicy한 과즙미에 '
          '와인 같은 복합미와 크림처럼 부드러운 질감이 어우러집니다. 매장에서 '
          '가장 사랑받는 드립 커피 중 하나입니다.',
      roastLevel: RoastLevel.mediumLight,
      process: '내추럴',
      tastingNotes: ['체리', '체리 콜라', '석류', '와인', '크림'],
      acidity: 4,
      body: 3,
      sweetness: 5,
      recommendedBrews: ['핸드드립'],
      price200: 18000,
      price500: 39000,
    ),
    Bean(
      id: 'brazil-monte-belo-yellow-bourbon',
      name: '브라질 몬테 벨로 옐로우버본',
      origin: '브라질 몬테 벨로',
      description: '아몬드와 카라멜, 화이트초콜릿의 고소한 단맛',
      story:
          '브라질 몬테 벨로 농장의 옐로우버본 품종을 펄프드 내추럴 방식으로 '
          '가공한 FC SC16UP 로트입니다. 아몬드와 바닐라의 고소함, 카라멜과 '
          '사탕수수의 단맛이 화이트초콜릿처럼 부드럽게 이어집니다. 에스프레소와 '
          '라떼 모두에 잘 어울리는 인기 원두입니다.',
      roastLevel: RoastLevel.mediumDark,
      process: '펄프드 내추럴',
      tastingNotes: ['아몬드', '바닐라', '카라멜', '사탕수수', '화이트초콜릿'],
      acidity: 2,
      body: 4,
      sweetness: 4,
      recommendedBrews: ['에스프레소', '모카포트', '핸드드립'],
      price200: 13000,
      price500: 28000,
    ),
    Bean(
      id: 'guatemala-antigua-la-gloria',
      name: '과테말라 안티구아 라 글로리아 SHB',
      origin: '과테말라 안티구아',
      description: '월넛과 브라운 슈가, 스모키한 초콜릿',
      story:
          '화산 지대인 안티구아 계곡의 라 글로리아 농장에서 자란 SHB 등급 '
          '원두입니다. 월넛과 바닐라의 고소함 사이로 페퍼민트의 산뜻함이 스치고, '
          '브라운 슈가의 단맛과 특유의 스모크, 초콜릿 피니시가 깊고 클래식한 '
          '한 잔을 만듭니다.',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['월넛', '바닐라', '페퍼민트', '브라운 슈가', '스모크', '초콜릿'],
      acidity: 3,
      body: 4,
      sweetness: 3,
      recommendedBrews: ['핸드드립', '프렌치프레스'],
      price200: 14000,
      price500: 30000,
    ),
    Bean(
      id: 'ethiopia-yirgacheffe-aricha',
      name: '에티오피아 예가체프 아리차 에이미 G1',
      origin: '에티오피아 예가체프',
      description: '스트로베리와 피치, 캔디처럼 달콤한 내추럴',
      story:
          '커피의 고향 에티오피아 예가체프, 아리차 스테이션의 에이미 G1 내추럴 '
          '로트입니다. 스트로베리와 체리, 피치의 화사한 과일 향이 터지고 브라운 '
          '슈가와 포도의 단맛이 캔디처럼 달콤하게 이어집니다. 식을수록 향이 더 '
          '풍성해지는 커피입니다.',
      roastLevel: RoastLevel.light,
      process: '내추럴',
      tastingNotes: ['스트로베리', '체리', '피치', '브라운 슈가', '포도', '캔디'],
      acidity: 5,
      body: 2,
      sweetness: 5,
      recommendedBrews: ['핸드드립', '프렌치프레스'],
      price200: 14000,
      price500: 30000,
    ),
    Bean(
      id: 'guatemala-decaf-mountain-water',
      name: '디카페인 과테말라 SHB EP 마운틴 워터',
      origin: '과테말라',
      description: '카페인 걱정 없이 즐기는 호박빛 단맛',
      story:
          '멕시코 마운틴 워터 프로세스로 카페인만 부드럽게 걷어낸 과테말라 SHB '
          'EP 원두입니다. 호박과 브라운 슈가의 포근한 단맛, 초콜릿과 몰트의 '
          '고소한 여운이 늦은 오후에도 부담 없습니다. 디카페인이라고 믿기 어려운 '
          '풍미가 강점입니다.',
      roastLevel: RoastLevel.medium,
      process: '마운틴 워터 디카페인',
      tastingNotes: ['호박', '브라운 슈가', '초콜렛', '몰트'],
      acidity: 2,
      body: 4,
      sweetness: 4,
      recommendedBrews: ['핸드드립', '에스프레소'],
      price200: 16000,
      price500: 35000,
    ),
  ];

  @override
  Future<List<Bean>> loadBeans() async => _beans;
}
