import 'package:day_counter/EventTimeStampCard.dart';
import 'package:flutter/material.dart';

import '../Database.dart';
import '../model/EventTimestamp.dart';

class _DaysPageState extends State<DaysPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Database.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var allDates = snapshot.data as List<EventTimestamp>;
            return Padding(
              padding: const EdgeInsets.fromLTRB(0,35,0,0),
              child: ReorderableListView.builder(
                itemCount: allDates.length,
                itemBuilder: (context, index) {
                  EventTimestamp currentItem = allDates.elementAt(index);
                  var inProperOrder = _inProperOrder(currentItem);
                  return GestureDetector(
                    key: ValueKey(currentItem.name),
                    onDoubleTap: () async {
                      setState(() {
                        Database.delete(index);
                      });
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          EventTimestampCard(
                              name: currentItem.name,
                              startDate: inProperOrder!
                                  ? currentItem.startDate
                                  : currentItem.endDate,
                              endDate: inProperOrder
                                  ? currentItem.endDate
                                  : currentItem.startDate,
                              refresh: () => {refresh()}),
                        ],
                      ),
                    ),
                  );
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    newIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
                    // if bigger then deal with array indexes

                    _handleReplacement(allDates, oldIndex, newIndex);
                  });
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  void _handleReplacement(
      List<EventTimestamp> allDates, int oldIndex, int newIndex) {
    var removeAt = allDates.removeAt(oldIndex);
    allDates.insert(newIndex, removeAt);
    Database.replace(allDates).then((_) => {setState(() {})});
  }

  bool? _inProperOrder(EventTimestamp currentItem) {
    if (currentItem.endDate != null && currentItem.startDate != null) {
      return currentItem.startDate?.isBefore(currentItem.endDate!);
    }
    return true;
  }

  void refresh() {
    setState(() {});
  }
}

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<StatefulWidget> createState() => _DaysPageState();
}
