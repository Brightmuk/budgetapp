import 'package:budgetapp/item_list.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:pdf_viewer_flutter/pdf_viewer_flutter.dart';
import 'dart:io';

class ExportPage extends StatefulWidget {
  final List<Item> items;
  const ExportPage({Key? key, required this.items})
      : super(
          key: key,
        );

  @override
  _ExportPageState createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
        future: PDFService.createPdf('new'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.hasData) {
            File? pdf = snapshot.data;

            return PDFViewerScaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: Container(),
                  toolbarHeight: 120,
                  flexibleSpace: AnimatedContainer(
                    padding: const EdgeInsets.all(15),
                    duration: const Duration(seconds: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(72, 191, 132, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Export',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                  FloatingActionButton.extended(

                    backgroundColor: Color.fromRGBO(72, 191, 132, 1),
                    onPressed: () {
                      
                      PDFService.saveInStorage(
                        'new',
                        snapshot.data!.readAsBytesSync(),
                        context
                      );
                    },
                    icon: const Icon(Icons.done,color: Colors.white,),
                    label: const Text('Finish',style: TextStyle(color: Colors.white),),
                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                path: pdf!.path);
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(72, 191, 132, 1),
              ),
            );
          }
        });
  }
}
