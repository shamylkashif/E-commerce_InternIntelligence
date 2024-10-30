import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class ReadReview extends StatefulWidget {
  const ReadReview({super.key});

  @override
  State<ReadReview> createState() => _ReadReviewState();
}

class _ReadReviewState extends State<ReadReview> {
  // Sample reviews data
  final List<Map<String, String>> reviews = [
    {
      "bookName": "Book One",
      "authorName": "Author One",
      "criticName": "Critic One",
      "rating": "4",
      "review": "This is a fantastic book that provides in-depth knowledge on various topics. "
          "The author does a great job of explaining complex concepts in a simple manner. "
          "I highly recommend it to anyone looking to expand their understanding. "
          "The examples used are very relatable, and the writing style is engaging. "
          "Overall, a must-read for enthusiasts!",
      "image": "assets/slider/Harry.jpeg",
    },
    {
      "bookName": "Book Two",
      "authorName": "Author Two",
      "criticName": "Critic Two",
      "rating": "5",
      "review": "An incredible journey through the author's mind. The storytelling is gripping and emotional. "
          "A book that will stay with you long after you've finished reading.",
      "image": "assets/slider/memory.jpeg",

    },
    // Add more reviews as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_circle_left_outlined,
            color: blue,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ReviewCard(
            bookName: review["bookName"]?? "Unknown Book",
            authorName: review["authorName"]?? "Unknown Author",
            criticName: review["criticName"]?? "Unknown Critic",
            rating: review["rating"] ?? "0",
            reviewText: review["review"]?? "No review available",
            bookImage: review["image"]?? "",
          );
        },
      ),
    );
  }
}

// New ReviewCard widget to display each review
class ReviewCard extends StatelessWidget {
  final String bookName;
  final String authorName;
  final String criticName;
  final String rating;
  final String reviewText;
  final String bookImage;

  const ReviewCard({
    required this.bookName,
    required this.authorName,
    required this.criticName,
    required this.rating,
    required this.reviewText,
    required this.bookImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      margin: EdgeInsets.symmetric(vertical: 10), // Add margin for spacing between cards
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(0, 0),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    bookImage,
                    height: 90,
                    width: 70,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookName,
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      authorName,
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "Reviewer Name $criticName",
                      style: TextStyle(fontSize: 17),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        SizedBox(width: 8),
                        Text(rating, style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ExpansionTile(
              title: Text(
                "Read Review",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: [
                      Text(
                        reviewText,
                        style: TextStyle(fontSize: 14),
                      ),
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
