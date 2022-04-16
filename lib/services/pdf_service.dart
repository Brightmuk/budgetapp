import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFService {
  static Future<File> createPdf(String name) async {
    final pdf = pw.Document();
    String dir = (await pp.getTemporaryDirectory()).path;
    File file = File('$dir/$name');

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.SizedBox(
                  width: 200,
                  child: pw.Text('Site construction Budget',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 25)),
                ),
                pw.SizedBox(height: 20),
                pw.Text('21 May 2022', style: pw.TextStyle()),
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
                  pw.TableRow(children: [pw.SizedBox(height: 10)]),
                  pw.TableRow(children: [
                    pw.Text('Water', style: pw.TextStyle()),
                    pw.Text('1', style: pw.TextStyle()),
                    pw.Text('120', style: pw.TextStyle()),
                    pw.Text('120', style: pw.TextStyle()),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 10)]),
                  pw.TableRow(children: [
                    pw.Text('Flour', style: pw.TextStyle()),
                    pw.Text('3', style: pw.TextStyle()),
                    pw.Text('150', style: pw.TextStyle()),
                    pw.Text('450', style: pw.TextStyle()),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 10)]),
                  pw.TableRow(children: [
                    pw.Text('Milk', style: pw.TextStyle()),
                    pw.Text('6', style: pw.TextStyle()),
                    pw.Text('50', style: pw.TextStyle()),
                    pw.Text('300', style: pw.TextStyle()),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 10)]),
                  pw.TableRow(children: [
                    pw.Text('Bread', style: pw.TextStyle()),
                    pw.Text('2', style: pw.TextStyle()),
                    pw.Text('50', style: pw.TextStyle()),
                    pw.Text('100', style: pw.TextStyle()),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 50)]),
                  pw.TableRow(children: [
                    pw.Text('Total',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 15)),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text('ksh.1200',
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
