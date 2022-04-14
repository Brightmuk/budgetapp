import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

createPdf(){
final pdf = pw.Document();

pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.SizedBox(
              width: 200,
              child: pw.Text('Site construction Budget',style:pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 25)),),
              pw.SizedBox(height: 20),
              pw.Text('21 May 2022',style: pw.TextStyle()),
              pw.SizedBox(height: 20),

              pw.Table(
                border: const pw.TableBorder(horizontalInside: pw.BorderSide(width: 0.5)),
                children: [
                  
                  pw.TableRow(children: [
                      pw.Text('Item Name',style:pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Quantity',style:pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Unit Price',style:pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Subtotal',style:pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ])
              ]),
            

            pw.Row(children: [

            ])
          ]
        ); // Center
      }));
       // Page
}