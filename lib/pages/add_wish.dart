import 'package:budgetapp/core/events.dart';
import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/services/ads/cubit/ads_cubit.dart';
import 'package:budgetapp/core/utils/date_util.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class AddWish extends StatefulWidget {
  final Wish? wish;
  const AddWish({Key? key, this.wish}) : super(key: key);

  @override
  _AddWishState createState() => _AddWishState();
}

class _AddWishState extends State<AddWish> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _priceNode = FocusNode();
  
  late DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  bool reminder = false;
  late bool editMode;

  @override
  void initState() {
    super.initState();
    editMode = widget.wish != null;
    if (editMode) {
      reminder = widget.wish!.reminder;
      _selectedDate = widget.wish!.reminderDate;
      _nameC.text = widget.wish!.name;
      _priceC.text = widget.wish!.price.toString();
    }
  }

  @override
  void dispose() {
    // FIX: Cleanup controllers and nodes
    _nameC.dispose();
    _priceC.dispose();
    _nameNode.dispose();
    _priceNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<ApplicationState>(context);
   
    return Scaffold(
      appBar: AppBar(
        title: Text(editMode ? 'Edit Wish' : 'Add New Wish'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            // Form content
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name Field (Takes up remaining space)
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            focusNode: _nameNode,
                            controller: _nameC,
                            decoration: InputDecoration(
                              labelText: 'Item Name',
                              hintText: 'Air Jordans',
                              prefixIcon: const Icon(Icons.shopping_bag_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Price Field
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            focusNode: _priceNode,
                            controller: _priceC,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price',
                              hintText: '300',
                              prefixText: '${_appState.currentCurrency} ',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    // M3 Toggle for Reminders
                    SwitchListTile(
                      secondary: Icon(reminder ? Icons.notifications_active : Icons.notifications_none),
                      title: const Text('Set Reminder'),
                      subtitle: const Text('Get notified to purchase this item'),
                      value: reminder,
                      onChanged: (val) {
                        _nameNode.unfocus();
                        _priceNode.unfocus();
                        _handleReminderChange(val);

                      },
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: reminder ? 1.0 : 0.0,
                      child: reminder
                          ? ListTile(
                              leading: const Icon(Icons.calendar_month_outlined),
                              title: const Text('Target Purchase Date'),
                              trailing: DateUtil(context: context).dayDateTimeText(_selectedDate),
                              onTap: () async {
                                final dateResult = await DateUtil(context: context).getDateAndTime(_selectedDate);
                                if (dateResult != null) {
                                  setState(() => _selectedDate = dateResult);
                                }
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
           Spacer(),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _handleSave,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Save Wish', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    final adsCubit = context.read<AdsCubit>();
    if (_formKey.currentState!.validate()) {
      // Validate Reminder Time
      if (reminder && _selectedDate.isBefore(DateTime.now().add(const Duration(minutes: 5)))) {
        ToastService(context: context).showSuccessToast('Reminder must be at least 5 minutes from now');
        return;
      }

      try {
        String id = editMode ? widget.wish!.id : DateTime.now().millisecondsSinceEpoch.toString();
        Wish wish = Wish(
          id: id,
          price: int.parse(_priceC.text),
          reminderDate: _selectedDate,
          creationDate: DateTime.now(),
          name: _nameC.text,
          reminder: !DateUtil(context: context).isPastDate(_selectedDate) && reminder,
        );

        bool success = await WishService(context: context, appState: appState).saveWish(wish: wish);
        
        if (success) {
          
          final notificationId = int.parse(id.substring(id.length - 8));
          if (wish.reminder) {
            await NotificationService().zonedScheduleNotification(
              id: notificationId,
              payload: NotificationPayload(itemId: id, route: AppLinks.singleWish).toJson(),
              title: 'Wish fulfilment',
              description: 'Don\'t forget your ${wish.name}!',
              scheduling: tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, wish.reminderDate.millisecondsSinceEpoch),
            );
          } else {
            await NotificationService().cancelReminder(notificationId);
          }

          if (mounted) {
        
            adsCubit.showInterstitialAd();
            if (editMode) context.pop();
            context.pop();
            context.push(AppLinks.singleWish, extra: id);
            eventBus.fire(WishCreatedEvent());
          }
        }
      } catch (e) {
        ToastService(context: context).showSuccessToast('Error saving wish');
      }
    }
  }
  Future<void> _handleReminderChange(bool value) async {
  if (value) {
    // 1. Check current status
    PermissionStatus status = await Permission.notification.status;
    if(status.isGranted){
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
        _showSettingsDialog();
      }
    } else if (!status.isGranted) {
      // User tapped "Deny"
      if (mounted) {
        setState(() => reminder = false);
      }
    }
    if(status.isGranted){
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

void _showSettingsDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Notifications Disabled'),
      content: const Text('Please enable notifications in settings to use reminders.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
          child: const Text('Open Settings'),
        ),
      ],
    ),
  );
}
}