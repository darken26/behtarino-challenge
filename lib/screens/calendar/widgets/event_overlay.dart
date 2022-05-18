import 'package:behtarino/core/utils/convert_numbers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_builder/timer_builder.dart';


class CalendarDayViewEventsOverlay extends StatelessWidget {
  final double w;
  CalendarDayViewEventsOverlay({Key? key, required this.w}) : super(key: key);

  String time = '';

  @override
  Widget build(BuildContext context) {
    return TimerBuilder.periodic(
      const Duration(minutes: 1),
      builder: (context) {

        time = Converter().convertToPersianNumbers(DateFormat.jm().format(DateTime.now()));
        time.replaceAll('PM', '').replaceAll('AM', '');

        return ListView.builder(
          itemCount: 1440,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {

            if(index == ((DateTime.now().hour) * 60) + (DateTime.now().minute)) {
              return Stack(
                alignment: Alignment.topLeft,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: w * 0.88,
                    height: 1.5,
                    color: Colors.blue,
                  ),
                  Positioned(
                    top: -8,
                    right: 2,
                    child: Container(
                      height: 18,
                      width: w * 0.098,
                      decoration: BoxDecoration(
                        color: const Color(0xfffbfbfb),
                        border: Border.all(
                          width: 1,
                          color: Colors.blue,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Iran-sans',
                            color: Colors.blue,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return SizedBox(
              height: 2.15,
              width: w * 0.8,
            );
          },
        );
      }
    );
  }
}
