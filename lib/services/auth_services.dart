import 'dart:convert' as convert;

import 'package:blog/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static const String _baseUrl = 'https://67641bba17ec5852caeb3801.mockapi.io/blog';

  Future<Map<String, Object>> loginUser(data) async {
    const String endPoint = "/users";
    List<User> allUsers = [];
    try {
      Uri loginUri = Uri.parse('$_baseUrl$endPoint');
      http.Response allUsersRes = await http.get(loginUri);

      List<dynamic> allUsersList = convert.jsonDecode(allUsersRes.body);
      for (var user in allUsersList) {
        User userdata = User.fromMap(user);
        allUsers.add(userdata);
      }
      if (allUsers.isNotEmpty) {
        User? currentUser = allUsers.firstWhere(
            (user) => user.email == data['email'],
            orElse: () => User(name: 'notFound', password: 'notFound',email: 'notFoundbyApp',token: 'notFound'));

        if (currentUser.email == 'notFoundbyApp' || currentUser.email != data['email'] || currentUser.password != data['password']) {
          return {"status": false, "message": 'Please enter valid credentials'};
        } else {
          final saveUser = await SharedPreferences.getInstance();
          await saveUser.setString('token', currentUser.token);
          await saveUser.setString('name', currentUser.name);
          await saveUser.setString('email', currentUser.email);
          return {"status": true, "message": 'login success!'};
        }
      } else {
        return {"status": false, "message": 'Please enter valid credentials'};
      }
    } catch (err) {
      return {"status": false, "message": err.toString()};
    }
  }

  Future<Map<String, Object>> registerUser(User data) async {
    const String endPoint = "/users";
    List<User> allUsers = [];
    try {
      Uri loginUri = Uri.parse('$_baseUrl$endPoint');
      http.Response allUsersRes = await http.get(loginUri);
      List<dynamic> allUsersList = convert.jsonDecode(allUsersRes.body);
      for (var user in allUsersList) {
        User userdata = User.fromMap(user);
        allUsers.add(userdata);
      }
      if (allUsers.isNotEmpty) {
        final checkUser = allUsers.any((user) => user.email == data.email);
        if (checkUser) {
          return {"status": false, "message": "email already registered"};
        }
      }
      
      http.Response response = await http.post(loginUri, headers: { 'Content-Type': 'application/json', }, body: convert.jsonEncode({"name":data.name,'email':data.email,'password':data.password,'token':data.token}));
      if (response.statusCode == 201) {
        final body = convert.json.decode(response.body);
        final saveUser = await SharedPreferences.getInstance();
        await saveUser.setString('token', body['token']);
        await saveUser.setString('name', body['name']);
        await saveUser.setString('email', body['email']);
        return {"status": true, "message": 'user registered success!'};
      } else {
        return {"status": false, "message": "user not registered"};
      }
    } catch (err) {
      return {"status": false, "message": err.toString()};
    }
  }
}
