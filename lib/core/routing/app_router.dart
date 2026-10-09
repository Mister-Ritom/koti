import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/pages/onboarding_screen.dart';
import '../../providers/onboarding_providers.dart';
import '../../features/shell/app_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/accounts/accounts_screen.dart';
import '../../features/transactions/pages/transaction_detail_screen.dart';
import '../../features/transactions/pages/all_transactions_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasCompletedOnboarding = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    initialLocation: hasCompletedOnboarding ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/transaction/:id',
        builder: (context, state) => TransactionDetailScreen(uuid: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/all-transactions',
        builder: (context, state) => const AllTransactionsScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/accounts',
            builder: (context, state) => const AccountsScreen(),
          ),
          GoRoute(
            path: '/analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
