import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/account/about/index.dart';
import 'package:triviazilla/src/features/account/profile/index.dart';
import 'package:triviazilla/src/features/account/security/index.dart';
import 'package:triviazilla/src/features/admin/index.dart';
import 'package:triviazilla/src/features/admin/settings/index.dart';
import 'package:triviazilla/src/features/news/menu.dart';
import 'package:triviazilla/src/features/record/index.dart';
import 'package:triviazilla/src/services/helpers.dart';
import 'package:triviazilla/src/services/user_services.dart';
import 'package:triviazilla/src/widgets/builder/user_builder.dart';
import 'package:triviazilla/src/widgets/typography/page_title_icon.dart';
import '../../model/user_model.dart';
import '../../services/auth_services.dart';
import '../../widgets/list_tile/list_tile_icon.dart';
import '../../widgets/list_tile/list_tile_profile.dart';

class Account extends StatefulWidget {
  const Account({
    super.key,
    required this.mainContext,
    required this.user,
  });

  final BuildContext mainContext;
  final UserModel? user;

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AuthService _authService = AuthService();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  UserModel? userState;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final UserModel? fetchedData = await UserServices().get(widget.user!.id);

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        userState = fetchedData;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get User:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return widget.user == null
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: FutureBuilder<UserModel?>(
              future: UserServices().get(widget.user!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.data == null) {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshot.data != null) {
                  UserModel user = snapshot.data!;

                  return Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ListView(
                        children: [
                          pageTitleIcon(
                            context: context,
                            title: "Account",
                            icon: const Icon(
                              CupertinoIcons.person_fill,
                              size: 20,
                            ),
                          ),
                          // PROFILE
                          listTileProfile(
                            context: context,
                            onEdit: () {
                              Navigator.of(widget.mainContext).push(
                                MaterialPageRoute(
                                  builder: (context) => Profile(user: user),
                                ),
                              );
                            },
                            user: user,
                          ),
                          // SETTINGS
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Security (Password, Login activity)
                          listTileIcon(
                            context: context,
                            icon: CupertinoIcons.shield_lefthalf_fill,
                            title: "Security",
                            onTap: () => Navigator.of(widget.mainContext).push(
                              MaterialPageRoute(
                                builder: (context) => Security(user: user),
                              ),
                            ),
                          ),
                          // Theme
                          listTileIcon(
                            context: context,
                            icon: isDarkTheme(context)
                                ? CupertinoIcons.moon_fill
                                : CupertinoIcons.sun_max_fill,
                            title: "Theme",
                            onTap: () => selectThemeMode(context),
                          ),
                          // Record
                          listTileIcon(
                            context: context,
                            icon: Icons.list,
                            title: "Record",
                            onTap: () => Navigator.of(widget.mainContext).push(
                              MaterialPageRoute(
                                builder: (context) => RecordList(
                                  user: user,
                                ),
                              ),
                            ),
                          ),
                          // About
                          listTileIcon(
                            context: context,
                            icon: Icons.info_outlined,
                            title: "About",
                            onTap: () => Navigator.of(widget.mainContext).push(
                              MaterialPageRoute(
                                builder: (context) => const AppAbout(),
                              ),
                            ),
                          ),
                          // News
                          listTileIcon(
                            context: context,
                            icon: Icons.newspaper,
                            title: "News",
                            onTap: () => Navigator.of(widget.mainContext).push(
                              MaterialPageRoute(
                                builder: (context) => NewsMenu(user: user),
                              ),
                            ),
                          ),
                          // ADMIN ONLY
                          user.role != null && user.role!.name == "user"
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        'Admin',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Admin Dashboard
                                    listTileIcon(
                                      context: context,
                                      icon: CupertinoIcons.chart_bar_alt_fill,
                                      title: "Dashboard",
                                      onTap: () =>
                                          Navigator.of(widget.mainContext).push(
                                        MaterialPageRoute(
                                          builder: (context) => UsersBuilder(
                                            currentUser: user,
                                            pushTo: 'Dashboard',
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Admin Panel
                                    listTileIcon(
                                      context: context,
                                      icon: Icons.admin_panel_settings,
                                      title: "Admin Panel",
                                      onTap: () =>
                                          Navigator.of(widget.mainContext).push(
                                        MaterialPageRoute(
                                          builder: (context) => AdminPanel(
                                            currentUser: user,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SUPER ADMIN ONLY
                                    user.role != null &&
                                            user.role!.name == "super_admin"
                                        ? listTileIcon(
                                            context: context,
                                            icon: Icons.app_settings_alt,
                                            title: "App Settings",
                                            onTap: () =>
                                                Navigator.of(widget.mainContext)
                                                    .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AppSettings(),
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                          ListTile(
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                  color: Colors.red[400],
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Log Out?'),
                                content: const Text('Select OK to log out.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _authService.signOut(user);
                                    },
                                    child: const Text(
                                      'OK',
                                      style:
                                          TextStyle(color: CustomColor.danger),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              },
            ));
  }
}
