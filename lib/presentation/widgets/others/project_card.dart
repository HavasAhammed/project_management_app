import 'package:flutter/material.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/domain/models/project_model.dart';
import 'package:project_management_app/core/theme/app_colors.dart';

import 'package:project_management_app/core/theme/app_text_style.dart';
import 'package:project_management_app/core/utils/utils.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  Color _progressColor(double value) {
    if (value < 0.33) return AppColors.primaryRedColor;
    if (value < 0.66) return AppColors.warningColor;
    if (value < 0.85) return Colors.blue;
    return AppColors.successColor;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (project.progress.clamp(0, 100)) / 100.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: EdgeInsets.zero,
        color: AppColors.whiteColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      Utils.capitalizeWords(project.name),
                      style: AppTextStyle.appText16Bold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 3,
                            backgroundColor: AppColors.textHintColor
                                .withOpacity(0.15),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _progressColor(progress),
                            ),
                          ),
                        ),
                        Text(
                          '${project.progress}%',
                          style: AppTextStyle.appText10Bold.copyWith(
                            color: _progressColor(progress),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              kHeight(6),
              Text(
                project.description,
                style: AppTextStyle.appText13Regular.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
