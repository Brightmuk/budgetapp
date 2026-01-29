import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpenseType extends StatelessWidget {
  const ExpenseType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            Text(
              l10n.select_type,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            
            
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading:  Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.receipt_long_outlined, size: 22, color: Colors.pinkAccent),
              ),
              title: Text(l10n.spending_plan),
              subtitle: Text(l10n.a_plan_to_spend_an_amount_of_money,),
              onTap: () {
                Navigator.pop(context);
                context.push(AppLinks.addSpendingPlan);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withAlpha(100),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.auto_awesome_outlined, size: 22, color: Colors.orangeAccent),
              ),
              title: Text(l10n.wish,),
              subtitle: Text(
                  l10n.something_that_you_plan_to_buy_will_be_added_to_your_wishlist),
              onTap: () {
                Navigator.pop(context);
                context.push(AppLinks.addWish);
                
              },
            ),
          ],
        ),
      ),
    );
  }
}