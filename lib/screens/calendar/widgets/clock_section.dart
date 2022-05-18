import 'package:flutter/material.dart';

class CalendarDayViewClockSection extends StatefulWidget {
  final double w;

  const CalendarDayViewClockSection({Key? key, required this.w})
      : super(key: key);

  @override
  _CalendarDayViewClockSectionState createState() =>
      _CalendarDayViewClockSectionState();
}

class _CalendarDayViewClockSectionState
    extends State<CalendarDayViewClockSection> {
  int clockIndex = -1;
  bool isClockPrinted = true;

  final List<String> clock = [
    '۱۲:۰۰',
    '۰۱:۰۰',
    '۰۲:۰۰',
    '۰۳:۰۰',
    '۰۴:۰۰',
    '۰۵:۰۰',
    '۰۶:۰۰',
    '۰۷:۰۰',
    '۰۸:۰۰',
    '۰۹:۰۰',
    '۱۰:۰۰',
    '۱۱:۰۰',
    '۱۲:۰۰',
    '۰۱:۰۰',
    '۰۲:۰۰',
    '۰۳:۰۰',
    '۰۴:۰۰',
    '۰۵:۰۰',
    '۰۶:۰۰',
    '۰۷:۰۰',
    '۰۸:۰۰',
    '۰۹:۰۰',
    '۱۰:۰۰',
    '۱۱:۰۰',
    '۱۱:۰۰',
    '۱۱:۰۰',
  ];

  final List<String> amPm = [
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ق.ظ',
    'ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
    'ب.ظ',
  ];

  @override
  Widget build(BuildContext context) {
    clockIndex = -1;
    return SizedBox(
      width: widget.w * 0.13,
      child: ListView.builder(
        itemCount: 288,
        shrinkWrap: true,
        padding: const EdgeInsets.only(left: 10),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {

          if (index % 12 == 0) {
            isClockPrinted = true;
            clockIndex++;
            return SizedBox(
              height: 15,
              child: Text(
                clock[clockIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Iran-sans',
                  color: Color(0xff9C9C9C),
                  fontSize: 14,
                ),
              ),
            );
          }

          if (index % 3 == 0 && isClockPrinted) {
            isClockPrinted = false;
            return SizedBox(
              height: 15,
              child: Text(
                amPm[clockIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Iran-sans',
                  color: Color(0xff9C9C9C),
                  fontSize: 10,
                ),
              ),
            );
          }

          return SizedBox(
            height: 9.9,
            width: widget.w * 0.8,
          );
        },
      ),
    );
  }
}
