import 'package:budgetapp/core/formatters.dart';
import 'package:budgetapp/core/utils/string_extension.dart';
import 'package:budgetapp/core/widgets/app_item_tile.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SpendingListTab extends StatefulWidget {
  const SpendingListTab({Key? key}) : super(key: key);

  @override
  _SpendingListTabState createState() => _SpendingListTabState();
}

class _SpendingListTabState extends State<SpendingListTab> {
  final ScrollController _controller = ScrollController();

  bool hasItems = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationState _appState = Provider.of<ApplicationState>(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder<List<SpendingPlan>>(
        stream:
            BudgetPlanService(
              context: context,
              appState: _appState,
            ).budgetPlansStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            List<SpendingPlan>? plans = snapshot.data;
            return ListView.separated(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              controller: _controller,
              itemCount: plans!.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 3);
              },
              itemBuilder: (context, index) {
                return SpendingListTile(index: index, plan: plans[index]);
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('No Spending plans yet',style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.outline),),
                  
                  SizedBox(height: 10),
                 TextButton(
                     style: FilledButton.styleFrom(
                        minimumSize: Size(100, 50)
                      ),
                    onPressed: () {
                      context.push(AppLinks.addSpendingPlan);
                    },
                    child: const Text('CREAT ONE'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class SpendingListTile extends StatelessWidget {
  final SpendingPlan plan;
  final int index;
  const SpendingListTile({Key? key, required this.plan, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<ApplicationState>(context);
    final dateStr = DateFormat('EEE dd, yyyy').format(plan.creationDate);

    return AppItemTile(
      title: plan.title.capitalize,
      subtitle: 'Added on $dateStr',
      amount: '${appState.currentCurrency} ${AppFormatters.moneyCommaStr(plan.total)}',
      icon: Icons.receipt_long_outlined,
      iconColor: theme.colorScheme.primary,
      iconBgColor: theme.colorScheme.primaryContainer.withOpacity(0.4),
      useSurfaceVariant: true, // Specific look for plans
      onTap: () => context.push(AppLinks.singleSpendingPlan, extra: plan.id),
    );
  }
}
