import 'package:flutter/material.dart';
import 'package:triviazilla/src/widgets/appbar/appbar_confirm_cancel.dart';
import 'package:intl/intl.dart';

import '../../model/user_model.dart';

class UsersPicker extends StatefulWidget {
  final List<UserModel> userList;
  final Function(List<UserModel> selectedUsers, BuildContext pickerContext)
      onPost;

  const UsersPicker({
    super.key,
    required this.userList,
    required this.onPost,
  });

  @override
  State<UsersPicker> createState() => _UsersPickerState();
}

class _UsersPickerState extends State<UsersPicker> {
  List<UserModel> filteredData = [];

  List<UserModel> selected = [];

  final searchController = TextEditingController();

  int _currentSortColumn = 0;
  bool _isAscending = true;

  void post(BuildContext context) {
    print("Selected: $selected");
    widget.onPost(selected, context);
  }

  @override
  void initState() {
    filteredData = widget.userList;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      filteredData = text.isEmpty
          ? widget.userList
          : widget.userList
              .where((user) =>
                  user.email.toLowerCase().contains(text.toLowerCase()) ||
                  user.role!.name.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarConfirmCancel(
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          post(context);
        },
        context: context,
        title: "Select Users",
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchTextChanged,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                DataTable(
                  sortColumnIndex: _currentSortColumn,
                  sortAscending: _isAscending,
                  columns: <DataColumn>[
                    DataColumn(
                      label: const Text('Email'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.email.compareTo(userB.email));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.email.compareTo(userA.email));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Name'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) {
                              return userA.name.compareTo(userB.name);
                            });
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) {
                              return userB.name.compareTo(userA.name);
                            });
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Role'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.role!.name.compareTo(userB.role!.name));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.role!.name.compareTo(userA.role!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Created at'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.userList.sort((userA, userB) =>
                                userA.createdAt.compareTo(userB.createdAt));
                          } else {
                            _isAscending = true;
                            widget.userList.sort((userA, userB) =>
                                userB.createdAt.compareTo(userA.createdAt));
                          }
                        });
                      },
                    ),
                  ],
                  onSelectAll: (isSelectedAll) {
                    setState(() {
                      if (isSelectedAll == true) {
                        for (var user in widget.userList) {
                          selected.add(user);
                        }
                      } else {
                        selected = [];
                      }
                    });
                  },
                  rows: List.generate(filteredData.length, (index) {
                    final UserModel user = filteredData[index];
                    return DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        // All rows will have the same selected color.
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08);
                        }
                        // Even rows will have a grey color.
                        if (index.isEven) {
                          return Colors.grey.withOpacity(0.3);
                        }
                        return null; // Use default value for other states and odd rows.
                      }),
                      cells: [
                        DataCell(Text(user.email)),
                        DataCell(Text(user.name)),
                        DataCell(Text(user.role!.displayName)),
                        DataCell(Text(
                            DateFormat('dd/MM/yyyy').format(user.createdAt))),
                      ],
                      selected: selected.contains(user),
                      onSelectChanged: (bool? isSelected) {
                        if (isSelected != null) {
                          setState(() {
                            isSelected
                                ? selected.add(user)
                                : selected.remove(user);
                          });
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
