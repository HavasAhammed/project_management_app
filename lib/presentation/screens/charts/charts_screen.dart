import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_management_app/core/constants/height_and_width.dart';
import 'package:project_management_app/domain/repositories/project_repository.dart';
import 'package:project_management_app/presentation/widgets/loader/circular_loading.dart';
import 'package:project_management_app/presentation/widgets/others/stat_box.dart';
import 'package:provider/provider.dart';
import 'package:project_management_app/presentation/widgets/appBar/custom_sub_app_bar.dart';
import 'package:project_management_app/core/theme/app_colors.dart';
import 'package:project_management_app/core/theme/app_text_style.dart';

class ChartsScreen extends StatelessWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projectRepo = context.watch<ProjectRepository>();
    final projects = projectRepo.projects;
    final isLoading = projectRepo.isLoading;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Project Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child:
            isLoading
                ? loader()
                : projects.isEmpty
                ? Center(
                  child: Text(
                    'No projects available',
                    style: AppTextStyle.appText16Medium,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Project Progress',
                          style: AppTextStyle.appText20Bold.copyWith(
                            color: AppColors.primaryBlueColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bar_chart,
                                color: AppColors.primaryBlueColor,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${projects.length} Projects',
                                style: AppTextStyle.appText13Medium.copyWith(
                                  color: AppColors.primaryBlueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    kHeight(20),
                    Row(
                      children: [
                        StatBox(
                          label: 'Avg. Progress',
                          value:
                              projects.isEmpty
                                  ? '0%'
                                  : '${(projects.map((e) => e.progress).reduce((a, b) => a + b) / projects.length).toStringAsFixed(1)}%',
                          color: AppColors.primaryBlueColor,
                        ),
                        kWidth(12),
                        StatBox(
                          label: 'Completed',
                          value:
                              projects.isEmpty
                                  ? '0'
                                  : projects
                                      .where((e) => e.progress >= 100)
                                      .length
                                      .toString(),
                          color: AppColors.secondaryGreenColor,
                        ),
                        kWidth(16),
                        StatBox(
                          label: 'In Progress',
                          value:
                              projects.isEmpty
                                  ? '0'
                                  : projects
                                      .where(
                                        (e) =>
                                            e.progress < 100 && e.progress > 0,
                                      )
                                      .length
                                      .toString(),
                          color: AppColors.primaryRedColor,
                        ),
                      ],
                    ),
                    kHeight(20),
                    SizedBox(
                      height: 220,
                      width: MediaQuery.of(context).size.width - 64,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX:
                              projects.length > 1
                                  ? (projects.length - 1).toDouble()
                                  : 1,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots:
                                  projects
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.progress.toDouble(),
                                        ),
                                      )
                                      .toList(),
                              isCurved: true,
                              color: AppColors.primaryBlueColor,
                              barWidth: 4,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 5,
                                    color: AppColors.primaryRedColor,
                                    strokeWidth: 2,
                                    strokeColor: AppColors.whiteColor,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryBlueColor.withOpacity(0.2),
                                    AppColors.primaryBlueColor.withOpacity(
                                      0.05,
                                    ),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 42,
                                interval: 1,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < projects.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'P${index + 1}',
                                        style: AppTextStyle.appText11Bold
                                            .copyWith(
                                              color:
                                                  AppColors.textBlueGreyColor,
                                            ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 48,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      '${value.toInt()}%',
                                      style: AppTextStyle.appText12Medium
                                          .copyWith(
                                            color: AppColors.textGreyColor,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: AppColors.primaryBlueColor.withOpacity(
                                0.2,
                              ),
                              width: 2,
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 20,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: AppColors.primaryBlueColor.withOpacity(
                                  0.08,
                                ),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return FlLine(
                                color: AppColors.primaryBlueColor.withOpacity(
                                  0.08,
                                ),
                                strokeWidth: 1,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
