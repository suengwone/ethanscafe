import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/account_models.dart';
import '../../auth/presentation/account_providers.dart';
import '../../wholesale/presentation/business_home_screen.dart';
import 'home_screen.dart';

class RoleHomeScreen extends ConsumerWidget {
  const RoleHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountType = ref.watch(accountTypeProvider);
    if (accountType == AccountType.business) {
      return const BusinessHomeScreen();
    }
    return const HomeScreen();
  }
}
