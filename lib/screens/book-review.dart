import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../commons/colors.dart';

class BookReview extends StatefulWidget {
  const BookReview({super.key});

  @override
  State<BookReview> createState() => _BookReviewState();
}

class _BookReviewState extends State<BookReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGround,
      appBar: AppBar(
        backgroundColor: backGround,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined, color: blue,)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 300,
                width: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: backGround,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0, 2),
                      blurRadius: 4
                    )
                  ]

                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset('assets/slider/Harry.jpeg', height: 200,width: 210,)
                    ),
                    SizedBox(height: 20,),
                    Text('Harry Potter And The Cursed Child', style: TextStyle(
                      fontSize: 16,
                      color:blue,
                    ),),
                    Text('Debie Berny', style: TextStyle(fontSize: 15, color: Colors.grey[400]),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: double.infinity,
                  height: 354,
                  decoration: BoxDecoration(
                      color: Color(0xFFECE9E9)
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: 50,
                            width: 320,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child:RatingBar.builder(
                                minRating: 1,
                                itemPadding: EdgeInsets.symmetric(horizontal:10),
                                itemSize: 40,
                                updateOnDrag: true,
                                itemBuilder: (context, _)=> Icon(Icons.star, color: Colors.amber,),
                                onRatingUpdate: (rating){
                                })
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
