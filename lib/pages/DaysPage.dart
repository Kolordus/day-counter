import 'package:day_counter/EventTimeStampCard.dart';
import 'package:flutter/material.dart';

import '../Database.dart';
import '../model/EventTimestamp.dart';

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<StatefulWidget> createState() => _DaysPageState();
}

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
                              startDate: currentItem.startDate,
                              endDate: currentItem.endDate)
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
