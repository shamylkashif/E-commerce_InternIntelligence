import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/seller-info.dart';
import 'package:flutter/material.dart';

import 'my_chat.dart';

class BookDescription extends StatefulWidget {
  const BookDescription({super.key});

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
                child: Image.asset('assets/slider/Harry.jpeg', height: 200,width: 210,)
            ),
          SizedBox(height: 20,),
          Text('Harry Potter And The Cursed Child', style: TextStyle(
             fontSize: 16,
             color:blue,
          ),),
          Text('Debie Berny', style: TextStyle(fontSize: 15, color: Colors.grey[400]),),
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
                        child: Text('Synopsis', style: TextStyle(fontSize: 20,color: Colors.black),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8,left: 5,right: 5),
                        child: Text('It follows Albus Severus Potter, the son of Harry Potter,'
                            ' who is now Head of the Department of Magical Law Enforcement at the Ministry of Magic. '
                            'When Albus arrives at Hogwarts, he gets sorted into Slytherin, '
                            'and fails to live up to his father legacy, making him resentful of his father.',
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
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyChat()));
                              },
                              child: Text('Book Review')
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
                            Text('262', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
                            Text('Number of pages', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Eng', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
                            Text('Language', style: TextStyle(fontSize: 12, color: Colors.grey),),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Good', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellow[600]),),
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
