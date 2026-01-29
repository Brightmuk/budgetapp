import 'dart:io';
import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/date_services.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/core/widgets/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
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

    return Scaffold(
      body: FutureBuilder<SpendingPlan>(
        future: _planFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Plan not found'));
          }

          final plan = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // M3 App Bar with Action Buttons
              SliverAppBar.large(
                title: Text(plan.title),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.print_outlined),
                    onPressed: () => _handlePrint(plan),
                    tooltip: 'Print',
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => _handleShare(plan),
                    tooltip: 'Share',
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
                    'Expenses',
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
                        subtitle: Text('${item.quantity} units × ${item.price} ${appState.currentCurrency}'),
                        trailing: Text(
                          '${AppFormatters.moneyCommaStr(item.quantity * item.price)} ${appState.currentCurrency}',
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
                Text('Total Spent', style: theme.textTheme.labelLarge),
                Text(
                  '${AppFormatters.moneyCommaStr(plan.total)} ${appState.currentCurrency}',
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
            title: const Text('Created'),
            trailing: DateServices(context: context).dayDateTimeText(plan.creationDate),
          ),
          if (plan.reminder)
            ListTile(
              leading: const Icon(Icons.alarm_on_outlined, size: 20),
              title: const Text('Reminder Set'),
              trailing: DateServices(context: context).dayDateTimeText(plan.reminderDate),
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
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _handleDelete(appState),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
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
                label: const Text('Edit Plan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Logic Handlers ---

  Future<void> _handlePrint(SpendingPlan plan) async {
    File pdf = await PDFService.createPdf(plan);
    await Printing.layoutPdf(name: '${plan.title}.pdf', onLayout: (_) => pdf.readAsBytes());
  }

  Future<void> _handleShare(SpendingPlan plan) async {
    File pdf = await PDFService.createPdf(plan);
    await Printing.sharePdf(bytes: pdf.readAsBytesSync(), filename: '${plan.title}.pdf');
  }

  void _handleEdit(ApplicationState appState) async {
    final plan = await snapshotData; 
    await context.push(AppLinks.addSpendingPlan, extra: plan);
    setState(() => _loadPlan());
  }

  void _handleDelete(ApplicationState appState) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ActionDialogue(
        infoText: 'Delete this Spending plan permanently?',
        action: () async {
          await BudgetPlanService(context: context, appState: appState)
              .deleteBudgetPlan(budgetPlanId: widget.budgetPlanId);
          if (mounted) context.pop();
        },
        actionBtnText: 'Delete',
      ),
    );
  }

  Future<SpendingPlan> get snapshotData async => await _planFuture;
}