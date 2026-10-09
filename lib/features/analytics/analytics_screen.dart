import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/design/koti_colors.dart';
import '../../core/design/koti_spacing.dart';
import '../../core/design/koti_radii.dart';
import '../../domain/services/analytics_service.dart';
import '../../providers/currency_provider.dart';
import '../../providers/transaction_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(monthlyAnalyticsProvider(_currentMonth));
    final earliestDate = ref.watch(earliestDateProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final canGoBack = _currentMonth.year > earliestDate.year || 
                     (_currentMonth.year == earliestDate.year && _currentMonth.month > earliestDate.month);
                     
    final canGoForward = !(_currentMonth.month == DateTime.now().month && _currentMonth.year == DateTime.now().year);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // Premium Month Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: KotiSpacing.l, vertical: KotiSpacing.s),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left_rounded, size: 32, color: canGoBack ? null : Colors.grey.withValues(alpha: 0.3)),
                  onPressed: canGoBack ? () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1)) : null,
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_currentMonth),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right_rounded, size: 32, color: canGoForward ? null : Colors.grey.withValues(alpha: 0.3)),
                  onPressed: canGoForward
                    ? () => setState(() => _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1))
                    : null,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: reportAsync.when(
              data: (report) {
                if (report.totalIncome == 0 && report.totalExpense == 0) {
                  return _buildEmptyState(context);
                }

                return ListView(
                  padding: const EdgeInsets.all(KotiSpacing.l),
                  children: [
                    // Summary Cards
                    Row(
                      children: [
                        Expanded(child: _SummaryCard(title: 'Income', amount: report.totalIncome, color: KotiColors.income)),
                        const SizedBox(width: KotiSpacing.m),
                        Expanded(child: _SummaryCard(title: 'Expense', amount: report.totalExpense, color: Colors.white, bgColor: KotiColors.expense)),
                      ],
                    ),
                    const SizedBox(height: KotiSpacing.xxl),
                    
                    // Daily Spending Chart (Bar Chart)
                    if (report.dailySpending.isNotEmpty) ...[
                      Text('Daily Spending', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: KotiSpacing.xl),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.only(top: KotiSpacing.xl, right: KotiSpacing.l, left: KotiSpacing.s, bottom: KotiSpacing.s),
                        decoration: BoxDecoration(
                          color: isDark ? KotiColors.darkSurfaceElevated : Colors.white,
                          borderRadius: KotiRadii.roundedXLarge,
                          boxShadow: [
                            if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
                          ]
                        ),
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 5 != 0) return const SizedBox.shrink();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(value.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            barGroups: List.generate(
                              DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day, 
                              (index) {
                                final day = index + 1;
                                final amount = report.dailySpending[day] ?? 0.0;
                                return BarChartGroupData(
                                  x: day,
                                  barRods: [
                                    BarChartRodData(
                                      toY: amount,
                                      color: amount > report.averageDailySpend * 2 ? KotiColors.expense : KotiColors.primaryAccent,
                                      width: 6,
                                      borderRadius: BorderRadius.circular(4),
                                    )
                                  ],
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: KotiSpacing.xxl),
                    ],

                    // Spending Breakdown Chart
                    Text('Top Categories', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: KotiSpacing.xl),
                    
                    Container(
                      height: 250,
                      padding: const EdgeInsets.all(KotiSpacing.l),
                      decoration: BoxDecoration(
                        color: isDark ? KotiColors.darkSurfaceElevated : Colors.white,
                        borderRadius: KotiRadii.roundedXLarge,
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 8)),
                        ]
                      ),
                      child: report.categoryBreakdown.isEmpty 
                        ? const Center(child: Text('No expenses to chart.'))
                        : Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 40,
                                    sections: _generateChartSections(report.categoryBreakdown),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _generateLegend(report.categoryBreakdown),
                                ),
                              )
                            ],
                          ),
                    ),
                    
                    const SizedBox(height: KotiSpacing.xxl),
                    
                    // Insights
                    Text('AI Insights', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: KotiSpacing.l),
                    ...report.insights.map((i) => Padding(
                      padding: const EdgeInsets.only(bottom: KotiSpacing.m),
                      child: Container(
                        padding: const EdgeInsets.all(KotiSpacing.l),
                        decoration: BoxDecoration(
                          color: KotiColors.primaryAccent.withValues(alpha: 0.1),
                          borderRadius: KotiRadii.roundedLarge,
                          border: Border.all(color: KotiColors.primaryAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.auto_awesome, color: KotiColors.primaryAccent),
                            const SizedBox(width: KotiSpacing.m),
                            Expanded(child: Text(i, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.4))),
                          ],
                        ),
                      ),
                    )),
                    
                    const SizedBox(height: 100), // Spacing for bottom nav
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KotiSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(KotiSpacing.xxl),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_graph_rounded, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: KotiSpacing.xl),
            Text(
              'No data for ${DateFormat('MMMM').format(_currentMonth)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: KotiSpacing.m),
            Text(
              'Add some expenses or income this month to see beautiful charts and insights.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateChartSections(Map<String, double> data) {
    final colors = [KotiColors.primaryAccent, Colors.blueAccent, Colors.amber, Colors.purpleAccent, Colors.teal];
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        value: e.value,
        title: '',
        color: color,
        radius: 60,
      );
    }).toList();
  }

  List<Widget> _generateLegend(Map<String, double> data) {
    final colors = [KotiColors.primaryAccent, Colors.blueAccent, Colors.amber, Colors.purpleAccent, Colors.teal];
    int i = 0;
    return data.entries.take(5).map((e) {
      final color = colors[i % colors.length];
      i++;
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(e.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
      );
    }).toList();
  }
}

class _SummaryCard extends ConsumerWidget {
  final String title;
  final double amount;
  final Color color;
  final Color? bgColor;

  const _SummaryCard({required this.title, required this.amount, required this.color, this.bgColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    return Container(
      padding: const EdgeInsets.all(KotiSpacing.l),
      decoration: BoxDecoration(
        color: bgColor != null ? bgColor!.withValues(alpha: 0.15) : color.withValues(alpha: 0.15),
        borderRadius: KotiRadii.roundedLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: KotiSpacing.m),
          Text('$currency${amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
