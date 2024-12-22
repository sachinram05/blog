import 'dart:math';

import 'package:blog/custom_widgets/custom_card.dart';
import 'package:blog/custom_widgets/custom_gradient.dart';
import 'package:blog/custom_widgets/custom_input.dart';
import 'package:blog/models/user_model.dart';
import 'package:blog/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blog/constants/auth_constant.dart';
import 'package:blog/controllers/auth_controller.dart';

class Auth extends ConsumerStatefulWidget {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  final authFormKey = GlobalKey<FormState>();
  bool isloginMode = true;
  bool isLoading = false;
  String enteredName = '';
  String enteredEmail = '';
  String enteredPassword = '';
  String enteredConfPassword = '';

  String generateDummyToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void authFormHandler() async {
    try {
      if (authFormKey.currentState!.validate()) {
        authFormKey.currentState!.save();
        setState(() {isLoading = true;});

        if (isloginMode) {
          await ref.read(authProvider.notifier).loginUser({ 'email': enteredEmail,'password': enteredPassword,});
        } else {

          if (enteredPassword != enteredConfPassword) { throw Exception('Password must be same');}

          await ref.read(authProvider.notifier).registerUser(User(name: enteredName,password: enteredPassword,email: enteredEmail,token: generateDummyToken()));
        }

        final authState = ref.read(authProvider);

        if (authState is LoadingAuthState) { setState(() { isLoading = authState.isLoading;});}
        if (authState is LoadedAuthState) {setState(() { isLoading = authState.isLoading;});
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authState.message)));

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Home()));
        }

        if (authState is ErrorAuthState) {
          setState(() {isLoading = authState.isLoading;});

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(authState.message)));
        }
      }
    } catch (e) {
      setState(() {isLoading = false;});
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                child: CustomCard(formWidget:  Form(
                          key: authFormKey,
                          child: Column(
                            children: [
                              Text(
                                isloginMode ? "Log In" : "Sign Up",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                isloginMode
                                    ? "Enter credentials to login"
                                    : "Create an account to continue",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              if (!isloginMode)
                                CustomInput(
                                    labelName: "Name",
                                    textFormField: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Enter name'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length < 3) {
                                          return "Please enter at least 3 characters.";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        setState(() {
                                          enteredName = newValue!;
                                        });
                                      },
                                    )),
                              const SizedBox(height: 10),
                              CustomInput(
                                  labelName: "Email",
                                  textFormField: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Enter email'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty ||
                                          !value.contains('@')) {
                                        return 'Please enter valid email address';
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      setState(() {
                                        enteredEmail = newValue!;
                                      });
                                    },
                                  )),
                              const SizedBox(height: 10),
                              CustomInput(
                                  labelName: "Password",
                                  textFormField: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Enter password',
                                        suffixIcon: Icon(Icons.remove_red_eye)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value.trim().length < 6) {
                                        return "Please enter at least 6 characters.";
                                      }
                                      return null;
                                    },
                                    onSaved: (newValue) {
                                      setState(() {
                                        enteredPassword = newValue!;
                                      });
                                    },
                                  )),
                              const SizedBox(height: 10),
                              if (!isloginMode)
                                CustomInput(
                                    labelName: "Confirm Password",
                                    textFormField: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Re-enter password',
                                          suffixIcon:
                                              Icon(Icons.remove_red_eye)),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length < 6) {
                                          return "Please enter at least 6 characters.";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        setState(() {
                                          enteredConfPassword = newValue!;
                                        });
                                      },
                                    )),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                 width: MediaQuery.of(context).size.width * 1,
                              child: 
                              isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: authFormHandler,
                                      child: Text(
                                        isloginMode ? "Log In" : "Sign Up",
                                      ))),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(isloginMode
                                        ? "Don't have an Account ?"
                                        : "Already have an Account ?"),
                                    TextButton(
                                        onPressed: () {
                                          authFormKey.currentState!.reset();
                                          setState(() {
                                            enteredName = '';
                                            enteredEmail = '';
                                            enteredPassword = '';
                                            enteredConfPassword = '';
                                            isloginMode = !isloginMode;
                                          });
                                        },
                                        child: Text(
                                            isloginMode ? "Sign up" : "Log in"))
                                  ])
                            ],
                          ),
                        )))
              ],
            ),
          ))),
    ));
  }
}
