// import 'package:mbl/component/'
import 'package:flutter/material.dart';
import 'package:mbl/component/calendar.dart';
import 'package:mbl/component/log_bottom_sheet.dart';
import 'package:mbl/component/my_log.dart';
import 'package:mbl/component/today_banner.dart';
import 'package:mbl/const/colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: renderFloatingActionButton(),
        body: SafeArea(
          child: Column(
            children: [
              Calendar(
                  selectedDay: selectedDay,
                  focusedDay: focusedDay,
                  onDaySelected: onDaySelected),
              TodayBanner(selectedDay: selectedDay),
              const _LogList(),
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
            return LogBottomSheet();
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
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

class _LogList extends StatelessWidget {
  const _LogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.separated(
              itemCount: 100,
              itemBuilder: (context, index) {
                return (const MyLog(content: "hiiiii", color: Colors.red));
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8.0);
              },
            )));
  }
}
