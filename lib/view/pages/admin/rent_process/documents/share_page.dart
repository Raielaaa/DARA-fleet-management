import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ShareUtils {
  static Future<void> captureAndShare(GlobalKey repaintKey, BuildContext context) async {
    try {
      // Safely get the RenderRepaintBoundary
      final RenderRepaintBoundary? boundary =
      repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        print('RenderRepaintBoundary is null');
        return;
      }

      // Capture the screenshot
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        _showShareOptions(context, pngBytes);
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }

  static void _showShareOptions(BuildContext context, Uint8List pngBytes) {
    Share.shareXFiles([
      XFile.fromData(pngBytes, mimeType: 'image/png', name: 'screenshot.png')
    ]);
  }

  static Future<void> _shareScreenshot(Uint8List pngBytes) async {
    await Share.shareXFiles(
      [
        XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'screenshot.png',
        ),
      ],
      text: 'Check out this page!',
    );
  }
}