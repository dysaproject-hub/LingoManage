import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AdminSearchResult
    extends StatelessWidget {
  final AppUser admin;
  final bool isLoading;
  final VoidCallback onAdd;

  const AdminSearchResult({
    super.key,
    required this.admin,
    required this.isLoading,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor:
                  AppColors.primary,

              child: Text(
                admin.fullname.isNotEmpty
                    ? admin.fullname[0]
                        .toUpperCase()
                    : '?',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  textPoppins(
                    admin.fullname,
                    fontWeight:
                        FontWeight.w600,
                  ),

                  const SizedBox(height: 2),

                  textPoppins(
                    admin.email,
                    fontSize: 12,
                    color:
                        AppColors.mutedText,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            ElevatedButton(
              onPressed:
                  isLoading ? null : onAdd,

              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Add',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}