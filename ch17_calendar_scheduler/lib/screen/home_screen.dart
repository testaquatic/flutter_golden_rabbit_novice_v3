import 'package:ch17_calendar_scheduler/component/main_calendar.dart';
import 'package:ch17_calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:ch17_calendar_scheduler/component/schedule_card.dart';
import 'package:ch17_calendar_scheduler/component/today_banner.dart';
import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:ch17_calendar_scheduler/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) {
              return ScheduleBottomSheet(selectedDate: selectedDate);
            },
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 달력
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("schedule")
                  .where(
                    "date",
                    isEqualTo:
                        "${selectedDate.year}${selectedDate.month.toString().padLeft(2, "0")}${selectedDate.day.toString().padLeft(2, "0")}",
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("schedule")
                    .where(
                      "date",
                      isEqualTo:
                          "${selectedDate.year}${selectedDate.month.toString().padLeft(2, "0")}${selectedDate.day.toString().padLeft(2, "0")}",
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  // 오류가 발생했을 때
                  if (snapshot.hasError) {
                    return Center(child: Text("일정 정보를 가져오지 못했습니다."));
                  }

                  // 로딩중일 때
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  // ScheduleModel로 데이터 매핑하기
                  final schedules = snapshot.data!.docs
                      .map(
                        (e) => ScheduleModel.fromJson(
                          json: (e.data() as Map<String, dynamic>),
                        ),
                      )
                      .toList();

                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];

                      return Dismissible(
                        key: ObjectKey(schedule.id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection("schedule")
                              .doc(schedule.id)
                              .delete();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: ScheduleCard(
                            startTime: schedule.startTime,
                            endTime: schedule.endTime,
                            content: schedule.content,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
