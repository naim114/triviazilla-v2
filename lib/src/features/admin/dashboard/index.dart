import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/admin/dashboard/user_growth_overall.dart';
import 'package:triviazilla/src/features/admin/dashboard/user_growth_year.dart';

import '../../../model/user_model.dart';
import '../../../services/helpers.dart';
import './user_count_report.dart';

class Dashboard extends StatelessWidget {
  final List<UserModel?> userList;
  final Function(bool refresh) notifyRefresh;

  const Dashboard({
    super.key,
    required this.userList,
    required this.notifyRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColor.neutral2,
          ),
        ),
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListView(
          children: [
            userCountReport(
              totalUsers: userList.length,
              totalUsersBanned: userList
                  .where((user) => user != null && user.disableAt != null)
                  .length,
              totalUsersThisMonth: userList
                  .where((user) =>
                      user != null &&
                      '${user.createdAt.year}-${user.createdAt.month.toString().padLeft(2, '0')}' ==
                          '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}')
                  .length,
              totalUsersThisWeek: userList
                  .where((user) =>
                      user != null &&
                      user.createdAt.isAfter(
                          DateTime.now().subtract(const Duration(days: 7))))
                  .length,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'This Year User Growth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            userGrowthYear(
              janData: getUserByMonth(1),
              febData: getUserByMonth(2),
              marData: getUserByMonth(3),
              aprData: getUserByMonth(4),
              mayData: getUserByMonth(5),
              junData: getUserByMonth(6),
              julData: getUserByMonth(7),
              augData: getUserByMonth(8),
              sepData: getUserByMonth(9),
              octData: getUserByMonth(10),
              novData: getUserByMonth(11),
              disData: getUserByMonth(12),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Overall User Growth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            userGrowthOverall(
              spots: getUsersCountByYear()
                  .entries
                  .map((entry) => FlSpot(entry.key, entry.value.toDouble()))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  double getUserByMonth(double month) {
    return userList
        .where((user) =>
            user != null &&
            user.createdAt.year == DateTime.now().year &&
            user.createdAt.month == month)
        .length
        .toDouble();
  }

  Map<double, int> getUsersCountByYear() {
    Map<double, int> countByYear = {};
    for (UserModel? user in userList) {
      if (user != null) {
        double year = user.createdAt.year.toDouble();
        countByYear[year] = (countByYear[year] ?? 0) + 1;
      }
    }
    return countByYear;
  }
}
