import 'package:behtarino/core/utils/convert_numbers.dart';
import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'widgets/clock_section.dart';
import 'widgets/event_overlay.dart';
import 'widgets/line_section.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final ScrollController _controller = ScrollController();
  int clockIndex = 0;
  bool isClockPrint = true;

  @override
  void initState() {
    final double timeIndex = ((DateTime.now().hour * 60) + DateTime.now().minute).toDouble();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.animateTo(
          (timeIndex * 2.10), duration: const Duration(milliseconds: 100),
          curve: Curves.ease);
    });
    super.initState();
  }

  String formatDate(Date d) {
    final f = d.formatter;

    return '${f.wN} ${f.yyyy}/${f.mm}/${f.d}';
  }

  @override
  Widget build(BuildContext context) {

    final double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color(0xfffbfbfb),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                child: Center(
                  child: Text(
                    Converter().convertToPersianNumbers(formatDate(Jalali.now())),
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Iran-sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                width: w,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 6),
                      child: SingleChildScrollView(
                        controller: _controller,
                        physics: const BouncingScrollPhysics(),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                CalendarDayViewLineSection(
                                  w: w,
                                ),
                                CalendarDayViewClockSection(
                                  w: w,
                                ),
                              ],
                            ),
                            IgnorePointer(
                              child: CalendarDayViewEventsOverlay(
                                w: w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: -(w * 0.02),
                      child: IgnorePointer(
                        child: Container(
                          width: w * 0.912,
                          height: MediaQuery.of(context).size.height * 0.8,
                          padding: EdgeInsets.all(w * 0.02),
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              width: w * 0.02,
                              color: const Color(0xfffbfbfb),
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                          ),
                          child: Container(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            foregroundDecoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
