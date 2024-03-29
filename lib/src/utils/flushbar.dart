import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

bool _showError = true;

void _switchShowError() {
  _showError = false;
  Future.delayed(Duration(milliseconds: 5000), () {
    _showError = true;
  });
}

Size getWidgetSize(GlobalKey key) {
  final RenderBox renderBox = key.currentContext?.findRenderObject();
  return renderBox?.size;
}

Flushbar showSuccessToast(BuildContext context, String title, String message) {
  if (!_showError) {
    return null;
  } else {
    _switchShowError();
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.check,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 4),
      backgroundGradient: LinearGradient(
        colors: [Colors.green[600], Colors.green[400]],
      ),
      onTap: (flushbar) => flushbar.dismiss(),
    )..show(context);
  }
}

Flushbar showErrorToast(BuildContext context, String title, String message) {
  if (!_showError) {
    return null;
  } else {
    _switchShowError();
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.error,
        size: 28.0,
        color: Colors.white,
      ),
      duration: const Duration(seconds: 4),
      backgroundGradient: LinearGradient(
        colors: [Colors.red[600], Colors.red[400]],
      ),
      onTap: (flushbar) => flushbar.dismiss(),
    )..show(context);
  }
}
