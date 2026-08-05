import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/widgets/app_shell.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/beans/presentation/bean_cart_screen.dart';
import '../features/beans/presentation/bean_detail_screen.dart';
import '../features/coupon/presentation/coupon_list_screen.dart';
import '../features/menu/presentation/favorite_menu_screen.dart';
import '../features/menu/presentation/menu_detail_screen.dart';
import '../features/menu/presentation/menu_screen.dart';
import '../features/notice/presentation/notice_list_screen.dart';
import '../features/order/presentation/order_history_screen.dart';
import '../features/points/presentation/points_screen.dart';
import '../features/points/presentation/qr_scan_screen.dart';
import '../features/profile/presentation/delivery_address_screen.dart';
import '../features/profile/presentation/notification_settings_screen.dart';
import '../features/profile/presentation/payment_methods_screen.dart';
import '../features/profile/presentation/policy_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/support_screen.dart';
import '../features/store/presentation/store_list_screen.dart';

const publicPaths = {'/', '/login', '/menu', '/notices', '/stores'};

bool isPublicPath(String location) =>
    publicPaths.contains(location) || location.startsWith('/menu/');

final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authStateProvider).asData?.value != null;
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (!isLoggedIn && !isPublicPath(state.matchedLocation)) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'notices',
                    builder: (context, state) => const NoticeListScreen(),
                  ),
                  GoRoute(
                    path: 'stores',
                    builder: (context, state) => const StoreListScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/menu',
                builder: (context, state) => const MenuScreen(),
                routes: [
                  GoRoute(
                    path: 'beans-cart',
                    builder: (context, state) => const BeanCartScreen(),
                  ),
                  GoRoute(
                    path: 'beans/:beanId',
                    builder: (context, state) => BeanDetailScreen(
                      beanId: state.pathParameters['beanId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'item/:menuId',
                    builder: (context, state) => MenuDetailScreen(
                      menuId: state.pathParameters['menuId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/points',
                builder: (context, state) => const PointsScreen(),
                routes: [
                  GoRoute(
                    path: 'scan',
                    builder: (context, state) => const QrScanScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'favorites',
                    builder: (context, state) => const FavoriteMenuScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (context, state) =>
                        const NotificationSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'coupons',
                    builder: (context, state) => const CouponListScreen(),
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const OrderHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'payment-methods',
                    builder: (context, state) => const PaymentMethodsScreen(),
                  ),
                  GoRoute(
                    path: 'addresses',
                    builder: (context, state) => const DeliveryAddressScreen(),
                  ),
                  GoRoute(
                    path: 'support',
                    builder: (context, state) => const SupportScreen(),
                  ),
                  GoRoute(
                    path: 'terms',
                    builder: (context, state) =>
                        const PolicyScreen(type: PolicyType.terms),
                  ),
                  GoRoute(
                    path: 'privacy',
                    builder: (context, state) =>
                        const PolicyScreen(type: PolicyType.privacy),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
