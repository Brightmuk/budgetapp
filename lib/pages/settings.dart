import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/l10n/app_localizations_en.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:currency_picker/currency_picker.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Uri _playStoreUrl = Uri.parse('market://details?id=com.brimukon.spenditize');
  final Uri _privacyUrl = Uri.parse('https://brimukon.com/privacy');
  final Uri _helpUrl = Uri.parse('https://brimukon.com/support');

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<ApplicationState>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();

    return Scaffold(
      appBar: AppBar(
        title:  Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(theme, l10n.preferences),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title:  Text(l10n.change_currency),
            subtitle:  Text(l10n.set_your_primary_spending_currency),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _appState.currentCurrency ?? '\$',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => _showCurrencyPicker(context, _appState),
          ),
          
          const Divider(indent: 16, endIndent: 16),
          _buildSectionHeader(theme, l10n.support_info),
          // ListTile(
          //   leading: const Icon(Icons.explore_outlined),
          //   title: const Text('Take a Tour'),
          //   onTap: () => context.go(AppLinks.splash),
          // ),

          ListTile(
            leading: const Icon(Icons.help_outline),
            title:  Text(l10n.help_contact),
            onTap: () => _launchUrl(_helpUrl),
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title:  Text(l10n.privacy_policy),
            onTap: () => _launchUrl(_privacyUrl),
          ),
          

          ListTile(
            leading: const Icon(Icons.star_outline),
            title:  Text(l10n.rate_app),
            subtitle:  Text(l10n.love_the_app_let_us_know_on_the_play_store),
            onTap: () => _launchUrl(_playStoreUrl),
          ),
          
          Spacer(),
          _buildVersionFooter(theme),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, ApplicationState appState) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        inputDecoration: InputDecoration(
            hintText: l10n.search,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
      ),
      context: context,
      showFlag: true,
      onSelect: (Currency currency) => appState.setCurrency(currency),
      
    );
  }

  void _launchUrl(Uri url) async {
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ToastService(context: context).showSuccessToast(l10n.could_not_open_link);
    }
  }
  Widget _buildVersionFooter(ThemeData theme) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
  return FutureBuilder<PackageInfo>(
    future: PackageInfo.fromPlatform(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return const SizedBox.shrink();

      final info = snapshot.data!;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            children: [
              Text(
                l10n.app_version(info.version),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '© ${DateTime.now().year} Brimukon Labs',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}