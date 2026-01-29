import 'package:flutter/material.dart';

class ActionDialogue extends StatelessWidget {
  final String infoText;
  final Function action;
  final String actionBtnText;
  final Widget? actionWidget;

  const ActionDialogue(
      {Key? key,
      required this.infoText,
      required this.action,
      this.actionWidget,
      required this.actionBtnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  child: const Text(
                    'Cancel',
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: actionBtnText == "Delete"? theme.colorScheme.error : theme.colorScheme.primary,
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
