import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/firestore_beans_repository.dart';
import '../data/local_beans_repository.dart';
import '../domain/bean_models.dart';
import '../domain/beans_repository.dart';

final beansRepositoryProvider = Provider<BeansRepository>((ref) {
  try {
    if (Firebase.apps.isNotEmpty) {
      return FirestoreBeansRepository();
    }
  } catch (_) {}
  return LocalBeansRepository();
});

final beansProvider = FutureProvider<List<Bean>>((ref) {
  return ref.watch(beansRepositoryProvider).loadBeans();
});

final beanProvider = FutureProvider.family<Bean, String>((ref, beanId) async {
  final beans = await ref.watch(beansProvider.future);
  return beans.firstWhere(
    (bean) => bean.id == beanId,
    orElse: () => throw StateError('원두를 찾을 수 없습니다: $beanId'),
  );
});
