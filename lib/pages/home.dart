import 'dart:async';
import 'package:budgetapp/core/events.dart';
import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/spending_list_tab.dart';
import 'package:budgetapp/pages/wishlist_tab.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/core/widgets/expense_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final DateFormat dayDate = DateFormat('EEE dd, MMM yyyy');
  StreamSubscription? _wishCreationSub;
  StreamSubscription? _planCreationSub;

  final List<Widget> _tabs = [const SpendingListTab(), const WishListTab()];

  String _calculateTotal(dynamic items) {
    int total = 0;
    for (var item in items) {
      if (item is SpendingPlan) total += item.total;
      if (item is Wish) total += item.price;
    }
    return AppFormatters.moneyStr(total);
  }

  void _openNewItemSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => const ExpenseType(),
    );
  }

  @override
  void initState() {
    super.initState();
    _wishCreationSub = eventBus.on<WishCreatedEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _currentIndex = 1;
        });
      }
    });
    _planCreationSub = eventBus.on<SpendingPlanCreatedEvent>().listen((event) {
      if (mounted) {
        setState(() {
          _currentIndex = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    _wishCreationSub?.cancel();
    _planCreationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // M3 App Bar: Clean and Simple
      appBar: AppBar(
        // 1. Standard M3 Title & Actions
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spenditize',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              dayDate.format(DateTime.now()).toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.0,
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push(AppLinks.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],

        // 2. The Integrated Totals Section
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100), // Height for the stats row
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatTile(
                    l10n.spending_plans,
                    BudgetPlanService(appState: appState).budgetPlansStream,
                    theme.colorScheme.primary,
                    appState,
                    Icons.receipt_long_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatTile(
                    l10n.wishlist,
                    WishService(appState: appState).wishStream,
                    theme.colorScheme.tertiary,
                    appState,
                    Icons.favorite_outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Tab Content
          Expanded(
            child:  _tabs[_currentIndex]
          ),
        ],
      ),

      // M3 Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: l10n.plans,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: l10n.wishlist,
          ),
        ],
      ),

      // FAB Layout
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'QuickList',
            onPressed: () => context.push(AppLinks.createList),
            child: const Icon(Icons.bolt),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'NewItem',
            onPressed: _openNewItemSheet,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(
    String label,
    Stream stream,
    Color color,
    ApplicationState appState,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        final total = snapshot.hasData ? _calculateTotal(snapshot.data) : '0';

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    total,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
