import 'package:flutter/material.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';

class BarcodeScannerButton extends StatelessWidget {
  final Function(String) onScan;

  const BarcodeScannerButton({super.key, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AiBarcodeScanner(
              hideGalleryButton: true,
              sheetTitle: "Place the barcode in the frame to scan",
              appBarBuilder: (context, controller) {
                return AppBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: controller.torchEnabled
                          ? const Icon(Icons.flashlight_off_rounded)
                          : const Icon(Icons.flashlight_on_rounded),
                      onPressed: controller.toggleTorch,
                    ),
                  ],
                );
              },
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
              ),
              onDetect: (BarcodeCapture capture) async {
                final String? scannedValue = capture.barcodes.first.rawValue;
                if (scannedValue != null && context.mounted) {
                  Navigator.of(context).pop(scannedValue);
                }
              },
            ),
          ),
        );

        if (result != null) {
          onScan(result);
        }
      },
      child: const Text('Scan Barcode'),
    );
  }
}
