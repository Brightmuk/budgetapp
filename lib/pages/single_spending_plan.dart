
import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/core/utils/string_extension.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/core/utils/date_util.dart';
import 'package:budgetapp/core/widgets/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class SingleBudgetPlan extends StatefulWidget {
  final String budgetPlanId;
  const SingleBudgetPlan({Key? key, required this.budgetPlanId}) : super(key: key);

  @override
  _SingleBudgetPlanState createState() => _SingleBudgetPlanState();
}

class _SingleBudgetPlanState extends State<SingleBudgetPlan> {
  late Future<SpendingPlan> _planFuture;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  void _loadPlan() {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    _planFuture = BudgetPlanService(context: context, appState: appState)
        .singleBudgetPlan(widget.budgetPlanId);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: FutureBuilder<SpendingPlan>(
        future: _planFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(l10n.error(snapshot.error.toString())));
          }
          if (!snapshot.hasData) {
            return  Center(child: Text(l10n.plan_not_found));
          }

          final plan = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // M3 App Bar with Action Buttons
              SliverAppBar.large(
                title: Text(plan.title.capitalize, style: theme.textTheme.displaySmall,),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.print_outlined),
                    onPressed: () => _handlePrint(plan),
                    tooltip: l10n.print,
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => _handleShare(plan),
                    tooltip: l10n.share,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              
              // Summary & Details Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildSummaryCard(theme, plan, appState),
                      const SizedBox(height: 16),
                      _buildDetailsCard(theme, plan),
                    ],
                  ),
                ),
              ),

              // Expenses List Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
                  child: Text(
                   l10n.expenses,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),

              // Expenses List
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = plan.expenses[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${item.quantity} units × ${appState.currentCurrency} ${item.price}'),
                        trailing: Text(
                          '${appState.currentCurrency} ${AppFormatters.moneyCommaStr(item.quantity * item.price)}',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    childCount: plan.expenses.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      
      // Bottom Action Bar for Edit/Delete
      bottomNavigationBar: _buildBottomActions(theme, appState),
    );
  }

  Widget _buildSummaryCard(ThemeData theme, SpendingPlan plan, ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      color: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Icon(Icons.monetization_on, color: theme.colorScheme.onPrimary),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.total_cost, style: theme.textTheme.labelLarge),
                Text(
                  '${appState.currentCurrency} ${AppFormatters.moneyCommaStr(plan.total)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(ThemeData theme, SpendingPlan plan) {
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
            leading: const Icon(Icons.calendar_today_outlined, size: 20),
            title:  Text(l10n.created),
            trailing: DateUtil.dayDateTimeText(plan.creationDate, context),
          ),
          if (plan.reminder)
            ListTile(
              leading: const Icon(Icons.alarm_on_outlined, size: 20),
              title:  Text(l10n.reminder_set),
              trailing: DateUtil.dayDateTimeText(plan.reminderDate, context),
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
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _handleDelete(appState),
                icon: const Icon(Icons.delete_outline),
                label:  Text(l10n.delete),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _handleEdit(appState),
                icon: const Icon(Icons.edit_outlined),
                label:  Text(l10n.edit_plan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic Handlers ---

Future<void> _handlePrint(SpendingPlan plan) async {
 context.push(AppLinks.pdfPreview, extra: plan);
}

  Future<void> _handleShare(SpendingPlan plan) async {
     context.push(AppLinks.pdfPreview, extra: plan);
  }

  void _handleEdit(ApplicationState appState) async {
    final plan = await snapshotData; 
    await context.push(AppLinks.addSpendingPlan, extra: plan);
    setState(() => _loadPlan());
  }

  void _handleDelete(ApplicationState appState) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => ActionDialogue(
        isDelete: true,
        infoText: l10n.delete_this_spending_plan_permanently,
        action: () async {
          await BudgetPlanService(context: context, appState: appState)
              .deleteBudgetPlan(budgetPlanId: widget.budgetPlanId);
          if (mounted) context.pop();
        },
        actionBtnText: l10n.delete,
      ),
    );
  }

  Future<SpendingPlan> get snapshotData async => await _planFuture;
}