import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  /// 위에는 달력
  /// 아래에는 일정 리스트
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 선택한 날짜
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate),
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
              onDaySelected: (selectedDate, focusedDate) => {
                onDaySelected(selectedDate, focusedDate, context),
              },
            ),
            const SizedBox(height: 8.0),
            // 날짜와 일정수
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("schedule")
                  .where(
                    "date",
                    isEqualTo:
                        "${selectedDate.year}${selectedDate.month.toString().padLeft(2, "0")}${selectedDate.day.toString().padLeft(2, "0")}",
                  )
                  .where(
                    "author",
                    isEqualTo: FirebaseAuth.instance.currentUser!.email,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.docs.length ?? 0,
                );
              },
            ),

            const SizedBox(height: 8.0),
            // 일정 리스트
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("schedule")
                    .where(
                      "date",
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                    )
                    .where(
                      "author",
                      isEqualTo: FirebaseAuth.instance.currentUser!.email,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("일정 정보를 가져오지 못했습니다."));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }

                  final schedules = snapshot.data!.docs
                      .map((e) => ScheduleModel.fromJson(json: e.data()))
                      .toList();

                  return ListView.builder(
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return Dismissible(
                        key: ObjectKey(schedule.id),

                        direction: DismissDirection.startToEnd,
                        // 일정을 삭제한다.
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

  // 날짜를 선택했을 때 실행하는 콜백
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
