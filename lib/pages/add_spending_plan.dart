import 'package:budgetapp/core/colors.dart';
import 'package:budgetapp/core/events.dart';
import 'package:budgetapp/core/widgets/action_dialogue.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/l10n/app_localizations_en.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/ads/cubit/ads_cubit.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/core/utils/date_util.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:budgetapp/core/formatters.dart';

class AddBudgetPlan extends StatefulWidget {
  final SpendingPlan? plan;
  const AddBudgetPlan({Key? key, this.plan}) : super(key: key);

  @override
  _AddBudgetPlanState createState() => _AddBudgetPlanState();
}

class _AddBudgetPlanState extends State<AddBudgetPlan> {
  final TextEditingController _titleC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  DateTime? _selectedDate = DateTime.now().add(const Duration(hours: 1));
  late bool reminder = false;
  bool exportAsPdf = true;
  int total = 0;
  bool expenseError = false;
  bool editMode = false;

  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    editMode = widget.plan != null;
    if (widget.plan != null) {
      _expenses = widget.plan!.expenses;
      total = widget.plan!.total;
      reminder = widget.plan!.reminder;
      _selectedDate = widget.plan!.reminderDate;
      _titleC.text = widget.plan!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationState appState = Provider.of<ApplicationState>(context);
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? l10n.edit_spending_plan : l10n.create_spending_plan),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                focusNode: _focusNode,
                controller: _titleC,
                cursorColor: AppColors.themeColor,
                decoration: InputDecoration(
                  labelText: l10n.title,
                  hintText: l10n.john_s_birthday,
                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (val) {
                  if (val!.isEmpty) {
                    return l10n.title_is_required;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title:  Text(l10n.edit_list),
              subtitle: Text(l10n.expense_s_in_list(_expenses.length.toString())),
              trailing: Text(
                ' ${AppFormatters.moneyCommaStr(total)} ${appState.currentCurrency}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () async {
                _focusNode.unfocus();
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => CreateList(
                          title: _titleC.value.text,
                          expenses: _expenses,
                        ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _expenses = result['expenses'];
                    total = result['total'];
                  });
                }
              },
            ),
            Visibility(
              visible: expenseError,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      l10n.add_at_least_one_expense,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),

            SwitchListTile(
              secondary: Icon(
                reminder
                    ? Icons.notifications_active
                    : Icons.notifications_none,
              ),
              title:  Text(l10n.set_reminder),
              subtitle:  Text(l10n.get_notified_to_purchase_this_item),
              value: reminder,
              onChanged: (val) {
                _focusNode.unfocus();
                _handleReminderChange(val);
              },
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: reminder ? 1.0 : 0.0,
              child:
                  reminder
                      ? ListTile(
                        leading: const Icon(Icons.calendar_month_outlined),
                        title:  Text(l10n.target_purchase_date),
                        trailing: DateUtil.dayDateTimeText(_selectedDate!, context),
                        onTap:
                            reminder
                                ? () async {
                                  _focusNode.unfocus();
                                  final dateResult = await DateUtil.getDateAndTime(_selectedDate!, context);
                                  if (dateResult != null) {
                                    setState(() {
                                      _selectedDate = dateResult;
                                    });
                                  }
                                }
                                : null,
                      )
                      : const SizedBox.shrink(),
            ),
            Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                label:  Text(
                  l10n.save,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  final adsCubit = context.read<AdsCubit>();
                  if (_expenses.isEmpty) {
                    setState(() {
                      expenseError = true;
                    });
                    return;
                  }
                  if (_selectedDate!.millisecondsSinceEpoch <
                          DateTime.now()
                              .add(const Duration(minutes: 5))
                              .millisecondsSinceEpoch &&
                      reminder) {
                    ToastService(context: context).showSuccessToast(
                     l10n.reminders_need_to_be_a_minimum_of_5_minutes_from_now,
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    SpendingPlan plan = SpendingPlan(
                      ///If in edit mode use the items id and not new one
                      id: editMode ? widget.plan!.id : id,
                      total: total,
                      reminderDate: _selectedDate!,
                      creationDate: DateTime.now(),
                      title: _titleC.value.text,
                      reminder:
                          DateUtil.isPastDate(_selectedDate!)
                              ? false
                              : reminder,
                      expenses: _expenses,
                    );
                    try {
                      await BudgetPlanService(
                        context: context,
                        appState: appState,
                      ).saveBudgetPlan(budgetPlan: plan).then((value) async {
                        if (value) {
                          ///only set reminder if user sets so
                          if (plan.reminder &&
                              !DateUtil.isPastDate(_selectedDate!)) {
                            await NotificationService()
                                .zonedScheduleNotification(
                                  id: int.parse(plan.id.substring(8)),
                                  payload:
                                      NotificationPayload(
                                        itemId: plan.id,
                                        route: AppLinks.singleSpendingPlan,
                                      ).toJson(),
                                  title: l10n.spending_list_fulfilment,
                                  description:
                                      l10n.remember_to_fulfil_buddy(plan.title),
                                  scheduling: tz
                                      .TZDateTime.fromMillisecondsSinceEpoch(
                                    tz.local,
                                    plan.reminderDate.millisecondsSinceEpoch,
                                  ),
                                );
                          } else {
                            ///Delete in case they are editing and seting reminder off
                            await NotificationService().cancelReminder(
                              int.parse(plan.id.substring(8)),
                            );
                          }

                          ///If in edit mode pop twice
                          if (editMode) {
                            context.pop();
                          }

                          context.pop();
                          context.push(
                            AppLinks.singleSpendingPlan,
                            extra: editMode ? widget.plan!.id : id,
                          );
                          await Future.delayed(Duration(milliseconds: 300));
                          adsCubit.showInterstitialAd();
                          eventBus.fire(SpendingPlanCreatedEvent());
                        }
                      });
                    } catch (e) {
                      debugPrint(e.toString());
                      ToastService(
                        context: context,
                      ).showSuccessToast(l10n.sorry_there_was_an_error);
                    }
                  }
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _handleReminderChange(bool value) async {
    if (value) {
      // 1. Check current status
      PermissionStatus status = await Permission.notification.status;
      if (status.isGranted) {
        setState(() {
          reminder = true;
        });
        return;
      }
      // 2. If not granted, request it
      if (status.isDenied) {
        status = await Permission.notification.request();
      }

      // 3. Handle the result
      if (status.isPermanentlyDenied) {
        // User tapped "Never ask again" - must go to OS settings
        if (mounted) {
          setState(() => reminder = false);
          showSettingsDialog(context);
        }
      } else if (!status.isGranted) {
        // User tapped "Deny"
        if (mounted) {
          setState(() => reminder = false);
        }
      }
      if (status.isGranted) {
        setState(() {
          reminder = true;
        });
        return;
      }
    } else {
      // If they are turning it OFF, we just let them
      setState(() => reminder = false);
    }
  }


}
