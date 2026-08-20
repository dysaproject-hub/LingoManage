import 'package:flutter/material.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/features/course/models/course_program_model.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class ProgramCard extends StatelessWidget {
  final CourseProgramModel program;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProgramCard({
    super.key,
    required this.program,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.lightText,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.mutedText.withValues(alpha: 0.15)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: AppColors.accent,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textPoppins(
                          program.name,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),

                        const SizedBox(height: 4),

                        textPoppins(
                          program.description ?? '-',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mutedText,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit?.call();
                      }

                      if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _ProgramInfo(
                      icon: Icons.payments_outlined,
                      label: 'RegistrationFee',
                      value: 'Rp ${program.registrationFee}',
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _ProgramInfo(
                      icon: Icons.payments_outlined,
                      label: 'MonthlyFee',
                      value: 'Rp ${program.monthlyFee}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: textPoppins(
                    'View Program',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProgramInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.mutedText.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.accent),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textPoppins(label, fontSize: 10, color: AppColors.mutedText),

                const SizedBox(height: 2),

                textPoppins(
                  value,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
