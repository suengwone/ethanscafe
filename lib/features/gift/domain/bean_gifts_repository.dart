import '../../beans/domain/bean_models.dart';
import 'gift_models.dart';

abstract class BeanGiftsRepository {
  Future<List<BeanGift>> load();

  Future<BeanGift> sendGift({
    required String beanId,
    required String beanName,
    required BeanWeight weight,
    required GrindOption grind,
    required int quantity,
    required int unitPrice,
    required String recipientName,
    required String recipientPhone,
    String message,
  });
}
