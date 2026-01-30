import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/core/utils/string_extension.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/core/utils/date_util.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/core/widgets/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SingleWish extends StatefulWidget {
  final String wishId;
  const SingleWish({Key? key, required this.wishId}) : super(key: key);

  @override
  _SingleWishState createState() => _SingleWishState();
}

class _SingleWishState extends State<SingleWish> {
  late Future<Wish> _wishFuture;

  @override
  void initState() {
    super.initState();
    _loadWish();
  }

  void _loadWish() {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    _wishFuture = WishService(context: context, appState: appState).singleWish(widget.wishId);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: FutureBuilder<Wish>(
        future: _wishFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error(snapshot.error.toString())));
          }
          if (!snapshot.hasData) {
            return  Center(child: Text(l10n.wish_not_found));
          }

          final wish = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // M3 Large App Bar
              SliverAppBar.large(
                title: Text(wish.name.capitalize ,style: theme.textTheme.displayMedium,),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Price Card
                      _buildPriceCard(theme, wish, appState),
                      const SizedBox(height: 16),
                      // Details List Card
                      _buildDetailsCard(theme, wish),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // M3 Bottom Action Bar
      bottomNavigationBar: _buildBottomActions(theme, appState),
    );
  }

  Widget _buildPriceCard(ThemeData theme, Wish wish, ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      color: theme.colorScheme.tertiaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              child: Icon(Icons.star, color: theme.colorScheme.onTertiary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.estimated_price, style: theme.textTheme.labelLarge),
                Text(
                  '${AppFormatters.moneyCommaStr(wish.price)} ${appState.currentCurrency}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(ThemeData theme, Wish wish) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined, size: 20),
            title:  Text(l10n.wish_created),
            trailing: DateUtil.dayDateTimeText(wish.creationDate, context),
          ),
          ListTile(
            leading: Icon(
              wish.reminder ? Icons.alarm_on : Icons.alarm_off,
              size: 20,
              color: wish.reminder ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            title:  Text(l10n.reminder_status),
            subtitle: Text(wish.reminder ? l10n.notification_active : l10n.notifications_disabled),
            trailing: wish.reminder 
              ? DateUtil.dayDateTimeText(wish.reminderDate, context)
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme, ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleDelete(appState),
                icon: const Icon(Icons.delete_outline),
                label:  Text(l10n.delete),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _handleEdit(appState),
                icon: const Icon(Icons.edit_outlined),
                label:  Text(l10n.edit_wish),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic Handlers ---

  void _handleEdit(ApplicationState appState) async {
    final wish = await _wishFuture;
    await context.push(AppLinks.addWish, extra: wish);
    setState(() => _loadWish());
  }

  

  void _handleDelete(ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => ActionDialogue(
        isDelete: true,
        infoText: l10n.delete_this_wish_from_your_list,
        action: () async {
          await WishService(context: context, appState: appState).deleteWish(wishId: widget.wishId);
          if (mounted) context.pop();
        },
        actionBtnText: l10n.delete,
      ),
    );
  }
}