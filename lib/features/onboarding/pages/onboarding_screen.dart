import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../../../providers/database_provider.dart';
import '../../../data/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/onboarding_providers.dart';
import '../../../providers/balance_providers.dart';
import '../../../providers/currency_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../core/design/koti_colors.dart';
import '../../../core/design/koti_radii.dart';
import '../../../core/design/koti_spacing.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _balanceController = TextEditingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save balance
      final initialBalanceStr = _balanceController.text.trim();
      double initialBalance = 0.0;
      if (initialBalanceStr.isNotEmpty) {
        initialBalance = double.tryParse(initialBalanceStr) ?? 0.0;
      }
      
      // Update both shared prefs and the state provider
      ref.read(sharedPreferencesProvider).setDouble('initialBalance', initialBalance);
      ref.read(initialBalanceProvider.notifier).state = initialBalance;
      
      // Create initial wallet
      final db = ref.read(databaseProvider);
      final hasWallets = await db.walletDao.getAllWallets();
      if (hasWallets.isEmpty) {
        await db.walletDao.insertWallet(
          WalletsCompanion.insert(
            id: const Uuid().v4(),
            name: 'Main Wallet',
            type: 'cash',
            initialBalance: drift.Value(initialBalance),
          ),
        );
      }
      
      // Complete onboarding
      ref.read(onboardingCompletedProvider.notifier).completeOnboarding();
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            physics: const NeverScrollableScrollPhysics(), // Force using buttons
            children: [
              _buildImagePage(
                imagePath: 'assets/images/onboarding_welcome.png',
                title: 'Smart Finance,\nBrightest Future',
                subtitle: 'Grow Your Wealth Effortlessly.\nYour Financial Future Starts Here.',
              ),
              _buildImagePage(
                imagePath: 'assets/images/onboarding_value.png',
                title: 'Track Every Detail',
                subtitle: 'Intelligent analytics that show you exactly where your money goes.',
              ),
              _buildImagePage(
                imagePath: 'assets/images/onboarding_security.png',
                title: 'Bank-Grade Security',
                subtitle: 'Your data is encrypted and locked safely on your device.',
              ),
              _buildSetupPage(),
            ],
          ),
          
          // Next/Start Button
          Positioned(
            bottom: KotiSpacing.xxl,
            left: KotiSpacing.l,
            right: KotiSpacing.l,
            child: FilledButton(
              onPressed: _nextPage,
              style: FilledButton.styleFrom(
                backgroundColor: KotiColors.primaryAccent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: const RoundedRectangleBorder(
                  borderRadius: KotiRadii.roundedMedium,
                ),
              ),
              child: Text(
                _currentPage == 3 ? 'Start Tracking' : 'Continue',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
          
          // Progress Dots
          if (_currentPage < 3)
            Positioned(
              bottom: KotiSpacing.xxl + 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index 
                          ? KotiColors.primaryAccent 
                          : Colors.grey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePage({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(color: KotiColors.darkBackground),
        ),
        // Gradient overlay for text readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
                Colors.black.withValues(alpha: 0.95),
              ],
              stops: const [0.4, 0.7, 1.0],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(KotiSpacing.l),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: KotiSpacing.m),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 140), // Space for button and dots
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetupPage() {
    final currencySymbol = ref.watch(currencyProvider);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(KotiSpacing.l),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: KotiSpacing.xl),
            Text(
              'Just one last thing',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: KotiSpacing.s),
            Text(
              'Let\'s set up your starting balance.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: KotiSpacing.xxl),
            
            // Balance input form
            Container(
              padding: const EdgeInsets.all(KotiSpacing.l),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? KotiColors.darkSurfaceElevated 
                    : Colors.white,
                borderRadius: KotiRadii.roundedLarge,
                boxShadow: Theme.of(context).brightness == Brightness.light ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Balance', style: Theme.of(context).textTheme.labelLarge),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('$currencySymbol ', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: TextField(
                          controller: _balanceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: const InputDecoration(
                            hintText: '0.00',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
