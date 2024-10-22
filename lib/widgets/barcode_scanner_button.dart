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
                  // Removed the IconButton that controls the torch
                  actions: [
                    // No torch button added here
                  ],
                );
              },
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
              ),
              onDetect: (BarcodeCapture capture) {
                final String? scannedValue = capture.barcodes.first.rawValue;
                if (scannedValue != null) {
                  Navigator.of(context).pop(scannedValue);
                }
              },
            ),
          ),
        );

        if (result != null) {
          onScan(result); // Call the callback with the scanned value
        }
      },
      child: const Text('Scan Barcode'),
    );
  }
}
