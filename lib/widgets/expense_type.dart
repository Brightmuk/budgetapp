import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseType extends StatelessWidget {
  const ExpenseType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            Text(
              'Select type',
              style: TextStyle(fontSize: 35.sp, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Padding(
                padding: EdgeInsets.only(top: 8.0.sp),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.pinkAccent,
                    ),
                    height: 10,
                    width: 10),
              ),
              title: Text('Spending Plan',style: TextStyle(fontSize: 35.sp),),
              subtitle: Text('A plan to spend an amount of money',style: TextStyle(fontSize: 30.sp),),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) => const AddBudgetPlan());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orangeAccent,
                    ),
                    height: 10,
                    width: 10),
              ),
              title: Text('Wish',style: TextStyle(fontSize: 35.sp),),
              subtitle: Text(
                  'Something that you plan to buy, will be added to your wishlist',style: TextStyle(fontSize: 30.sp),),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) => const AddWish());
              },
            ),
          ],
        ),
      ),
    );
  }
}