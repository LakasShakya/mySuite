import 'package:flutter/material.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:intl/intl.dart';


class CustomCalender extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    home: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(icon: Icon(Icons.calendar_today), text: 'Calender'),
              // Tab(icon: Icon(Icons.date_range), text: 'DatePicker'),
              // Tab(icon: Icon(Icons.dns), text: 'Pagination'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Custom(),
          ],
        ),
      ),
    ),
  );
}

class Custom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PagedVerticalCalendar(
      startWeekWithSunday: true,

      /// customize the month header look by adding a week indicator
      monthBuilder: (context, month, year) {
        return Column(
          children: [
            /// create a customized header displaying the month and year
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Text(
                DateFormat('MMMM yyyy').format(DateTime(year, month)),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),

            /// add a row showing the weekdays
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weekText('Su'),
                  weekText('Mo'),
                  weekText('Tu'),
                  weekText('We'),
                  weekText('Th'),
                  weekText('Fr'),
                  weekText('Sa'),
                ],
              ),
            ),
          ],
        );
      },

      /// added a line between every week
      dayBuilder: (context, date) {
        return Column(
          children: [
            Text(DateFormat('d').format(date)),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget weekText(String text) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey, fontSize: 10),
      ),
    );
  }
}
