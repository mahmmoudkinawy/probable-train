import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  bool isVisable = true;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _submitData() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final phoneNumber = phoneNumberController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final response = await http.post(
      Uri.parse('http://pets-care.somee.com/api/account/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
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
        msg: "Email is already taken.",
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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                      height: 180,
                      width: 180,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xEEEEEEFF)),
                      child: Image.asset('assets/2.jpg', fit: BoxFit.cover)),
                ),
                const SizedBox(height: 20),
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
                        controller: firstNameController,
                        name: 'firstName',
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
                          labelText: ' First name',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: GoogleFonts.vazirmatn().copyWith(
                            fontSize: 14,
                            color: const Color(0xffC2C2C2),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'First Name is required.'),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                        controller: lastNameController,
                        name: 'lastName',
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
                          labelText: 'Second name',
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: GoogleFonts.vazirmatn().copyWith(
                            fontSize: 14,
                            color: const Color(0xffC2C2C2),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Last Name is required.'),
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                        controller: phoneNumberController,
                        name: 'phoneNumber',
                        decoration: InputDecoration(
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15.0),
                          // ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/svgs/phone.svg',
                              color: const Color(0xff8F8F8F),
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                              matchTextDirection: true,
                            ),
                          ),
                          labelText: ' Phone Number',
                          hintTextDirection: TextDirection.ltr,
                          hintStyle: GoogleFonts.vazirmatn().copyWith(
                            fontSize: 14,
                            color: const Color(0xffC2C2C2),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Phone Number is required.'),
                          FormBuilderValidators.match(
                            r"^01[0-2,5]{1}[0-9]{8}$",
                            errorText: "Enter a valid Egyptian Phone Number.",
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                        controller: emailController,
                        name: 'email',
                        decoration: InputDecoration(
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15.0),
                          // ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/svgs/email.svg',
                              color: const Color(0xff8F8F8F),
                              height: 24,
                              width: 24,
                              fit: BoxFit.contain,
                              matchTextDirection: true,
                            ),
                          ),
                          labelText: ' Email',
                          hintTextDirection: TextDirection.rtl,
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
                const SizedBox(height: 15),
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
                        controller: passwordController,
                        name: 'password',
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
                          hintTextDirection: TextDirection.rtl,
                          hintStyle: GoogleFonts.vazirmatn().copyWith(
                            fontSize: 14,
                            color: const Color(0xffC2C2C2),
                          ),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: 'Password is required.'),
                          FormBuilderValidators.minLength(8),
                          FormBuilderValidators.match(
                              r"(?=^.{6,10}$)(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&amp;*()_+}{&quot;:;'?/&gt;.&lt;,])(?!.*\s).*$",
                              errorText: "Please write more complex password.")
                        ]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Container(
                          height: 55,
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () async {
                              print(
                                  'Is form valid ${formKey.currentState!.validate()}');
                              formKey.currentState!.save();
                              if (formKey.currentState!.validate()) {
                                _submitData();
                                // Navigator.pushNamed(context, '/');
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22.0),
                                    side: const BorderSide(
                                      color: Colors.black,
                                    )),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(15),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  ' Register',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
