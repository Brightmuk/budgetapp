import 'dart:io';
import 'dart:typed_data';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFService {
  
  ///Create a pdf from for sharing or printing
  static Future<File> createPdf(SpendingPlan plan) async {
     final DateFormat dayDate = DateFormat('EEE dd, yyy');
    final pdf = pw.Document();
    String dir = (await pp.getTemporaryDirectory()).path;
    File file = File('$dir/${plan.title}');

final logo = await imageFromAssetBundle('assets/images/logo_alt.png');

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(children: [
                  pw.Image(logo,height: 50),
                ]),
                pw.SizedBox(height: 10,),
                
                pw.SizedBox(
                  width: 200,
                  height: 50,
                  child: pw.Text(plan.title,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 25)),
                ),
                pw.SizedBox(height: 20),
                pw.Text(dayDate.format( plan.creationDate), style: pw.TextStyle()),
                pw.SizedBox(height: 30),
                pw.Table(tableWidth: pw.TableWidth.max, children: [
                  pw.TableRow(children: [
                    pw.Text('Item Name',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Quantity',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Unit Price',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Subtotal',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 20)]),

                  for(var el in plan.expenses)
                  
                  pw.TableRow(
                   
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Text(el.name),),
                    
                    pw.Text(el.quantity.toString()),
                    pw.Text(el.price.toString()),
                    pw.Text((el.price*el.quantity).toString()),
                  ]),

                  pw.TableRow(children: [pw.SizedBox(height: 50)]),
                  pw.TableRow(children: [
                    pw.Text('Total',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 15)),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text('ksh.${plan.total}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 15)),
                  ]),
                ]),
                pw.SizedBox(height: 50),
                pw.Footer(
                    title: pw.Text(
                        'Made by Budget Buddy | BrightDesigns. All rights reserved',
                        style: const pw.TextStyle(color: PdfColors.grey300))),
              ]);
        }));

    return await file.writeAsBytes(await pdf.save());
  }

  static Future saveInStorage(String fileName, Uint8List file, BuildContext context) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
            ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Okay')));
      final directory = (await pp.getExternalStorageDirectories(
          type: pp.StorageDirectory.documents));

      File path = File("${directory?.first.path}/$fileName");
      path.writeAsBytes(file);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Issue')));
      await Permission.manageExternalStorage.request();
    }
  }
}
