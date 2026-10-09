import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/design/koti_colors.dart';
import '../../core/design/koti_spacing.dart';
import '../../providers/theme_provider.dart';
import '../../providers/currency_provider.dart';
import '../../domain/services/data_transfer_service.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(KotiSpacing.l),
        children: [
          _buildSectionHeader(context, 'PREFERENCES'),
          _buildThemeToggle(context, ref, themeMode),
          _buildCurrencyToggle(context, ref, currency),
          
          const SizedBox(height: KotiSpacing.xl),
          
          _buildSectionHeader(context, 'DATA & PRIVACY'),
          _SettingsTile(
            icon: Icons.upload_file,
            title: 'Export Backup',
            subtitle: 'Save your data to a JSON file',
            onTap: () => _exportData(context, ref),
          ),
          _SettingsTile(
            icon: Icons.download_rounded,
            title: 'Import Backup',
            subtitle: 'Restore from a JSON file',
            onTap: () => _importData(context, ref),
          ),
          _SettingsTile(
            icon: Icons.shield_outlined,
            title: 'Privacy Policy',
            subtitle: 'Read our offline-first guarantee',
            onTap: () => _showPrivacyPolicy(context),
          ),
          
          const SizedBox(height: KotiSpacing.xl),
          
          _buildSectionHeader(context, 'ABOUT KOTI'),
          _SettingsTile(
            icon: Icons.favorite_border,
            title: 'Refer a Friend',
            subtitle: 'Share the Koti experience',
            onTap: () => _showReferral(context),
          ),
          _SettingsTile(
            icon: Icons.mail_outline,
            title: 'Contact Support',
            subtitle: AppConstants.supportEmail,
            onTap: () => launchUrl(Uri.parse('mailto:${AppConstants.supportEmail}')),
          ),
          
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KotiSpacing.m, left: KotiSpacing.xs),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref, ThemeMode currentMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: KotiSpacing.m),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? KotiColors.darkSurfaceElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.palette_outlined),
        title: const Text('Theme'),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<ThemeMode>(
            value: currentMode,
            borderRadius: BorderRadius.circular(16),
            icon: const Icon(Icons.unfold_more_rounded, color: Colors.grey, size: 20),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            alignment: Alignment.centerRight,
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system, 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.brightness_auto_rounded, size: 18), SizedBox(width: 8), Text('System')],
                )
              ),
              DropdownMenuItem(
                value: ThemeMode.light, 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.light_mode_rounded, size: 18, color: Colors.orangeAccent), SizedBox(width: 8), Text('Light')],
                )
              ),
              DropdownMenuItem(
                value: ThemeMode.dark, 
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.dark_mode_rounded, size: 18, color: KotiColors.primaryAccent), SizedBox(width: 8), Text('Dark')],
                )
              ),
            ],
            onChanged: (mode) {
              if (mode != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(mode);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyToggle(BuildContext context, WidgetRef ref, String currentCurrency) {
    return Container(
      margin: const EdgeInsets.only(bottom: KotiSpacing.m),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? KotiColors.darkSurfaceElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.public),
        title: const Text('Currency & Country'),
        subtitle: const Text('Tap to search 150+ countries'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(currentCurrency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: () {
          showCurrencyPicker(
            context: context,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            onSelect: (Currency currency) {
              ref.read(currencyProvider.notifier).setCurrency(currency.symbol);
            },
            favorite: ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'CAD', 'AUD'],
          );
        },
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(dataTransferProvider).exportData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Export successful!' : 'Export failed or cancelled.')),
      );
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(dataTransferProvider).importData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Import successful!' : 'Import failed or cancelled.')),
      );
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Guarantee'),
        content: const Text(
          'Koti is an offline-first application. All your financial data stays securely on your device. '
          'We do not collect, transmit, or sell your personal data to any external servers. '
          'You are in complete control of your data via the export feature.'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('I Understand')),
        ],
      ),
    );
  }

  void _showReferral(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(KotiSpacing.xxl),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomSheetTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: KotiSpacing.xxl),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
            ),
            
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: KotiColors.primaryAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_rounded, size: 48, color: KotiColors.primaryAccent),
            ),
            const SizedBox(height: KotiSpacing.xl),
            
            // Text
            Text(
              'Share Koti with Friends',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KotiSpacing.m),
            Text(
              'Good financial habits are better together. Invite your friends to Koti and help them take control of their money.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KotiSpacing.xxl),
            
            // Share Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.ios_share_rounded, size: 20),
                label: const Text('Share Invite Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: KotiColors.primaryAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: KotiSpacing.m),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  final RenderBox? box = ctx.findRenderObject() as RenderBox?;
                  final Rect? rect = box != null ? (box.localToGlobal(Offset.zero) & box.size) : null;
                  
                  Navigator.pop(ctx);
                  
                  Share.share(
                    AppConstants.shareMessage,
                    sharePositionOrigin: rect,
                  );
                },
              ),
            ),
            const SizedBox(height: KotiSpacing.m),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Maybe Later', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: KotiSpacing.l),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: KotiSpacing.s),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? KotiColors.darkSurfaceElevated : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: KotiColors.primaryAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
