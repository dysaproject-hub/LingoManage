import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/core/providers/app_users_provider.dart';
import 'package:lingo_manage/core/utils/education_level_enum.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUserController extends AsyncNotifier<AppUser> {
  @override
  Future<AppUser> build() async {
    final currentUser = await ref.watch(authStateProvider.future);

    if (currentUser == null) {
      throw Exception("Silahkan Login Terlebih Dahulu!");
    }

    final repo = ref.read(appUserRepositoryProvider);
    return await repo.getDataUser(uid: currentUser.uid);
  }

  Future<void> updateDataUser({
    String? fullname,
    String? nickname,
    String? phone,
    String? address,
    String? schoolName,
    EducationLevel? educationLevel
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authState = ref.watch(authStateProvider);
      final currentUser = authState.value;
      final repo = ref.read(appUserRepositoryProvider);

      if (currentUser == null) {
        throw Exception("Silahkan Login Terlebih Dahulu!");
      }

      await repo.updateDataUser(
        uid: currentUser.uid,
        fullname: fullname,
        nickname: nickname,
        phone: phone,
        address: address,
        schoolName: schoolName,
        educationLevel: educationLevel,
      );

      return await repo.getDataUser(uid: currentUser.uid);
    });
  }
}

class ImageProfileNotifier extends AsyncNotifier<String?> {
  static const String _profileImageKey = "lingomanage_profile_image_path";

  @override
  Future<String?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_profileImageKey);

    if (savedPath != null && File(savedPath).existsSync()) {
      return savedPath;
    }

    return null;
  }

  Future<void> pickAndSaveImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileImageKey, picked.path);
      state = AsyncData(picked.path);
    }
  }
}
