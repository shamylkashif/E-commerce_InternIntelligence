import 'package:bookstore/book_desp.dart';
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

    timer = Timer.periodic(const Duration(milliseconds: 90), (Timer t) {
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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: TextField(
              style: const TextStyle(color: Colors.black),
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
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Text('Category', style: TextStyle(color: Color(0xFF0A4DA2), fontSize: 25)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
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
          // Books Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: books.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,  // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio : 3/4,
                            child: GestureDetector(
                              onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDescription()));
                                                 },
                              child: Image.asset(
                                book['imageUrl']! ,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            book['title']! ,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mock data for books
final List<Map<String, String>> books = [
  {'title': 'Soul', 'imageUrl': 'assets/slider/download.jpeg'},
  {'title': 'Harry Potter', 'imageUrl': 'assets/slider/Harry.jpeg'},
  {'title': 'Memory', 'imageUrl': 'assets/slider/memory.jpeg'},
  {'title': 'The Design', 'imageUrl': 'assets/slider/The design.png'},
  {'title': 'Harry Potter', 'imageUrl': 'assets/slider/Harry.jpeg'},
  {'title': 'Soul', 'imageUrl': 'assets/slider/download.jpeg'},
];

class CategoryContainer extends StatelessWidget {
  final String label;

  const CategoryContainer({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: yellow.withOpacity(0.6),
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
