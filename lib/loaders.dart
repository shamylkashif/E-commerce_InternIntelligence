import 'package:flutter/material.dart';

class SnackbarHelper {
  static void show(BuildContext context, String message, {Color backgroundColor = Colors.red, bool isError = true}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,  // Adjust the top position as needed
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Text(message, style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
