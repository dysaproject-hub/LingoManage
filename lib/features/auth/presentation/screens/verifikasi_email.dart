import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/shared/widgets/text/text_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;

  const EmailVerificationPage({
    super.key,
    required this.email,
  });

  @override
  State<EmailVerificationPage> createState() =>
      _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _timer;

  int _remainingSeconds = 0;

  bool get _canResend => _remainingSeconds == 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 60;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_remainingSeconds <= 1) {
          timer.cancel();

          if (!mounted) return;

          setState(() {
            _remainingSeconds = 0;
          });

          return;
        }

        if (!mounted) return;

        setState(() {
          _remainingSeconds--;
        });
      },
    );
  }

  Future<void> _resendVerificationEmail() async {
    if (!_canResend) return;

    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );

      if (!mounted) return;

      _startCooldown();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textPoppins(
            'Email verifikasi berhasil dikirim ulang.', color: AppColors.lightText,
          ),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textPoppins(e.message, color: AppColors.lightText),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: textPoppins(
            'Terjadi kesalahan. Silakan coba lagi.',
            color: AppColors.lightText
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: textBaloo2('Verifikasi Email', fontSize: 24, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: Colors.teal,
                ),
        
                const SizedBox(height: 32),
        
                textBaloo2(
                  'Verifikasi Email Kamu',
                  textAlign: TextAlign.center,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
        
                const SizedBox(height: 16),
        
                textPoppins(
                  'Kami telah mengirimkan link verifikasi '
                  'ke alamat email:',
                  textAlign: TextAlign.center,
                ),
        
                const SizedBox(height: 8),
        
                textPoppins(
                  widget.email,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold
                ),
        
                const SizedBox(height: 16),
        
                textPoppins(
                  'Silakan buka email tersebut dan klik '
                  'link verifikasi untuk mengaktifkan akun kamu.',
                  textAlign: TextAlign.center,
                ),
        
                const SizedBox(height: 32),
        
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _canResend
                        ? _resendVerificationEmail
                        : null,
                    child: textPoppins(
                      _canResend
                          ? 'Kirim Ulang Email'
                          : 'Kirim ulang dalam $_remainingSeconds detik',
                    ),
                  ),
                ),
        
                const SizedBox(height: 12),
        
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: textPoppins('Kembali'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}