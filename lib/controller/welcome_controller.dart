import 'dart:convert';

import 'package:bookstore/services/network_services.dart';
import 'package:bookstore/utils/domian.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/login-screen.dart';

class WelcomeController extends GetxController{

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();

  RxString errorMessage= ''.obs;

  Future createUser({required BuildContext context}) async {
    var requestBody = {
      "first_name": userNameController.text,
      "last_name": "${userNameController.text}_2",
      "email": userEmailController.text,
      "password": userPasswordController.text
    };

    var response =await NetworkServices.postRequest(url: MyDomain.getCreateUserAPI(),body: requestBody);
    print("response: ${response!.statusCode}");
    var body = response.body;
    switch(response.statusCode){
      case 500:
        var result = json.decode(body);
        print("response: ${result}");
        errorMessage.value = result["message"];
        break;
      case 200:
        var result = json.decode(body);
        print("response: ${result}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
    }

    return body;
  }

}

