import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
class QuickListoptions extends StatelessWidget {
  const QuickListoptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
             Text(
              l10n.select_option,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt),
              title:  Text(l10n.export_pdf),
              subtitle:  Text(l10n.share_list_as_a_document),
              onTap: () {
                Navigator.pop(context,true);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.save_outlined),
              title:  Text(l10n.save),
              subtitle:  Text(l10n.save_as_spending_plan),
              onTap: () {
                 Navigator.pop(context,false);
              },
            ),
          ],
        ),
      ),
    );
  }
}