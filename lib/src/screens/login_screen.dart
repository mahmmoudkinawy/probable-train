import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:petscareclient/src/screens/home_screen.dart';
import 'package:petscareclient/src/screens/register_screen.dart';

import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isVisable = true;

  Future<void> _submitData() async {
    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://pets-care.somee.com/api/account/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final user = User.fromJson(data);
      saveUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Email or Password invalid.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 55),
                child: Container(
                    height: 180,
                    width: 180,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey),
                    child: Image.asset('assets/1.jpg')),
              ),
              const SizedBox(height: 30),
              FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: FormBuilderTextField(
                              name: 'email',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(15.0),
                                // ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/svgs/user.svg',
                                    color: const Color(0xff8F8F8F),
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.contain,
                                    matchTextDirection: true,
                                  ),
                                ),
                                labelText: ' Email',
                                hintStyle: GoogleFonts.vazirmatn().copyWith(
                                  fontSize: 14,
                                  color: const Color(0xffC2C2C2),
                                ),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Email is required.'),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: FormBuilderTextField(
                              name: 'password',
                              controller: passwordController,
                              obscureText: isVisable,
                              decoration: InputDecoration(
                                // enabledBorder: OutlineInputBorder(
                                //   borderRadius: BorderRadius.circular(15.0),
                                // ),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: SvgPicture.asset(
                                    'assets/svgs/password.svg',
                                    color: const Color(0xff8F8F8F),
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.contain,
                                    matchTextDirection: true,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.indigo,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isVisable = !isVisable;
                                      });
                                    }),
                                labelText: ' Password',
                                hintTextDirection: TextDirection.ltr,
                                hintStyle: GoogleFonts.vazirmatn().copyWith(
                                  fontSize: 14,
                                  color: const Color(0xffC2C2C2),
                                ),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                    errorText: 'Password is required.'),
                                FormBuilderValidators.minLength(8),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      height: 55,
                      width: 300,
                       child:LoadingBtn(
                         height: 50,
                         borderRadius: 8,
                         animate: true,
                         color: Colors.blue,
                         width: MediaQuery.of(context).size.width * 0.45,
                         loader: Container(
                           padding: const EdgeInsets.all(10),
                           width: 40,
                           height: 40,
                           child: const CircularProgressIndicator(
                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                           ),
                         ),
                         child: const Text("Login"),
                         onTap: (startLoading, stopLoading, btnState) async {
                           if (btnState == ButtonState.idle) {
                             formKey.currentState!.save();
                                 if (formKey.currentState!.validate()) {
                                   startLoading();
                                   _submitData();
                                 }
                             // call your network api
                             await Future.delayed(const Duration(seconds: 5));
                             stopLoading();
                           }
                         },
                       ),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //       shape: MaterialStateProperty.all<
                      //           RoundedRectangleBorder>(
                      //         RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(22.0),
                      //             side: const BorderSide(color: Colors.black)),
                      //       ),
                      //       padding: MaterialStateProperty.all(
                      //           const EdgeInsets.all(15))),
                      //   onPressed: () async {
                      //     formKey.currentState!.save();
                      //     if (formKey.currentState!.validate()) {
                      //       _submitData();
                      //     }
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: const [
                      //       Text(
                      //         ' Signin',
                      //         style: TextStyle(fontSize: 18),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "? don't have account",
                        style: TextStyle(color: Colors.grey),
                      )),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ));
                    },
                    child: const Text(
                      ' Register',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Container(
                color: Colors.amber,
              )
            ],
          ),
        ),
      ),
    );
  }
}
