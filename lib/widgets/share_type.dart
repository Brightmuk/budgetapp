import 'package:flutter/material.dart';

class ShareType extends StatelessWidget {
  const ShareType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            const Text(
              'Select share type',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.receipt),
              title: const Text('PDF'),
              subtitle: const Text('Share list as a document'),
              onTap: () {
                Navigator.pop(context,true);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.image_outlined),
              title: const Text('Image'),
              subtitle: const Text('Share  list as an image'),
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