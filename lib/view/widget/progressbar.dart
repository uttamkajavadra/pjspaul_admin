import 'package:flutter/material.dart';

class ProgressBar {
  late BuildContext _context;
  static final ProgressBar _progressbar = ProgressBar._internal();

  factory ProgressBar() {
    return _progressbar;
  }

  ProgressBar._internal();

  static ProgressBar get instance => _progressbar;
  bool _isShowing=false;

  void setContext(BuildContext context) {
    _context = context;
  }

  void showProgressbar(BuildContext context) {
    _context = context;
    _isShowing = true;
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
          },
            child: Center(
              child: CircularProgressIndicator(color: Colors.black,),
            ));
      },
    );
  }

  void stopProgressBar(BuildContext context) {
    if (_isShowing) {
      Navigator.pop(context);
      _isShowing = false;
    }
  }
}
