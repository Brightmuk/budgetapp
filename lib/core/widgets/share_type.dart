import 'package:flutter/material.dart';
class QuickListoptions extends StatelessWidget {
  const QuickListoptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            const Text(
              'Select option',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt),
              title: const Text('Export PDF'),
              subtitle: const Text('Share list as a document'),
              onTap: () {
                Navigator.pop(context,true);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.save_outlined),
              title: const Text('Save'),
              subtitle: const Text('Save as Spending plan'),
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