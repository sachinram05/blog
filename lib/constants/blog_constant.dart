import 'package:flutter/material.dart';
import 'package:blog/models/blog_model.dart';

@immutable
abstract class BlogsState {}

class InitialBlogsState extends BlogsState {
  InitialBlogsState({required this.isloading});
  final bool isloading;
}

class BlogsLoadedState extends BlogsState {
  BlogsLoadedState({required this.blogs, required this.isloading});
  final List<Blog> blogs;
  final bool isloading;
}

class ErrorBlogsState extends BlogsState {
  ErrorBlogsState({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

@immutable
abstract class AddBlogsState {}

class LoadingAddBlogsState extends AddBlogsState {
  LoadingAddBlogsState({required this.isloading});
  final bool isloading;
}

class LoadedAddBlogsState extends AddBlogsState {
  LoadedAddBlogsState({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

class ErrorAddBlogsState extends AddBlogsState {
  ErrorAddBlogsState({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

// updateBlog
@immutable
abstract class UpdateBlogstate {}

class LoadingUpdateBlogstate extends UpdateBlogstate {
  LoadingUpdateBlogstate({required this.isloading});
  final bool isloading;
}

class LoadedUpdateBlogstate extends UpdateBlogstate {
  LoadedUpdateBlogstate({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

class ErrorUpdateBlogstate extends UpdateBlogstate {
  ErrorUpdateBlogstate({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

// deleteBlog
@immutable
abstract class DeleteBlogstate {}

class LoadingDeleteBlogstate extends DeleteBlogstate {
  LoadingDeleteBlogstate({required this.isloading});
  final bool isloading;
}

class LoadedDeleteBlogstate extends DeleteBlogstate {
  LoadedDeleteBlogstate({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}

class ErrorDeleteBlogstate extends DeleteBlogstate {
  ErrorDeleteBlogstate({required this.message, required this.isloading});
  final String message;
  final bool isloading;
}
