import 'package:bookstore/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../commons/colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  WelcomeController welcomeController = Get.put(WelcomeController());

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:  Stack(
          children: [
            Container(
              decoration:const  BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrdImg (2).png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(MediaQuery.of(context).size.width,80.0),
                ),
              ),
              child: Stack(
                  children:[
                    Padding(
                      padding: const EdgeInsets.only(top: 30,left: 60),
                      child: Image.asset('assets/LogoWot.png',height: 240,width: 240,),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 250, left: 47),
              child: Container(
                height: 230,
                width: 265,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(4,4), // Shadow position
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 14,),
                      Container(
                        width: 400,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter First Name";
                            }
                            return null;
                          },
                          controller: welcomeController.userNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Enter UserName',
                            labelStyle: const TextStyle(color: blue,),
                            suffixIcon: const Icon(Icons.person_2, color: blue,),

                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter User Email";
                            }
                            return null;
                          },
                          controller: welcomeController.userEmailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Enter Your Email',
                            labelStyle: const TextStyle(color: blue,),
                            suffixIcon: const Icon(Icons.email, color: blue,),

                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: TextFormField(
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Your Password";
                            }else if(value.length<=5){
                              return "Password have must 6 char";
                            }
                            return null;
                          },
                          controller: welcomeController.userPasswordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: blue,),
                            suffixIcon: const Icon(Icons.password, color: blue,),
                          ),
                        ),
                      ),
                      Container(
                        width: 400,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                        child: TextFormField(
                          controller: welcomeController.userConfirmPasswordController,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Your Password";
                            }else if(value.length<=5){
                              return "Password have must 6 char";
                            }else if(welcomeController.userPasswordController.text!=welcomeController.userConfirmPasswordController.text){
                              return "your Password are miss match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            labelText: 'Confirm Password',
                            labelStyle: const TextStyle(color: blue,),
                            suffixIcon: const Icon(Icons.password_rounded, color: blue,),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 510,left: 116),
              child: GestureDetector(
                onTap: (){
                 if(_formKey.currentState!.validate()){
                   welcomeController.createUser(context: context);
                 }

                
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 5),
                  decoration:BoxDecoration(borderRadius: BorderRadius.circular(12) ,color: yellow,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ]),
                  child: const Text("Signup", style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18, color: blue,),
                  ),
                ),
              ),
            ),
            
            Obx(()=> Text("${welcomeController.errorMessage.value}",style: TextStyle(color: Colors.red),))
          ],
        ),

      ),
    );


  }
}
