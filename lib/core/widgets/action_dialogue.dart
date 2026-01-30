import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ActionDialogue extends StatelessWidget {
  final bool isDelete;
  final String infoText;
  final Function action;
  final String actionBtnText;
  final Widget? actionWidget;

  const ActionDialogue(
      {Key? key,
      required this.infoText,
      required this.action,
      this.actionWidget,
      this.isDelete = false,
      required this.actionBtnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        
        children: [
          Container(
            width: 80,
            height: 8,
            decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10)),
          ),
          Spacer(flex: 1,),
          Text(
            infoText,
                style: theme.textTheme.bodyLarge,
          ),
           Spacer(flex: 1,),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: OutlinedButton(
                 
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:  Text(
                    l10n.cancel,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: isDelete? theme.colorScheme.error : theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    action();
                  },
                  child: actionWidget ?? Text(
                    actionBtnText,
                  ),
                ),
              ),
          
            ],
          )
        ],
      ),
    );
  }
}
  void showSettingsDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizationsEn();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title:  Text(l10n.notifications_disabled),
            content:  Text(
              l10n.please_enable_notifications_in_settings_to_use_reminders,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:  Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child:  Text(l10n.open_settings),
              ),
            ],
          ),
    );
  }
