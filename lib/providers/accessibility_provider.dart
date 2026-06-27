import 'package:flutter/material.dart';

class AccessibilityProvider extends ChangeNotifier {
  double _textScale = 1.0;
  double _contrastLevel = 1.0;
  bool _reducedMotion = false;
  bool _focusMode = false;
  bool _showFocusOverlay = false;

  double get textScale => _textScale;
  double get contrastLevel => _contrastLevel;
  bool get reducedMotion => _reducedMotion;
  bool get focusMode => _focusMode;
  bool get showFocusOverlay => _showFocusOverlay;

  void setTextScale(double scale) {
    _textScale = scale.clamp(0.8, 1.8);
    notifyListeners();
  }

  void increaseTextSize() {
    _textScale = (_textScale + 0.1).clamp(0.8, 1.8);
    notifyListeners();
  }

  void decreaseTextSize() {
    _textScale = (_textScale - 0.1).clamp(0.8, 1.8);
    notifyListeners();
  }

  void setContrastLevel(double level) {
    _contrastLevel = level.clamp(0.8, 2.0);
    notifyListeners();
  }

  void toggleReducedMotion() {
    _reducedMotion = !_reducedMotion;
    notifyListeners();
  }

  void toggleFocusMode() {
    _focusMode = !_focusMode;
    _showFocusOverlay = _focusMode;
    notifyListeners();
  }

  void dismissFocusOverlay() {
    _showFocusOverlay = false;
    notifyListeners();
  }

  void resetAll() {
    _textScale = 1.0;
    _contrastLevel = 1.0;
    _reducedMotion = false;
    _focusMode = false;
    _showFocusOverlay = false;
    notifyListeners();
  }
}
