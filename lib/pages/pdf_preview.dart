import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/services/ads/cubit/ads_cubit.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfPreviewScreen extends StatefulWidget {
  final SpendingPlan plan;
  const PdfPreviewScreen({super.key, required this.plan});

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  bool _isWatermarkRemoved = false;


  @override
  Widget build(BuildContext context) {
    final adsCubit = context.read<AdsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview PDF"),
        actions: [
          if (!_isWatermarkRemoved)
            TextButton.icon(
              onPressed: () async {
                bool isRewarded = await adsCubit.showRewardAd();
                if (isRewarded){
                   setState(() {
                  _isWatermarkRemoved = true;
                });
                }
              },
              icon: const Icon(Icons.ad_units, color: Colors.amber),
              label: const Text("Remove Watermark", style: TextStyle(color: Colors.amber)),
            ),
        ],
      ),
      body: PdfPreview(
        build: (format) async {
          final pdfFile = await PDFService.createPdf(
            widget.plan, 
            showWatermark: !_isWatermarkRemoved
          );
          return pdfFile.readAsBytes();
        },
        canDebug: false,
        onShared: (context) {
          final adsCubit = context.read<AdsCubit>();
          adsCubit.showInterstitialAd();

        },
      ),
    );
  }
}
