import 'package:day_counter/EventTimeStampCard.dart';
import 'package:flutter/material.dart';

import '../Database.dart';
import '../model/EventTimestamp.dart';

class _DaysPageState extends State<DaysPage>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Database.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var allDates = snapshot.data as List<EventTimestamp>;

            return ListView.builder(
                itemCount: allDates.length,
                itemBuilder: (context, index) {
                  EventTimestamp currentItem = allDates.elementAt(index);
                  var inProperOrder = _inProperOrder(currentItem);
                  return GestureDetector(
                    onDoubleTap: () {
                      Database.delete(currentItem.name);
                      setState(() {});
                    },
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          EventTimestampCard(
                              name: currentItem.name,
                              startDate: inProperOrder! ? currentItem.startDate : currentItem.endDate,
                              endDate: inProperOrder? currentItem.endDate : currentItem.startDate
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  bool? _inProperOrder(EventTimestamp currentItem) {
    if (currentItem.endDate != null && currentItem.startDate != null) {
      return currentItem.startDate?.isBefore(currentItem.endDate!);
    }
    return true;
  }
}

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<StatefulWidget> createState() => _DaysPageState();
}
