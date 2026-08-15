import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_manage/core/constants/app_colors.dart';
import 'package:lingo_manage/core/models/app_users.dart';
import 'package:lingo_manage/features/admin/presentation/providers/admin_course_provider.dart';
import 'package:lingo_manage/features/admin/presentation/widget/admin_card_widget.dart';
import 'package:lingo_manage/features/admin/presentation/widget/admin_search_result_widget.dart';
import 'package:lingo_manage/features/course/models/course_model.dart';
import 'package:lingo_manage/shared/widgets/loading_widget.dart';
import 'package:lingo_manage/shared/widgets/popup_widget.dart';
import 'package:lingo_manage/shared/widgets/text_field_widget.dart';
import 'package:lingo_manage/shared/widgets/text_widget.dart';

class ManageAdminPage extends ConsumerStatefulWidget {
  final CourseModel courseModel;

  const ManageAdminPage({super.key, required this.courseModel});

  @override
  ConsumerState<ManageAdminPage> createState() => _ManageAdminPageState();
}

class _ManageAdminPageState extends ConsumerState<ManageAdminPage> {
  final _emailController = TextEditingController();

  AppUser? _foundAdmin;

  bool _isSearching = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  bool get isCurrentUserOwner {
    return currentUserId != null && currentUserId == widget.courseModel.ownerId;
  }

  Future<void> _searchAdmin() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter the email first')));

      return;
    }

    if (!isCurrentUserOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Just owner who can add the admin')),
      );

      return;
    }

    setState(() {
      _isSearching = true;
      _foundAdmin = null;
    });

    final admin = await ref
        .read(adminCourseControllerProvider.notifier)
        .findAdminByEmail(email);

    if (!mounted) return;

    setState(() {
      _isSearching = false;
      _foundAdmin = admin;
    });

    if (admin == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Admin not found.')));

      return;
    }

    if (admin.uid == currentUserId) {
      setState(() {
        _foundAdmin = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already be an owner in this course')),
      );

      return;
    }
  }

  Future<void> _addAdmin() async {
    final admin = _foundAdmin;

    if (admin == null) return;

    if (!isCurrentUserOwner) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Just owner who can add the admin')),
      );

      return;
    }

    await ref
        .read(adminCourseControllerProvider.notifier)
        .addAdminToCourse(courseId: widget.courseModel.id, adminId: admin.uid);

    if (!mounted) return;

    final state = ref.read(adminCourseControllerProvider);

    if (state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error.toString())));

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Admin added in this course successfully')),
    );

    setState(() {
      _foundAdmin = null;
      _emailController.clear();
    });

    ref.invalidate(courseAdminsProvider(widget.courseModel.id));
  }

  Future<void> _deleteAdmin(AppUser admin) async {
    await ref
        .read(adminCourseControllerProvider.notifier)
        .removeAdminFromCourse(
          courseId: widget.courseModel.id,
          adminId: admin.uid,
        );

    if (!mounted) return;

    final state = ref.read(adminCourseControllerProvider);

    if (state.hasError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.error.toString())));

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${admin.fullname} removed from this course')),
    );

    ref.invalidate(courseAdminsProvider(widget.courseModel.id));
  }

  Widget _buildAdminCard({
    required AppUser admin,
    required bool isCurrentUser,
    required bool isOwner,
    required BuildContext context
  }) {
    return AdminCardWidget(
      admin: admin,
      isOwner: isOwner,
      isCurrentUser: isCurrentUser,

      onDelete: isCurrentUserOwner && !isOwner
          ? () => PopupWidget.removeAdminCourse(context, admin, () async {
              await _deleteAdmin(admin);

              if (!context.mounted) return;
              Navigator.pop(context);
            })
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final adminsAsync = ref.watch(courseAdminsProvider(widget.courseModel.id));

    final controllerState = ref.watch(adminCourseControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.lightText,
      appBar: AppBar(
        backgroundColor: AppColors.lightText,
        title: textPoppins(
          'Manage Admin',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textBaloo2(
              widget.courseModel.name,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),

            const SizedBox(height: 4),

            textPoppins(
              'Manage users who have access to this course.',
              fontSize: 13,
              color: AppColors.mutedText,
            ),

            const SizedBox(height: 24),

            textBaloo2(
              'Course Admins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),

            const SizedBox(height: 12),

            Expanded(
              child: adminsAsync.when(
                loading: () {
                  return const Center(child: LoadingWidget());
                },

                error: (error, stack) {
                  debugPrint('Get course admins error: $error');

                  return Center(child: textPoppins('Failed to load admins.'));
                },

                data: (admins) {
                  if (admins.isEmpty) {
                    return Center(child: textPoppins('No admins found.'));
                  }

                  final currentId = currentUserId;

                  final currentUserAdmins = admins
                      .where((admin) => admin.uid == currentId)
                      .toList();

                  final otherAdmins = admins
                      .where((admin) => admin.uid != currentId)
                      .toList();

                  return ListView(
                    children: [
                      if (currentUserAdmins.isNotEmpty) ...[
                        textPoppins(
                          'You',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedText,
                        ),

                        const SizedBox(height: 8),

                        _buildAdminCard(
                          admin: currentUserAdmins.first,
                          isCurrentUser: true,
                          isOwner:
                              currentUserAdmins.first.uid ==
                              widget.courseModel.ownerId,
                          context: context
                        ),
                      ],

                      if (currentUserAdmins.isNotEmpty &&
                          otherAdmins.isNotEmpty)
                        const SizedBox(height: 24),

                      if (otherAdmins.isNotEmpty) ...[
                        textPoppins(
                          'Other Admins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mutedText,
                        ),

                        const SizedBox(height: 8),

                        ...otherAdmins.map((admin) {
                          final isOwner =
                              admin.uid == widget.courseModel.ownerId;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildAdminCard(
                              admin: admin,
                              isCurrentUser: false,
                              isOwner: isOwner,
                              context: context
                            ),
                          );
                        }),
                      ],
                    ],
                  );
                },
              ),
            ),

            if (isCurrentUserOwner) ...[
              const SizedBox(height: 16),

              textBaloo2(
                'Add Admin',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: textFieldWidget(
                      labelText: 'Admin email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: _isSearching ? null : _searchAdmin,
                    icon: _isSearching
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.search),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_foundAdmin != null)
                AdminSearchResult(
                  admin: _foundAdmin!,
                  isLoading: controllerState.isLoading,
                  onAdd: _addAdmin,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
