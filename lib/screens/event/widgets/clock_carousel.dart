import 'package:flutter/material.dart';

import '../../../core/utils/convert_numbers.dart';

class ClockCarousel extends StatefulWidget {
  final bool isMinute;
  final int initialValue;
  final Function callBack;

  const ClockCarousel({
    Key? key,
    required this.isMinute,
    this.initialValue = 0,
    required this.callBack,
  }) : super(key: key);

  @override
  _ClockCarouselState createState() => _ClockCarouselState();
}

class _ClockCarouselState extends State<ClockCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.3);
  int pageIndex = 0;

  @override
  void initState() {
    pageIndex = widget.initialValue - 1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffC2C7CC),
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4),
          InkWell(
            onTap: previousPage,
            child: const SizedBox(
              height: 30, // card height
              width: 30,
              child: Icon(
                Icons.arrow_back_ios,
                color: Color(0xff719dff),
                size: 20,
              ),
            ),
          ),
          SizedBox(
            height: 30, // card height
            width: 80,
            child: SizedBox(
              child: PageView.builder(
                itemCount: widget.isMinute ? 60 : 24,
                controller: _controller,
                onPageChanged: (int index) {
                  setState(() => pageIndex = index);
                  widget.callBack(index + 1);
                },
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == pageIndex ? 1.2 : 0.9,
                    child: Center(
                      child: Text(
                        Converter().convertToPersianNumbers("${i + 1}"),
                        style: TextStyle(
                            fontSize: 18,
                            color: i == pageIndex
                                ? const Color(0xff3473ff)
                                : const Color(0xffaec7ff),
                            fontFamily: 'Iran-sans'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: nextPage,
            child: const SizedBox(
              height: 30, // card height
              width: 30,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff719dff),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void nextPage() {
    _controller.animateToPage(_controller.page!.toInt() + 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  void previousPage() {
    _controller.animateToPage(_controller.page!.toInt() - 1,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
  }
}
