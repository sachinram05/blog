import 'package:blog/views/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  bool isloading = false;

  Future<void> getLoggedUserDetails() async {
    setState(() {isloading = true;});
    final userData = await SharedPreferences.getInstance();
    setState(() {
      name = userData.getString('name') as String;
      email = userData.getString('email') as String;
    });
    setState(() {isloading = false;});
  }

  Future<void> logoutUser() async {
    final userData = await SharedPreferences.getInstance();
    await userData.remove('token');
    await userData.remove('email');
    await userData.remove('name');
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const Auth()));
  }


  @override
  void initState() {
    super.initState();
    getLoggedUserDetails();
  }


  @override
  Widget build(BuildContext context) {
    return isloading
    ? const Center(child: CircularProgressIndicator())
    : Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(name, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 10),
          Text(email, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 40),
          TextButton(
              onPressed: logoutUser,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout_rounded, size: 24, color: Colors.red[400]),
                  const Text(' LogOut'),
                ],
              ))
        ],
      ),
    );
  }
}
