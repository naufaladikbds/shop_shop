import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_shop/providers/auth_provider.dart';
import 'package:shop_shop/screens/products_overview_screen.dart';
import 'package:shop_shop/widgets/custom_drawer.dart';
import 'package:shop_shop/widgets/custom_text_form_field.dart';

enum AuthMode { signUp, login }

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  var currentAuthMode = AuthMode.login;

  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Size> heightAnimation;
  late Animation<double> opacityAnimation;
  late Animation<Offset> slideAnimation;

  var emailCtrl = TextEditingController(text: 'naufaladi1000@gmail.com');
  var passCtrl = TextEditingController(text: '123123');
  var verifyPassCtrl = TextEditingController(text: '123123');

  String? emailValidator(String? input) {
    if (input == null || input.isEmpty) {
      return 'Please enter your e-mail address';
    } else if (!input.contains('co') ||
        !input.contains('@') ||
        !input.contains('.')) {
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
  void initState() {
    _controller = AnimationController(
      vsync: this,
      reverseDuration: Duration(milliseconds: 200),
      duration: Duration(milliseconds: 300),
    );

    heightAnimation = Tween<Size>(
      begin: Size(double.infinity, 0),
      end: Size(double.infinity, 60),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.4),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    heightAnimation.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    print('this shit buiolds again');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.grey[200]!,
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
                  color: Colors.grey[800],
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
                            AnimatedBuilder(
                              animation: heightAnimation,
                              builder: (context, child) {
                                return Container(
                                  height: heightAnimation.value.height,
                                  child: heightAnimation.value.height > 20
                                      ? CustomTextFormField(
                                          labelText: 'Verify Password',
                                          controller: verifyPassCtrl,
                                          validator: verifyPasswordValidator,
                                          obscureText: true,
                                        )
                                      : Container(),
                                );
                              },
                            )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  StatefulBuilder(
                    builder: (context, childSetState) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: currentAuthMode == AuthMode.signUp
                              ? Colors.grey[800]
                              : Colors.amber,
                          fixedSize: Size(100, 35),
                          padding: EdgeInsets.only(
                            top: 16,
                            bottom: 16,
                            right: 20,
                            left: 20,
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                childSetState(() {
                                  isLoading = true;
                                });

                                if (formKey.currentState!.validate()) {
                                  try {
                                    if (currentAuthMode == AuthMode.signUp) {
                                      try {
                                        await authProvider
                                            .signUp(
                                          emailCtrl.text,
                                          passCtrl.text,
                                        )
                                            .then((signUpSuccess) {
                                          if (signUpSuccess) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Signup Success, please login with your newly created account',
                                                ),
                                              ),
                                            );
                                          }
                                        });
                                      } catch (e) {
                                        showAuthErrorDialog(
                                            'Error Signing Up', e);
                                      }
                                    }
                                    if (currentAuthMode == AuthMode.login) {
                                      await authProvider
                                          .login(emailCtrl.text, passCtrl.text)
                                          .then((_) {
                                        Navigator.pushReplacementNamed(context,
                                            ProductsOverviewScreen.routeName);
                                      });
                                    }
                                  } catch (e) {
                                    showAuthErrorDialog('Error', e);
                                  }
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
                                  color: currentAuthMode == AuthMode.login
                                      ? Colors.grey[700]
                                      : Colors.amber,
                                ),
                              ),
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            FadeTransition(
              opacity: opacityAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('Welcome!'),
                ),
              ),
            ),
            SizedBox(height: 80),
            TextButton(
              onPressed: () async {
                if (currentAuthMode == AuthMode.login) {
                  setState(() {
                    currentAuthMode = AuthMode.signUp;
                  });
                  _controller.forward();
                } else {
                  await _controller.reverse();
                  setState(() {
                    currentAuthMode = AuthMode.login;
                  });
                }
              },
              child: Text(
                currentAuthMode == AuthMode.login
                    ? 'or sign up instead'
                    : 'or login instead',
                style: TextStyle(
                  color: Colors.amber[600],
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAuthErrorDialog(String errorTitle, Object e) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorTitle),
          content: Text('$e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
