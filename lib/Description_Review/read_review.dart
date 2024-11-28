
import 'package:bookstore/Dashboards/home-pg.dart';
import 'package:bookstore/commons/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadReview extends StatefulWidget {
  const ReadReview({super.key});

  @override
  State<ReadReview> createState() => _ReadReviewState();
}

class _ReadReviewState extends State<ReadReview> {
  // Sample reviews data
  List<Map<String, dynamic>> reviews = [];



  @override
  void initState() {
    super.initState();
    _fetchReview(); // Fetch reviews from Firestore
  }

  String limitWords(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return words.take(wordLimit).join(' ') + '...';
  }



  //Fetch data from firestore
  Future<void> _fetchReview() async {
    try{
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance.collection('ratings').get();


      //Map the review documents to list
      setState(() {
        reviews = reviewSnapshot.docs.map((doc){
          return{
            'bookName' : doc['bookName'],
            'authorName' : doc['authorName'],
            'reviewerName' : doc['reviewerName'],
            'rating' : doc['rating'].toString(),
            'review' : doc['review'],
            'bookImage' : doc['bookImage'],
          };
        }).toList();
      });


    }catch(e){
      print('Error fetching reviews: $e');
    }
  }

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
        title: Text('Read Reviews', style: TextStyle(color: blue),),
      ),
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          final review = reviews[index];
          return ReviewCard(
            bookName: review["bookName"]?? "Unknown Book",
            authorName: review["authorName"]?? "Unknown Author",
            reviewerName: review["reviewerName"]?? "Unknown Critic",
            rating: review["rating"] ?? "0",
            reviewText: review["review"]?? "No review available",
            bookImage: review["bookImage"]?? "",
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
  final String reviewerName;
  final String rating;
  final String reviewText;
  final String bookImage;

  const ReviewCard({
    required this.bookName,
    required this.authorName,
    required this.reviewerName,
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
                  child: bookImage.isNotEmpty
                      ? Image.network(
                    bookImage,
                    height: 90,
                    width: 70,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.broken_image, size: 70), // Handle image load error
                  )
                      : Icon(Icons.broken_image, size: 70), // Fallback if no image available
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      limitWords(bookName, 3),
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,

                    ),
                    Text(
                      authorName,
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "Reviewer Name: $reviewerName",
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
