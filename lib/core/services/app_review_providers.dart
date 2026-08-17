import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_review_service.dart';

final appReviewServiceProvider = Provider<AppReviewService>((ref) {
  return AppReviewService();
});
