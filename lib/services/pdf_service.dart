import 'dart:io';
import 'package:budgetapp/core/utils/string_extension.dart';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:budgetapp/core/formatters.dart';
import 'package:provider/provider.dart';


class PDFService {
  ///Create a pdf from for sharing or printing
  static Future<File> createPdf(SpendingPlan plan, {bool showWatermark = true, required BuildContext ctx}) async {
    final DateFormat dayDate = DateFormat('EEE dd, yyy');
    final pdf = pw.Document();
    String dir = (await pp.getTemporaryDirectory()).path;
    File file = File('$dir/${plan.title}');
    final appState = Provider.of<ApplicationState>(ctx, listen: false);
    String? currency = appState.currentCurrency;
    

    final logo = await imageFromAssetBundle('assets/icons/icon-black.png');
    final waterMark = await imageFromAssetBundle('assets/icons/icon-watermark.png');
    pw.Widget buildTiledWatermark() {
      return pw.Opacity(
        opacity: 0.7, // Keep it subtle so the text is readable
        child: pw.Container(
          alignment: pw.Alignment.center,
          child: pw.Wrap(
            spacing: 40, // Horizontal space between watermarks
            runSpacing: 40, // Vertical space between rows
            children: List.generate(30, (index) {
              return pw.Transform.rotate(
                angle: -0.4, // Slight tilt for that professional "security" look
                child: pw.Image(waterMark, height: 60), // Small and repeating
              );
            }),
          ),
        ),
      );
    }
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        
        build: (pw.Context context) {
          final l10n = AppLocalizations.of(ctx)!;

          return pw.Stack(
            alignment: pw.Alignment.center,
            children: [
              
              if (showWatermark) buildTiledWatermark(),
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
               showWatermark? pw.Row(children: [
                  pw.Image(logo, height: 50),
                ]):pw.SizedBox(height: 0),
                pw.SizedBox(
                  height: 10,
                ),
                pw.SizedBox(
                  width: 200,
                  height: 50,
                  child: pw.Text(plan.title,
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 25)),
                ),
                pw.SizedBox(height: 20),
                pw.Text(dayDate.format(plan.creationDate),
                    style: pw.TextStyle()),
                pw.SizedBox(height: 30),
                pw.Table(tableWidth: pw.TableWidth.max, children: [
                  pw.TableRow(children: [
                    pw.Text(l10n.item_name,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(l10n.quantity,
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(l10n.unit_price_currency(currency??''),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(l10n.subtotal_currency(currency??''),
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ]),
                  pw.TableRow(children: [pw.SizedBox(height: 20)]),
                  for (var el in plan.expenses)
                    pw.TableRow(children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Text(el.name.sentenceCase()),
                      ),
                      pw.Text(el.quantity.toString()),
                      pw.Text(AppFormatters.moneyCommaStr(el.price)),
                      pw.Text(AppFormatters.moneyCommaStr(el.price * el.quantity)),
                    ]),
                  pw.TableRow(children: [pw.SizedBox(height: 50)]),

                  // const pw.TableRow(decoration: pw.BoxDecoration(border: pw.Border.fromBorderSide(pw.BorderSide(color: PdfColors.grey500))), children: []),
                  pw.TableRow(children: [
                    pw.Text(l10n.total,
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14)),
                    pw.Text(''),
                    pw.Text(''),
                    pw.Text('$currency ${AppFormatters.moneyCommaStr(plan.total)} ',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 14)),
                  ]),
                ]),

              ])]);
              
        }));

    return await file.writeAsBytes(await pdf.save());
  }

}
