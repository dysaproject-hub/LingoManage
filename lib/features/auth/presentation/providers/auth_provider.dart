import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/auth/data/datasources/auth_datasources.dart';
import 'package:lingo_manage/features/auth/data/repository/auth_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final authDatasourcesProvider = Provider<AuthDatasources>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final db = ref.watch(firebaseFirestoreProvider);
  return AuthDatasources(db, auth);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authDataSources = ref.watch(authDatasourcesProvider);
  return AuthRepository(authDataSources);
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  return auth.authStateChanges().asyncMap((firebaseUser) async {
    // Belum login
    if (firebaseUser == null) return null;

    // Sudah login → ambil data lengkap dari Firestore
    final doc = await db.collection('users').doc(firebaseUser.uid).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return AppUser.fromMap(firebaseUser.uid, doc.data()!);
  });
});