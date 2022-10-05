import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';
import 'package:shop_shop/widgets/custom_text_form_field.dart';

enum AuthMode { signUp, login }

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var currentAuthMode = AuthMode.login;

  bool isLoading = false;

  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var verifyPassCtrl = TextEditingController();

  String? emailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Please enter your e-mail address';
    } else if (!input.contains(RegExp(r'[@(.co)]'))) {
      return 'Please enter a valid e-mail address';
    } else {
      return null;
    }
  }

  String? passwordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Please enter your password';
    } else {
      return null;
    }
  }

  String? verifyPasswordValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Please verify your password';
    } else if (input != passCtrl.text) {
      return 'Input does not match the password';
    } else {
      return null;
    }
  }

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print('login');

    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black87,
                Colors.amber[800]!,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.85, 1]),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'E-Shop',
                style: TextStyle(
                  color: Colors.grey[200],
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 3,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0.1,
                    color: Colors.grey[500]!,
                  ),
                ],
              ),
              width: double.infinity,
              margin: EdgeInsets.only(
                left: 40,
                right: 40,
                bottom: 100,
              ),
              padding: EdgeInsets.only(top: 15, bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            labelText: 'Email',
                            controller: emailCtrl,
                            validator: emailValidator,
                          ),
                          CustomTextFormField(
                            labelText: 'Password',
                            controller: passCtrl,
                            validator: passwordValidator,
                            obscureText: true,
                          ),
                          if (currentAuthMode == AuthMode.signUp)
                            CustomTextFormField(
                              labelText: 'Verify Password',
                              controller: verifyPassCtrl,
                              validator: verifyPasswordValidator,
                              obscureText: true,
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  StatefulBuilder(
                    builder: (context, childSetState) {
                      print(isLoading);

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(100, 35),
                          padding: EdgeInsets.only(
                            top: 16,
                            bottom: 16,
                            right: 20,
                            left: 20,
                          ),
                        ),
                        onPressed: () async {
                          childSetState(() {
                            isLoading = true;
                          });

                          if (formKey.currentState!.validate()) {
                            await Future.delayed(Duration(seconds: 1), () {
                              authProvider.signUp(
                                  emailCtrl.text, passCtrl.text);
                            });
                            print('success');
                          }

                          childSetState(() {
                            isLoading = false;
                          });
                        },
                        child: isLoading
                            ? SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  color: Colors.grey[800],
                                  strokeWidth: 1.5,
                                ),
                              )
                            : Text(
                                currentAuthMode == AuthMode.login
                                    ? 'Login'
                                    : 'Sign Up',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[700],
                                ),
                              ),
                      );
                    },
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                currentAuthMode = currentAuthMode == AuthMode.login
                    ? AuthMode.signUp
                    : AuthMode.login;
                setState(() {});
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              child: Text(
                currentAuthMode == AuthMode.login
                    ? 'or sign up instead'
                    : 'or login instead',
                style: TextStyle(
                  color: Colors.amber[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
