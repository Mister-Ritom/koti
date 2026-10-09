import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/design/koti_colors.dart';
import '../../core/design/koti_spacing.dart';
import '../transactions/widgets/add_transaction_sheet.dart';



class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<String> _routes = ['/home', '/accounts', '/analytics', '/settings'];

  void _onTap(int index) {
    if (index >= _routes.length) return;
    setState(() {
      _currentIndex = index;
    });
    context.go(_routes[index]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexOf(location);
    if (index != -1 && index != _currentIndex) {
      setState(() => _currentIndex = index);
    }
  }

  void _showAddTransactionOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(KotiSpacing.m),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: KotiSpacing.m),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        AddTransactionSheet.show(context, 'expense');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: KotiColors.expense.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.shopping_bag_outlined, color: KotiColors.expense, size: 28),
                            ),
                            const SizedBox(height: 12),
                            const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: KotiSpacing.m),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        AddTransactionSheet.show(context, 'income');
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2C2C2E) : Colors.grey.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: KotiColors.income.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.account_balance_wallet_outlined, color: KotiColors.income, size: 28),
                            ),
                            const SizedBox(height: 12),
                            const Text('Add Income', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: KotiSpacing.l),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: KotiSpacing.m),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: KotiSpacing.s, vertical: KotiSpacing.xs),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavItem(Icons.home_filled, 0),
                    _buildNavItem(Icons.account_balance_wallet, 1),
                    
                    // Central Add Button connected directly to modal
                    GestureDetector(
                      onTap: _showAddTransactionOptions,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: KotiSpacing.m),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: KotiColors.primaryAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: KotiColors.primaryAccent.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 28),
                      ),
                    ),
                    
                    _buildNavItem(Icons.show_chart, 2),
                    _buildNavItem(Icons.settings, 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: KotiSpacing.xs),
        padding: const EdgeInsets.all(KotiSpacing.m),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.withValues(alpha: 0.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected 
              ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
              : Theme.of(context).iconTheme.color?.withValues(alpha: 0.4),
          size: 24,
        ),
      ),
    );
  }
}
