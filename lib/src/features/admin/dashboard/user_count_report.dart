import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../services/helpers.dart';
import '../../../widgets/card/card_icon.dart';

Widget userCountReport({
  required int totalUsers,
  required int totalUsersThisWeek,
  required int totalUsersThisMonth,
  required int totalUsersBanned,
}) =>
    CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: 100,
        initialPage: 0,
      ),
      items: <Widget>[
        cardIcon(
          icon: Icons.people,
          title: totalUsers.toString(),
          subtitle: 'Total Users',
        ),
        cardIcon(
          icon: Icons.person_add,
          title: totalUsersThisWeek.toString(),
          subtitle: 'New Users This Week',
          color: Colors.deepOrange,
        ),
        cardIcon(
          icon: Icons.people_alt,
          title: totalUsersThisMonth.toString(),
          subtitle: 'New Users This Month',
          color: Colors.green,
        ),
        cardIcon(
          icon: Icons.person_off,
          title: totalUsersBanned.toString(),
          subtitle: 'Total Users Banned',
          color: CustomColor.danger,
        ),
      ],
    );
