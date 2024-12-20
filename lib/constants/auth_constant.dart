import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class LoadingAuthState extends AuthState {
  LoadingAuthState({required this.isLoading});
  final bool isLoading;
}

class LoadedAuthState extends AuthState {
  LoadedAuthState({required this.message, required this.isLoading});
  final String message;
  final bool isLoading;
}

class ErrorAuthState extends AuthState {
  ErrorAuthState({required this.message, required this.isLoading});
  final String message;
  final bool isLoading;
}
