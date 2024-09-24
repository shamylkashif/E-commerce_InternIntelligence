import 'package:bookstore/commons/colors.dart';
import 'package:bookstore/screens/login-screen.dart';
import 'package:bookstore/screens/profile_choice.dart';
import 'package:bookstore/setting.dart';
import 'package:flutter/material.dart';


class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
} 

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                },
                child: Container(
                   height: 33,
                   width: 75,
                   decoration: BoxDecoration(
                     color: yellow,
                     borderRadius: BorderRadius.circular(15)
                   ),
                  child: Center(child: Text('LogOut', style: TextStyle(color: blue, fontSize: 16),)),
                ),
            ),
          ],
        ),
        body: SingleChildScrollView(
           child: Column(
            children: [
              SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 180,
                  width: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      yellow, blue
                    ],
                      begin: const FractionalOffset(0.5, 1),
                      end: const FractionalOffset(1.0, 0.0),
                    ),
                    borderRadius: BorderRadius.circular(25),

                  ),
                  child: Column(
                    children: [
                       SizedBox(height: 16,),
                      Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(100)),
                                  image: DecorationImage(image: AssetImage('assets/p.jpg'))
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 70,left: 137),
                            height:30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),
                            child: InkWell(
                                onTap: (){
                                  showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15),
                                          bottom: Radius.circular(15)
                                        ),
                                      ),
                                      builder: (context){
                                        return ProfilePicChoice();
                                      }
                                  );                                 },
                                child: Icon(Icons.camera_alt_outlined, color: blue, size: 20,)),
                          ),
                        ],
                      ),

                      SizedBox(height: 8,),
                      Text('Clara Albert',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            height: 1.0
                        ),),
                      Text('ClaraAlbert@gmail.com',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.0
                        ),),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 20,),
              Column(
                children: [
                  EditableProfileTile(
                      title: 'Username',
                      value: 'Clara Albert',
                      icons: Icons.person),
                  EditableProfileTile(
                      title: 'Mobile Number',
                      value: '03XZ-YYYYYYY',
                      icons: Icons.phone_android),
                  EditableProfileTile(
                      title: 'Email Address',
                      value: 'claraalbert596@gmail.com',
                      icons: Icons.email),
                  EditableProfileTile(
                      title: 'Location',
                      value: 'Islamad',
                      icons: Icons.location_on),
                  ListTile(
                    leading:Icon(Icons.settings, color: blue,) ,
                    title: Text(
                      'Settings', style: TextStyle(fontSize: 14, ),
                    ),
                    trailing: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                        },
                        child: Icon(Icons.edit, color: blue,)),
                  ),
                ],
              ),
            ],
          ),
        ),
          );
  }
}


class EditableProfileTile extends StatefulWidget {
  final String title;
  final String value;
  final IconData icons;

  const EditableProfileTile({
    Key? key,
    required this.title,
    required this.value,
    required this.icons,
  }) : super(key: key)  ;

  @override
  State<EditableProfileTile> createState() => _EditableProfileTileState();
}

class _EditableProfileTileState extends State<EditableProfileTile> {

  bool isEditing = false;
  late TextEditingController _controller;
  @override

  void initState(){
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(widget.icons, color: blue),
      title: Text(widget.title, style: TextStyle(fontSize: 14)),
      subtitle: isEditing
          ? TextField(
        controller: _controller,
        autofocus: true, // Automatically focus on the text field
        decoration: InputDecoration(hintText: 'Enter ${widget.title}'),
      )
          : Text(_controller.text, style: TextStyle(fontSize: 17)),
      trailing: IconButton(
        icon: Icon(isEditing ? Icons.check : Icons.edit, color: blue),
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
          });
        },
      ),
    );
  }
}


