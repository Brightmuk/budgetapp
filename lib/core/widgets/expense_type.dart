import 'package:budgetapp/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExpenseType extends StatelessWidget {
  const ExpenseType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            Text(
              'Select type',
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
              title: Text('Spending Plan'),
              subtitle: Text('A plan to spend an amount of money',),
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
              title: Text('Wish',),
              subtitle: Text(
                  'Something that you plan to buy, will be added to your wishlist'),
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