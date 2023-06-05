import 'package:flutter/material.dart';
import 'package:triviazilla/src/features/admin/trivia/index.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:triviazilla/src/services/trivia_services.dart';

import '../../model/user_model.dart';

class TriviaBuilder extends StatefulWidget {
  const TriviaBuilder({
    super.key,
    required this.currentUser,
    required this.pushTo,
  });
  final UserModel currentUser;
  final String pushTo;

  @override
  State<TriviaBuilder> createState() => TriviaBuilderState();
}

class TriviaBuilderState extends State<TriviaBuilder> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  List<TriviaModel> trivias = List.empty(growable: true);
  bool loading = true;

  Future<void> _refreshData() async {
    try {
      // Call the asynchronous operation to fetch data
      final List<TriviaModel> fetched = await TriviaServices().getAll();

      // Update the state with the fetched data and call setState to rebuild the UI
      setState(() {
        loading = false;
        trivias = fetched;
      });

      // Trigger a refresh of the RefreshIndicator widget
      _refreshIndicatorKey.currentState?.show();
    } catch (e) {
      print("Get All Trivia:  ${e.toString()}");
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshData,
            child: Builder(
              builder: (context) {
                if (widget.pushTo == 'AdminPanelTrivia') {
                  return AdminPanelTrivia(
                    currentUser: widget.currentUser,
                    trivias: trivias,
                    notifyRefresh: (refresh) {
                      _refreshData();
                    },
                  );
                } else {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
              },
            ),
          );
  }
}
