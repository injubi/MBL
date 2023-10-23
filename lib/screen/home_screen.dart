// import 'package:mbl/component/'
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mbl/component/calendar.dart';
import 'package:mbl/component/log_bottom_sheet.dart';
import 'package:mbl/component/today_banner.dart';
import 'package:mbl/const/colors.dart';
import 'package:mbl/database/drift_database.dart';
import 'package:mbl/model/log_with_color.dart';

import '../component/my_log.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  Map<DateTime, List<Event>> events = {};
  @override
  Widget build(BuildContext context) {
    print(selectedDay);
    return Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder<Map<DateTime, List<Event>>>(
                  future: GetIt.I<LocalDatabase>().getEventsByDate(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      events = snapshot.data!;
                    }

                    return Calendar(
                        selectedDay: selectedDay,
                        focusedDay: focusedDay,
                        onDaySelected: onDaySelected,
                        events: events);
                  }),
              TodayBanner(selectedDay: selectedDay),
              SizedBox(height: 8.0),
              _LogList(selectedDate: selectedDay),
            ],
          ),
        ));
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return LogBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: const Icon(
        Icons.add,
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime forcusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = selectedDay;
    });
  }
}

class Event {
  String title;

  Event(this.title);
}

class _LogList extends StatelessWidget {
  final DateTime selectedDate;

  const _LogList({required this.selectedDate, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: StreamBuilder<List<LogWithColor>>(
        stream: GetIt.I<LocalDatabase>().watchLogs(selectedDate),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(
              child: Text('스케줄이 없습니다.'),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 8.0);
            },
            itemBuilder: (context, index) {
              final scheduleWithColor = snapshot.data![index];

              return Dismissible(
                key: ObjectKey(scheduleWithColor.log.id),
                direction: DismissDirection.endToStart,
                onDismissed: (DismissDirection direction) {
                  GetIt.I<LocalDatabase>().removeLog(scheduleWithColor.log.id);
                },
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) {
                        return LogBottomSheet(
                          selectedDate: selectedDate,
                          logId: scheduleWithColor.log.id,
                        );
                      },
                    );
                  },
                  child: MyLog(
                    content: scheduleWithColor.log.content,
                    color: Color(
                      int.parse('FF${scheduleWithColor.categoryColor.hexCode}',
                          radix: 16),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    ));
  }
}
