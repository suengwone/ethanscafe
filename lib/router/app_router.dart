import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/widgets/app_shell.dart';
import '../features/home/presentation/role_home_screen.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/business_register_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/beans/presentation/bean_cart_screen.dart';
import '../features/beans/presentation/bean_detail_screen.dart';
import '../features/catalog/presentation/catalog_admin_screen.dart';
import '../features/coupon/presentation/coupon_list_screen.dart';
import '../features/gift/presentation/bean_gift_screen.dart';
import '../features/gift/presentation/gift_history_screen.dart';
import '../features/menu/presentation/favorite_menu_screen.dart';
import '../features/menu/presentation/menu_detail_screen.dart';
import '../features/menu/presentation/menu_screen.dart';
import '../features/notice/presentation/notice_list_screen.dart';
import '../features/order/presentation/order_history_screen.dart';
import '../features/pickup/presentation/pickup_cart_screen.dart';
import '../features/pickup/presentation/pickup_order_tracking_screen.dart';
import '../features/order/presentation/admin_orders_screen.dart';
import '../features/points/presentation/admin_points_scan_screen.dart';
import '../features/points/presentation/points_charge_screen.dart';
import '../features/points/presentation/points_screen.dart';
import '../features/profile/presentation/delivery_address_screen.dart';
import '../features/profile/presentation/notification_settings_screen.dart';
import '../features/profile/presentation/payment_methods_screen.dart';
import '../features/profile/presentation/policy_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/profile/presentation/support_screen.dart';
import '../features/referral/presentation/referral_screen.dart';
import '../features/store/presentation/store_detail_screen.dart';
import '../features/store/presentation/store_list_screen.dart';
import '../features/subscription/presentation/subscription_list_screen.dart';
import '../features/wholesale/presentation/wholesale_quote_history_screen.dart';
import '../features/wholesale/presentation/wholesale_quote_screen.dart';

const publicPaths = {'/', '/login', '/menu', '/notices', '/stores'};

/// `/menu` 하위지만 로그인이 필요한 거래 흐름.
/// 비회원 주문은 서버를 거치지 않아 결제·주문이 기기에만 남으므로 진입을 막는다.
const protectedMenuPaths = {'/menu/cart', '/menu/beans-cart'};

/// 원두 선물하기(`/menu/beans/:beanId/gift`)처럼 경로 파라미터가 섞인 거래 흐름.
const protectedMenuSuffixes = {'/gift'};

bool isPublicPath(String location) {
  if (protectedMenuPaths.contains(location)) {
    return false;
  }
  if (protectedMenuSuffixes.any(location.endsWith)) {
    return false;
  }
  return publicPaths.contains(location) ||
      location.startsWith('/menu/') ||
      location.startsWith('/stores/');
}

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
                builder: (context, state) => const RoleHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'notices',
                    builder: (context, state) => const NoticeListScreen(),
                  ),
                  GoRoute(
                    path: 'stores',
                    builder: (context, state) => const StoreListScreen(),
                    routes: [
                      GoRoute(
                        path: ':storeId',
                        builder: (context, state) => StoreDetailScreen(
                          storeId: state.pathParameters['storeId']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'wholesale/quote',
                    builder: (context, state) => WholesaleQuoteScreen(
                      initialBeanId: state.uri.queryParameters['bean'],
                    ),
                  ),
                  GoRoute(
                    path: 'wholesale/quotes',
                    builder: (context, state) =>
                        const WholesaleQuoteHistoryScreen(),
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
                    path: 'cart',
                    builder: (context, state) => const PickupCartScreen(),
                  ),
                  GoRoute(
                    path: 'beans-cart',
                    builder: (context, state) => const BeanCartScreen(),
                  ),
                  GoRoute(
                    path: 'beans/:beanId',
                    builder: (context, state) => BeanDetailScreen(
                      beanId: state.pathParameters['beanId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'gift',
                        builder: (context, state) => BeanGiftScreen(
                          beanId: state.pathParameters['beanId']!,
                        ),
                      ),
                    ],
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
                    path: 'charge',
                    builder: (context, state) => const PointsChargeScreen(),
                  ),
                  GoRoute(
                    path: 'earn-scan',
                    builder: (context, state) =>
                        const AdminPointsScanScreen(),
                  ),
                  GoRoute(
                    path: 'orders',
                    builder: (context, state) => const AdminOrdersScreen(),
                  ),
                  GoRoute(
                    path: 'catalog',
                    builder: (context, state) => const CatalogAdminScreen(),
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
                    routes: [
                      GoRoute(
                        path: 'track/:orderId',
                        builder: (context, state) => PickupOrderTrackingScreen(
                          orderId: state.pathParameters['orderId']!,
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'subscriptions',
                    builder: (context, state) =>
                        const SubscriptionListScreen(),
                  ),
                  GoRoute(
                    path: 'gifts',
                    builder: (context, state) => const GiftHistoryScreen(),
                  ),
                  GoRoute(
                    path: 'referral',
                    builder: (context, state) => const ReferralScreen(),
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
                    path: 'business',
                    builder: (context, state) =>
                        const BusinessRegisterScreen(),
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
