import 'package:bookstore/commons/colors.dart';
import 'package:flutter/material.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_circle_left_outlined, color: blue,)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text('After deleting your account:', style: TextStyle(fontSize: 20),),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10,left: 10, right: 10),
            child: Text('You can reactivate your account anytime within 60 days.After 60 days the account will be permanently deleted along with the associated personal data.',
            style: TextStyle(fontSize: 16,),
            maxLines: 4,
            ),
          ),
          SizedBox(height: 25,),
          Center(
            child: InkWell(
              onTap: (){},
              child: Container(
                height: 60,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red, width: 2)
                ),
                child: Center(child: Text('Delete Account',
                  style: TextStyle(color: Colors.red,fontSize: 18),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
