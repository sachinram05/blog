import 'package:blog/models/user_model.dart';
import 'package:blog/services/auth_services.dart';
import 'package:blog/constants/auth_constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final AuthServices authServices = AuthServices();

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AuthState> { AuthNotifier() : super(LoadingAuthState(isLoading: true));

  Future<void> loginUser(data) async {
    try {
      Map<String, Object> response = await authServices.loginUser(data);

      if (response['status'] == true) {
        state = LoadedAuthState(message: 'Welcome to my blogs', isLoading: false);
      } else {
        state = ErrorAuthState( message: response['message'].toString(), isLoading: false);
      }
    } catch (err) {
      state = ErrorAuthState(message: err.toString(), isLoading: false);
    }
  }

  Future<void> registerUser(User data) async {
    try {
      Map<String, Object> response = await authServices.registerUser(data);

      if (response['status'] == true) {
        state = LoadedAuthState(message: response['message'].toString(), isLoading: false);
      } else {
        state = ErrorAuthState(message: response['message'].toString(), isLoading: false);
      }
    } catch (err) {
      state = ErrorAuthState(message: err.toString(), isLoading: false);
    }
  }
}
