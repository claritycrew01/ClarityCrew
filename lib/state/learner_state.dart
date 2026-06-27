import 'package:flutter/foundation.dart';
import '../models/learner_profile.dart';
import '../persistence/local_storage_repository.dart';

class LearnerState extends ChangeNotifier {
  LearnerState(this._repository);

  final LocalStorageRepository _repository;

  LearnerProfile? _profile;

  LearnerProfile? get profile => _profile;
  bool get isLoaded => _profile != null;
  bool get isNewUser => _profile?.isNewUser ?? true;

  Future<void> loadProfile() async {
    _profile = _repository.loadProfile();
    if (_profile == null) {
      _profile = LearnerProfile(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      await _repository.saveProfile(_profile!);
    }
    notifyListeners();
  }

  Future<void> updateProfile(LearnerProfile updated) async {
    _profile = updated;
    await _repository.saveProfile(updated);
    notifyListeners();
  }

  Future<void> completeOnboarding(String name) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      name: name,
      isNewUser: false,
      lastUpdated: DateTime.now(),
    );
    await _repository.saveProfile(_profile!);
    notifyListeners();
  }

  Future<void> updateAccessibility({
    bool? prefersReducedMotion,
    bool? prefersReducedVisuals,
    bool? prefersHighContrast,
    double? lineSpacing,
    double? fontSizeMultiplier,
  }) async {
    if (_profile == null) return;
    _profile = _profile!.copyWith(
      prefersReducedMotion: prefersReducedMotion,
      prefersReducedVisuals: prefersReducedVisuals,
      prefersHighContrast: prefersHighContrast,
      lineSpacing: lineSpacing,
      fontSizeMultiplier: fontSizeMultiplier,
      lastUpdated: DateTime.now(),
    );
    await _repository.saveProfile(_profile!);
    notifyListeners();
  }
}
