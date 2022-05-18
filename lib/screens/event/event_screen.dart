import 'dart:async';

import 'package:behtarino/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/event/calendar_bloc.dart';
import '../../core/sqflite/events_db.dart';
import '../../core/utils/snack_bar.dart';
import 'widgets/clock_carousel.dart';

class EventScreen extends StatefulWidget {
  final int index;

  const EventScreen({Key? key, required this.index}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _hasValue = StreamController<bool>();
  List<EventsModel> eventsList = [];
  int eventHours = 1;
  int eventMinutes = 1;
  int eventDuration = 1;

  String _makeDateTimeIso8601(bool isStart) {

    if (isStart) {
      return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        eventHours,
        eventMinutes,
      ).toIso8601String();
    }

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      eventHours,
      eventMinutes,
    ).add(Duration(minutes: eventDuration)).toIso8601String();
  }

  int _makeDateTimeTimeStamp(bool isStart) {
    if (isStart) {
      return DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        eventHours,
        eventMinutes,
      ).millisecondsSinceEpoch;
    }

    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      eventHours,
      eventMinutes,
    ).add(Duration(minutes: eventDuration)).millisecondsSinceEpoch;
  }

  bool _checkConflict() {
    for (EventsModel i in eventsList) {
      if (DateTime.fromMillisecondsSinceEpoch(_makeDateTimeTimeStamp(true))
          .add(Duration(minutes: eventDuration + 2))
          .isAfter(DateTime.parse(i.start))) {
        if (DateTime.fromMillisecondsSinceEpoch(_makeDateTimeTimeStamp(true))
            .subtract(const Duration(minutes: 1))
            .isBefore(DateTime.parse(i.end))) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    eventHours = (widget.index ~/ 60).toInt();
    eventMinutes = widget.index % 60;

    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        _hasValue.sink.add(true);
      } else {
        _hasValue.sink.add(false);
      }
    });

    EventsDBHelper.instance.getEvents().then((value) {
      eventsList.addAll(value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'رویداد جدید',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Iran-sans', fontSize: 16),
        ),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.grey.shade50,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 7),
              child: Icon(
                Icons.close,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xfffbfbfb),
        padding: const EdgeInsets.only(top: 40),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xffc2c7cc),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'نام رویداد',
                    style: TextStyle(
                      fontFamily: 'Iran-sans',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _controller,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        height: 1,
                        fontFamily: 'iran-sans',
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'مانند: جشن نوروز',
                        hintStyle: TextStyle(
                          color: Color(0xffebeced),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color(0xffebeced),
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color(0xffebeced),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xffc2c7cc),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'زمان رویداد',
                    style: TextStyle(
                      fontFamily: 'Iran-sans',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'ساعت',
                            style: TextStyle(
                              color: Color(0xff9C9C9C),
                              fontFamily: 'Iran-sans',
                            ),
                          ),
                          ClockCarousel(
                            isMinute: false,
                            initialValue: eventHours,
                            callBack: (int page) {
                              eventHours = page;
                            },
                          ),
                        ],
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                          color: Color(0xff9C9C9C),
                          fontFamily: 'Iran-sans',
                          fontSize: 25,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'دقیقه',
                            style: TextStyle(
                              color: Color(0xff9C9C9C),
                              fontFamily: 'Iran-sans',
                            ),
                          ),
                          ClockCarousel(
                            isMinute: true,
                            initialValue: eventMinutes,
                            callBack: (int page) {
                              eventMinutes = page;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'مدت زمان رویداد (دقیقه)',
                    style: TextStyle(
                      fontFamily: 'Iran-sans',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ClockCarousel(
                    isMinute: true,
                    initialValue: 30,
                    callBack: (int page) {
                      eventDuration = page;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: StreamBuilder<bool>(
                    stream: _hasValue.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return BlocConsumer<CalendarBloc, CalendarState>(
                        listener: (context, state) {
                          if (state is CalendarDone) {
                            CustomSnackBar().show(
                              message: 'رویداد با موفقیت ثبت شد.',
                              context: context,
                            );
                            Navigator.of(context).pop();
                          }
                          if (state is CalendarError) {
                            CustomSnackBar().show(
                              message: state.message,
                              context: context,
                            );
                          }
                        },
                        builder: (context, state) {
                          return MaterialButton(
                            onPressed: !snapshot.data!
                                ? null
                                : () {
                                    if (_checkConflict()) {
                                      CustomSnackBar().show(
                                        message:
                                            'در بازه زمانی انتخاب شده قبلا رویداد ثبت شده!',
                                        context: context,
                                      );
                                    } else {
                                      BlocProvider.of<CalendarBloc>(context)
                                          .add(
                                        SubmitEvent(
                                          name: _controller.text,
                                          start: _makeDateTimeIso8601(true)
                                              .toString() + 'Z',
                                          end: _makeDateTimeIso8601(false)
                                              .toString() + 'Z',
                                        ),
                                      );
                                    }
                                  },
                            padding: const EdgeInsets.fromLTRB(1, 0, 1, 8),
                            disabledColor: Colors.grey,
                            color: const Color(0xff4361ee),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: state is CalendarLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1,
                                      )
                                    : const Text(
                                        'ثبت',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Iran-sans',
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
