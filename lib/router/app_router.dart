import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/widgets/app_shell.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/beans/presentation/bean_detail_screen.dart';
import '../features/menu/presentation/menu_screen.dart';
import '../features/points/presentation/points_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

const publicPaths = {'/', '/login', '/menu'};

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
                    path: 'beans/:beanId',
                    builder: (context, state) => BeanDetailScreen(
                      beanId: state.pathParameters['beanId']!,
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
