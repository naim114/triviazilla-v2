import 'package:flutter/material.dart';
import 'package:triviazilla/src/model/trivia_model.dart';
import 'package:intl/intl.dart';
import 'package:triviazilla/src/widgets/modal/trivia_modal.dart';

import '../../../model/user_model.dart';
import '../../../services/helpers.dart';

class AdminPanelTrivia extends StatefulWidget {
  const AdminPanelTrivia({
    super.key,
    required this.currentUser,
    required this.trivias,
    required this.notifyRefresh,
  });
  final Function(bool refresh) notifyRefresh;
  final UserModel currentUser;
  final List<TriviaModel> trivias;

  @override
  State<AdminPanelTrivia> createState() => _AdminPanelTrivia();
}

class _AdminPanelTrivia extends State<AdminPanelTrivia> {
  List<TriviaModel> filteredData = List.empty(growable: true);

  final searchController = TextEditingController();

  int _currentSortColumn = 0;
  bool _isAscending = true;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged(String text) {
    print(
        "youre not serious people ${widget.trivias.where((trivia) => trivia.title.toLowerCase().contains(text.toLowerCase())).map((e) => e.title).toList()}");
    setState(() {
      filteredData = text.isEmpty
          ? widget.trivias
          : widget.trivias
              .where((trivia) =>
                  trivia.title.toLowerCase().contains(text.toLowerCase()))
              .toList();
    });
  }

  @override
  void initState() {
    filteredData = widget.trivias;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    filteredData = widget.trivias;

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
          "Manage Trivia",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: getColorByBackground(context),
          ),
        ),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            child: Text(
              'View all trivia here. Search trivia by typing to the textbox.',
              textAlign: TextAlign.justify,
            ),
          ),
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
                      label: const Text('Title'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.trivias.sort((itemA, itemB) =>
                                itemB.title.compareTo(itemA.title));
                          } else {
                            _isAscending = true;
                            widget.trivias.sort((itemA, itemB) =>
                                itemA.title.compareTo(itemB.title));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Created By'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.trivias.sort((itemA, itemB) => itemB
                                .author!.name
                                .compareTo(itemA.author!.name));
                          } else {
                            _isAscending = true;
                            widget.trivias.sort((itemA, itemB) => itemA
                                .author!.name
                                .compareTo(itemB.author!.name));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Created At'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.trivias.sort((itemA, itemB) =>
                                itemB.createdAt.compareTo(itemA.createdAt));
                          } else {
                            _isAscending = true;
                            widget.trivias.sort((itemA, itemB) =>
                                itemA.createdAt.compareTo(itemB.createdAt));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Edited At'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.trivias.sort((itemA, itemB) =>
                                itemB.updatedAt.compareTo(itemA.updatedAt));
                          } else {
                            _isAscending = true;
                            widget.trivias.sort((itemA, itemB) =>
                                itemA.updatedAt.compareTo(itemB.updatedAt));
                          }
                        });
                      },
                    ),
                    DataColumn(
                      label: const Text('Likes'),
                      onSort: (columnIndex, _) {
                        setState(() {
                          _currentSortColumn = columnIndex;
                          if (_isAscending == true) {
                            _isAscending = false;
                            widget.trivias.sort((itemA, itemB) {
                              int itemALikeCount = itemA.likedBy == null
                                  ? 0
                                  : itemA.likedBy!.length;
                              int itemBLikeCount = itemB.likedBy == null
                                  ? 0
                                  : itemB.likedBy!.length;

                              return itemBLikeCount.compareTo(itemALikeCount);
                            });
                          } else {
                            _isAscending = true;
                            widget.trivias.sort((itemA, itemB) {
                              int itemALikeCount = itemA.likedBy == null
                                  ? 0
                                  : itemA.likedBy!.length;
                              int itemBLikeCount = itemB.likedBy == null
                                  ? 0
                                  : itemB.likedBy!.length;

                              return itemALikeCount.compareTo(itemBLikeCount);
                            });
                          }
                        });
                      },
                    ),
                    const DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: List.generate(
                    filteredData.length,
                    (index) {
                      final TriviaModel trivia = filteredData[index];
                      return DataRow(
                        cells: [
                          DataCell(SizedBox(
                            width: 350,
                            child: Text(
                              trivia.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                            ),
                          )),
                          DataCell(Text(trivia.author!.name)),
                          DataCell(Text(DateFormat('dd/MM/yyyy hh:mm a')
                              .format(trivia.createdAt))),
                          DataCell(Text(DateFormat('dd/MM/yyyy hh:mm a')
                              .format(trivia.updatedAt))),
                          DataCell(Text(trivia.likedBy == null
                              ? '0'
                              : trivia.likedBy!.length.toString())),
                          DataCell(
                            Row(
                              children: [
                                // View
                                IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    showTriviaModal(
                                      trivia: trivia,
                                      context: context,
                                      user: widget.currentUser,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
