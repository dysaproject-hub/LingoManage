import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/routes/routes.dart';

class StudentHomePage extends ConsumerStatefulWidget {
  const StudentHomePage({super.key});

  @override
  ConsumerState<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends ConsumerState<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("StudentHomePage Rebuild");
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Center(
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.profileUser);
                },
                icon: Icon(Icons.person),
              ),
            ),
          ],
        ),
      ),
    );
  }
}