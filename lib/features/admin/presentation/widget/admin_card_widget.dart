import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class AdminCardWidget extends StatelessWidget {
  final AppUser admin;

  final bool isOwner;
  final bool isCurrentUser;

  final VoidCallback? onDelete;

  const AdminCardWidget({
    super.key,
    required this.admin,
    required this.isOwner,
    required this.isCurrentUser,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:AppColors.lightText,

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

        leading: CircleAvatar(
          backgroundColor: AppColors.primary,

          child: textBaloo2(
            admin.fullname.isNotEmpty ? admin.fullname[0].toUpperCase() : '?',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.lightText,
          ),
        ),

        title: Row(
          children: [
            Flexible(
              child: textPoppins(admin.fullname, fontWeight: FontWeight.w600),
            ),

            if (isCurrentUser) ...[
              const SizedBox(width: 6),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),

                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Text(
                  'You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),

        subtitle: textPoppins(
          admin.email,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          fontSize: 12,
          color: AppColors.mutedText,
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

              decoration: BoxDecoration(
                color: isOwner ? AppColors.primary : AppColors.accent,

                borderRadius: BorderRadius.circular(20),
              ),

              child: textPoppins(
                isOwner ? 'Owner' : 'Admin',

                fontSize: 11,
                color: Colors.white,
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),

              IconButton(
                tooltip: 'Remove admin',

                onPressed: onDelete,

                icon: const Icon(Icons.delete_outline, size: 21),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
