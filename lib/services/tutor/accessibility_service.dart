import '../../models/learner_profile.dart';

class AccessibilityService {
  double getAdjustedFontSize(double baseSize, LearnerProfile profile) {
    return baseSize * profile.fontSizeMultiplier;
  }

  double getAdjustedLineSpacing(LearnerProfile profile) {
    return profile.lineSpacing;
  }

  bool get useReducedMotion(LearnerProfile profile) =>
      profile.prefersReducedMotion;

  bool get useReducedVisuals(LearnerProfile profile) =>
      profile.prefersReducedVisuals;

  bool get useHighContrast(LearnerProfile profile) =>
      profile.prefersHighContrast;
}
