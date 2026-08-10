import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/features/auth/presentation/providers/auth_controller.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("AdminDashboardPage Rebuild");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: IconButton(
                onPressed: () async {
                  return await ref.read(authController.notifier).signOut();
                },
                icon: Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
