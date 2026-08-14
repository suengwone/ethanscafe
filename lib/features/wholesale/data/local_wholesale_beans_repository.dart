import '../../beans/domain/bean_models.dart';
import '../domain/wholesale_beans_repository.dart';
import '../domain/wholesale_models.dart';

class LocalWholesaleBeansRepository implements WholesaleBeansRepository {
  static const _beans = [
    WholesaleBean(
      id: 'peru-el-babaco-bourbon',
      name: '페루 엘 바바코 버번',
      origin: '페루 카하마르카',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['토피', '감귤류', '누룽지캔디'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 46000),
        WholesalePriceTier(minKg: 10, pricePerKg: 43000),
        WholesalePriceTier(minKg: 30, pricePerKg: 39000),
      ],
      isBest: true,
    ),
    WholesaleBean(
      id: 'brazil-monte-belo-yellow-bourbon',
      name: '브라질 몬테 벨로 옐로우버본',
      origin: '브라질 몬테 벨로',
      roastLevel: RoastLevel.mediumDark,
      process: '펄프드 내추럴',
      tastingNotes: ['아몬드', '카라멜', '화이트초콜릿'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 37000),
        WholesalePriceTier(minKg: 10, pricePerKg: 34500),
        WholesalePriceTier(minKg: 30, pricePerKg: 31000),
      ],
      isBest: true,
    ),
    WholesaleBean(
      id: 'guatemala-antigua-la-gloria',
      name: '과테말라 안티구아 라 글로리아 SHB',
      origin: '과테말라 안티구아',
      roastLevel: RoastLevel.medium,
      process: '워시드',
      tastingNotes: ['당밀', '월넛', '다크초콜릿'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 39000),
        WholesalePriceTier(minKg: 10, pricePerKg: 36500),
        WholesalePriceTier(minKg: 30, pricePerKg: 33000),
      ],
    ),
    WholesaleBean(
      id: 'ethiopia-yirgacheffe-aricha',
      name: '에티오피아 예가체프 아리차 에이미 G1',
      origin: '에티오피아 예가체프',
      roastLevel: RoastLevel.light,
      process: '내추럴',
      tastingNotes: ['스트로베리', '피치', '캔디'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 40000),
        WholesalePriceTier(minKg: 10, pricePerKg: 37500),
        WholesalePriceTier(minKg: 30, pricePerKg: 34000),
      ],
    ),
    WholesaleBean(
      id: 'indonesia-mandheling-g1',
      name: '인도네시아 만델링 G1 TP',
      origin: '인도네시아 수마트라',
      roastLevel: RoastLevel.mediumDark,
      process: '웻 헐드',
      tastingNotes: ['카카오', '마카다미아', '탠저린'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 43000),
        WholesalePriceTier(minKg: 10, pricePerKg: 40000),
        WholesalePriceTier(minKg: 30, pricePerKg: 36000),
      ],
    ),
    WholesaleBean(
      id: 'guatemala-decaf-mountain-water',
      name: '디카페인 과테말라 SHB EP 마운틴 워터',
      origin: '과테말라',
      roastLevel: RoastLevel.medium,
      process: '마운틴 워터 디카페인',
      tastingNotes: ['호박', '브라운 슈가', '몰트'],
      minOrderKg: 5,
      tiers: [
        WholesalePriceTier(minKg: 5, pricePerKg: 46500),
        WholesalePriceTier(minKg: 10, pricePerKg: 43500),
        WholesalePriceTier(minKg: 30, pricePerKg: 39500),
      ],
    ),
  ];

  @override
  Future<List<WholesaleBean>> loadWholesaleBeans() async => _beans;
}
