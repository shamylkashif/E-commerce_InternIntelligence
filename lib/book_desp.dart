import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/book-review.dart';
import 'package:bookstore/screens/seller-info.dart';
import 'package:flutter/material.dart';

class BookDescription extends StatefulWidget {
  final Map<String, dynamic> book; // Declare book variable

  const BookDescription({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDescription> createState() => _BookDescriptionState();
}

class _BookDescriptionState extends State<BookDescription> {



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
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
            Align(
                alignment: Alignment.center,
                child:
                Image.network(widget.book['imageUrl']?? "",
                  height: 200,
                  width: 210,
                  fit: BoxFit.cover,
                )
            ),
          SizedBox(height: 20,),
          Text(widget.book['title']?? "Unknown title", style: TextStyle(
             fontSize: 16,
             color:blue,
          ),),
          Text(widget.book['author']?? "Unknown author", style: TextStyle(fontSize: 15, color: Colors.grey[400]),),
          SizedBox(height: 15,),
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: double.infinity,
                  height: 355,
                  decoration: BoxDecoration(
                      color: Color(0xFFECE9E9)
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 62),
                        child: Text(
                          'Synopsis',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 5,right: 5),
                        child: Text( widget.book['description']?? "Description not provided",
                        textAlign:TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 35,),
                      Padding(
                        padding: const EdgeInsets.only(left: 45, right: 45),
                        child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          TextButton(
                              style:TextButton.styleFrom(
                                  foregroundColor: blue,
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ) ,
                              onPressed: (){
                                showModalBottomSheet(
                                    context: context,
                                    showDragHandle: true,
                                    isDismissible: true,
                                    builder: (context){
                                      return SellerInformation();
                                    }
                                );
                              },

                              child: Text('Seller Information')
                          ),
                          TextButton(
                              style:TextButton.styleFrom(
                                  foregroundColor: blue,
                                  backgroundColor: yellow,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ) ,
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>BookReview()));
                              },
                              child: Text('Write Review')
                          )
                        ],),
                      ),


                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 70,
                    width: 320,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('4.1', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600],fontSize: 14),),
                            Text('Rating', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(widget.book['pages']?? "", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
                            Text('Number of pages', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(widget.book['language']??"", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
                            Text('Language', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(widget.book['condition']??"", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
                            Text('Condition', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                      ],
                    )
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }
}
