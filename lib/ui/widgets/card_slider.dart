import 'package:eclipse_test/data/utils/app_theme.dart';
import 'package:flutter/material.dart';

/// Карусель карточек
class CardSlider extends StatefulWidget {
  const CardSlider(
      {super.key,
      required this.pageController,
      required this.itemCount,
      required this.onPageChanged,
      required this.builder,
      required this.onTap,
      this.numericCount = false,
      this.height = 120});

  final PageController pageController;
  final int itemCount;
  final void Function(int) onPageChanged;
  final Widget Function(int) builder;
  final void Function() onTap;
  final double height;
  final bool numericCount;
  @override
  State<CardSlider> createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  int currentPageNum = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: MediaQuery.of(context).size.width,
          child: PageView.builder(
              pageSnapping: true,
              itemCount: widget.itemCount,
              controller: widget.pageController,
              onPageChanged: (pageNum) => setState(() {
                    currentPageNum = pageNum;
                    widget.onPageChanged(pageNum);
                  }),
              itemBuilder: (context, pagePos) {
                return GestureDetector(
                  onTap: widget.onTap,
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    elevation: 4,
                    color: primaryColor.withOpacity(0),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: widget.builder(pagePos),
                      ),
                    ),
                  ),
                );
              }),
        ),
        widget.numericCount
            ? pageCountIndicators(widget.itemCount, currentPageNum)
            : Center(
                child: Wrap(
                  direction: Axis.horizontal,
                  children:
                      pageViewIndicators(widget.itemCount, currentPageNum),
                ),
              ),
      ],
    );
  }

  List<Widget> pageViewIndicators(pagesCount, currentPage) {
    return List<Widget>.generate(pagesCount, (index) {
      return Container(
        margin: const EdgeInsets.all(5),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentPage == index ? Colors.teal : Colors.white70,
            shape: BoxShape.circle),
      );
    });
  }

  Container pageCountIndicators(pagesCount, currentPage) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 50,
      height: 50,
      decoration:
          const BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
      child: Center(
        child: Text('${currentPage + 1}/$pagesCount'),
      ),
    );
  }
}
