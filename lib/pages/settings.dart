import 'package:budgetapp/navigation/routes.dart';
import 'package:budgetapp/pages/settings/about_us.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(theme, 'Preferences'),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Change Currency'),
            subtitle: const Text('Set your primary spending currency'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _appState.currentCurrency ?? 'USD',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () => _showCurrencyPicker(context, _appState),
          ),
          
          const Divider(indent: 16, endIndent: 16),
          _buildSectionHeader(theme, 'Support & Info'),
          // ListTile(
          //   leading: const Icon(Icons.explore_outlined),
          //   title: const Text('Take a Tour'),
          //   onTap: () => context.go(AppLinks.splash),
          // ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Us'),
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AboutUs(),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Contact'),
            onTap: () => _launchUrl(_helpUrl),
          ),
          ListTile(
            leading: const Icon(Icons.policy_outlined),
            title: const Text('Privacy Policy'),
            onTap: () => _launchUrl(_privacyUrl),
          ),
          
          const Divider(indent: 16, endIndent: 16),
          _buildSectionHeader(theme, 'Community'),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: const Text('Rate Spenditize'),
            subtitle: const Text('Love the app? Let us know on the Play Store'),
            onTap: () => _launchUrl(_playStoreUrl),
          ),
          
          const SizedBox(height: 40),
          Center(
            child: Text(
              'Spenditize v1.2.0', // Replace with dynamic version if needed
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ),
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
    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      context: context,
      showFlag: true,
      onSelect: (Currency currency) => appState.setCurrency(currency),
    );
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ToastService(context: context).showSuccessToast('Could not open link');
    }
  }
}