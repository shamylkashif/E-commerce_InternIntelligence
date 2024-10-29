import 'package:bookstore/read_review.dart';
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
            child: Icon(Icons.arrow_circle_left_outlined, color: blue,)),
      ),
      body: SingleChildScrollView(
         child: Column(
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/slider/Harry.jpeg',
                      height: 200,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 260),
                      child: Text('Give Stars',
                        style:TextStyle(fontSize: 16,fontWeight: FontWeight.bold) ,),
                    ),
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                              height: 50,
                              width: 320,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child:Padding(
                                padding: const EdgeInsets.only(top: 4, left: 8),
                                child: RatingBar.builder(
                                    minRating: 1,
                                    itemPadding: EdgeInsets.symmetric(horizontal:10),
                                    itemSize: 40,
                                    updateOnDrag: true,
                                    itemBuilder: (context, _)=> Icon(Icons.star, color: Colors.amber,),
                                    onRatingUpdate: (rating){}
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20,right: 210),
                          child: Text('Write Your Review',
                            style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16) ,),
                        ),
                    SizedBox(height: 8,),
                    Container(
                      height: 150,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Write Book Review",
                            hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: blue),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            )
                        ),
                        maxLines: null,
                        minLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                     SizedBox(height: 15,),
                     GestureDetector(
                       onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>ReadReview()));
                       },
                       child: Container(
                         height: 50,
                         width: 350,
                         decoration: BoxDecoration(
                           border: Border.all(color: blue),
                           color: yellow,
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Center(
                            child: Text('Save Review',
                             style:TextStyle(color: blue, fontSize: 18) ,),
                         ),
                       ),
                     ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
