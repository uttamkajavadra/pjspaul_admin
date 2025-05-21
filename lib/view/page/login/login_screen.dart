import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/route/app_routes.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/page/main/main_screen.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginForm = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 20.0
                  )
                ]
          ),
          child: Form(
            key: loginForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                Text("Welcome", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),),
                CustomTextFormField(
                  controller: usernameController,
                  labelText: "Username", 
                  validator: (value)=>Validator.validateNull("Username", value)),
                CustomTextFormField(
                  controller: passwordController,
                  labelText: "Password", 
                  validator: (value)=>Validator.validateNull("Password", value)),
                SizedBox(
                  height: 42,
                  child: CustomElevatedButton(
                    onPressed: (){
                      if(loginForm.currentState!.validate()){
                        if(usernameController.text == "pjspaulministry@gmail.com" && passwordController.text == "PjsP@u1"){
                          Get.toNamed(AppRoutes.main);
                        } else {
                          var snackBar = SnackBar(content: Text('Invalid Credential!'), backgroundColor: const Color.fromARGB(255, 242, 22, 6),);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    }, 
                    buttonText: "Login"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}