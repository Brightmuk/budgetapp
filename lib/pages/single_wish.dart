import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/date_services.dart';
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

    return Scaffold(
      body: FutureBuilder<Wish>(
        future: _wishFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Wish not found'));
          }

          final wish = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // M3 Large App Bar
              SliverAppBar.large(
                title: Text(wish.name),
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
                Text('Estimated Price', style: theme.textTheme.labelLarge),
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
            title: const Text('Wish Created'),
            trailing: DateServices(context: context).dayDateTimeText(wish.creationDate),
          ),
          ListTile(
            leading: Icon(
              wish.reminder ? Icons.alarm_on : Icons.alarm_off,
              size: 20,
              color: wish.reminder ? theme.colorScheme.primary : theme.colorScheme.outline,
            ),
            title: const Text('Reminder Status'),
            subtitle: Text(wish.reminder ? 'Notification active' : 'Notifications disabled'),
            trailing: wish.reminder 
              ? DateServices(context: context).dayDateTimeText(wish.reminderDate)
              : null,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme, ApplicationState appState) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _handleDelete(appState),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
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
                label: const Text('Edit Wish'),
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
    showModalBottomSheet(
      context: context,
      builder: (context) => ActionDialogue(
        infoText: 'Delete this wish from your list?',
        action: () async {
          await WishService(context: context, appState: appState).deleteWish(wishId: widget.wishId);
          if (mounted) context.pop();
        },
        actionBtnText: 'Delete',
      ),
    );
  }
}