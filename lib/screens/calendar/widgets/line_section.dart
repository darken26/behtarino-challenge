import 'dart:convert';
import 'dart:ui' as ui;

import 'package:behtarino/core/utils/convert_numbers.dart';
import 'package:behtarino/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/sqflite/events_db.dart';
import '../../event/event_screen.dart';

class CalendarDayViewLineSection extends StatefulWidget {
  final double w;

  const CalendarDayViewLineSection({Key? key, required this.w})
      : super(key: key);

  @override
  _CalendarDayViewLineSectionState createState() =>
      _CalendarDayViewLineSectionState();
}

class _CalendarDayViewLineSectionState
    extends State<CalendarDayViewLineSection> {
  List<EventsModel> eventsList = [];
  int submitIndex = -1;
  int eventIndex = 0;

  int _checkSubmitButtonAndEventConflict(int index) {
    int result = 31;
    int startIndex = 0;

    for (EventsModel i in eventsList) {
      startIndex = _returnEventIndex(i.start);
      if (index < startIndex && (index - startIndex) <= 30) {
        result = index - startIndex;
        break;
      }
    }

    return result.abs();
  }

  bool _checkHasEventIsInTheWay(int index) {
    for (int i = 0; i < eventsList.length; i++) {
      if (_returnEventIndex(eventsList[i].start) == index) {
        eventIndex = i;
        return true;
      }
    }

    return false;
  }

  int _returnEventIndex(String eventTime) {
    final DateTime time = DateTime.parse(eventTime);

    return (time.hour * 60) + time.minute;
  }

  String _returnHourAndMinuteWithPersianNumber() {
    final String s =
        DateFormat.jm().format(DateTime.parse(eventsList[eventIndex].start));
    final String e =
        DateFormat.jm().format(DateTime.parse(eventsList[eventIndex].end));
    final String endTime = e.replaceAll('PM', 'ب.ظ').replaceAll('AM', 'ق.ظ');
    final String startTime = s.replaceAll('PM', '').replaceAll('AM', '');

    return Converter().convertToPersianNumbers('$startTimeتا $endTime');
  }

  @override
  Widget build(BuildContext context) {
    eventIndex = 0;

    return SizedBox(
      width: widget.w * 0.87,
      child: FutureBuilder<List<EventsModel>>(
          future: EventsDBHelper.instance.getEvents(),
          builder: (context, AsyncSnapshot<List<EventsModel>> snapshot) {

            eventsList.clear();
            eventsList.addAll(snapshot.data ?? []);

            return ListView.builder(
              itemCount: 1440,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (submitIndex == index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                            builder: (context) => EventScreen(
                              index: index,
                            ),
                          ))
                          .then((value) => setState(() => submitIndex = -1));
                    },
                    child: Container(
                      height: 30 * 2.15,
                      width: widget.w * 0.8,
                      padding: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xffb9ebfb),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                  );
                }

                if (submitIndex > 0 &&
                    submitIndex < index &&
                    (submitIndex + 30) > index) {
                  return const SizedBox();
                }

                if (eventsList.isNotEmpty &&
                    _checkHasEventIsInTheWay(index)) {
                  final int diff =
                      _returnEventIndex(eventsList[eventIndex].end) -
                          _returnEventIndex(eventsList[eventIndex].start);
                  return Container(
                    height: (diff + 1) * 2.15,
                    width: widget.w * 0.8,
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xff3a0ca3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: diff < 20
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _returnHourAndMinuteWithPersianNumber(),
                                textDirection: ui.TextDirection.rtl,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iran-sans',
                                ),
                              ),
                              Text(
                                " - " + utf8.decode(eventsList[eventIndex].name.runes.toList()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iran-sans',
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                utf8.decode(eventsList[eventIndex].name.runes.toList()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iran-sans',
                                ),
                              ),
                              Text(
                                _returnHourAndMinuteWithPersianNumber(),
                                textDirection: ui.TextDirection.rtl,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iran-sans',
                                ),
                              ),
                            ],
                          ),
                  );
                }

                if (eventsList.isNotEmpty &&
                    _returnEventIndex(eventsList[eventIndex].start) < index &&
                    _returnEventIndex(eventsList[eventIndex].end) >= index) {
                  if (_returnEventIndex(eventsList[eventIndex].end) ==
                      index) {
                    eventIndex = 0;
                  }

                  return const SizedBox();
                }

                if (index % 15 == 0) {
                  return Container(
                    height: 2.15,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: index % 60 == 0 ? 1.5 : 0.5,
                          color: const Color(0xffC2C7CC),
                        ),
                      ),
                    ),
                    child: InkWell(
                      onLongPress: () {
                        setState(() {
                          submitIndex = index;
                          eventIndex = 0;
                        });
                      },
                    ),
                  );
                }

                return SizedBox(
                  height: 2.15,
                  width: double.infinity,
                  child: InkWell(
                    onLongPress: () {
                      setState(() {
                        int diff = _checkSubmitButtonAndEventConflict(index);
                        if (diff < 31) {
                          submitIndex = index - (30 - diff);
                        } else {
                          submitIndex = index;
                        }

                        eventIndex = 0;
                      });
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
