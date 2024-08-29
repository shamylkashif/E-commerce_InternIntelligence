import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController scrollController1;
  late ScrollController scrollController2;
  late Timer timer;

  bool reverse1 = false;
  bool reverse2 = false;

  @override
  void initState() {
    super.initState();

    scrollController1 = ScrollController();
    scrollController2 = ScrollController();

    timer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
      autoScroll(scrollController1, reverse1, (isReverse) {
        setState(() {
          reverse1 = isReverse;
        });
      });
      autoScroll(scrollController2, reverse2, (isReverse) {
        setState(() {
          reverse2 = isReverse;
        });
      });
    });
  }

  void autoScroll(ScrollController controller, bool reverse, Function(bool) updateDirection) {
    double maxScrollExtent = controller.position.maxScrollExtent;
    double minScrollExtent = controller.position.minScrollExtent;

    if (!reverse) {
      controller.jumpTo(controller.offset + 2);
      if (controller.offset >= maxScrollExtent) {
        updateDirection(true);  // Change direction to reverse
      }
    } else {
      controller.jumpTo(controller.offset - 2);
      if (controller.offset <= minScrollExtent) {
        updateDirection(false);  // Change direction to forward
      }
    }
  }

  @override
  void dispose() {
    scrollController1.dispose();
    scrollController2.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100, left: 10, right: 10),
            child: TextField(
              style: const TextStyle(color: Colors.black,),
              decoration: InputDecoration(
                labelText: 'Search book',
                labelStyle: const TextStyle(color: Color(0xFF0A4DA2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0A4DA2)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0A4DA2)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('Category', style: TextStyle(color: Color(0xFF0A4DA2), fontSize: 25)),
          ),
          SizedBox(height: 10,),
          SizedBox(
            height: 107.5,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController1,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryContainer(label: 'Fantasy'),
                      CategoryContainer(label: 'Horror'),
                      CategoryContainer(label: 'Adventure'),
                      CategoryContainer(label: 'Self-help'),
                      CategoryContainer(label: 'Travel'),
                      CategoryContainer(label: 'Cooking'),
                      CategoryContainer(label: 'Crime'),
                      CategoryContainer(label: 'Politics'),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController2,
                    scrollDirection: Axis.horizontal,
                    children: [
                      CategoryContainer(label: 'Art'),
                      CategoryContainer(label: 'Early Readers'),
                      CategoryContainer(label: 'Text Books'),
                      CategoryContainer(label: 'Study Guides'),
                      CategoryContainer(label: 'Test Preparation'),
                      CategoryContainer(label: 'Islam'),
                      CategoryContainer(label: 'Nature'),
                      CategoryContainer(label: 'Environment'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryContainer extends StatelessWidget {
  final String label;

  const CategoryContainer({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      width: 100,
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: blue),
        ),
      ),
    );
  }
}
