import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/routes/router.dart';
import 'package:lingo_manage/features/auth/presentation/screens/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_INITIALIZE_URL', fallback: ''),
    publishableKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY', fallback: ''),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.primary,
          selectionColor: AppColors.primary.withValues(alpha: 0.3),
          selectionHandleColor: AppColors.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      onGenerateRoute: AppRouter.generate,
    );
  }
}
