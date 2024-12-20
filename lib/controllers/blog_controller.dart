import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blog/constants/blog_constant.dart';
import 'package:blog/models/blog_model.dart';
import 'package:blog/services/blog_services.dart';

final BlogServices blogServices = BlogServices();

final blogsProvider = StateNotifierProvider<BlogsNotifier, BlogsState>((ref) => BlogsNotifier());

class BlogsNotifier extends StateNotifier<BlogsState> { BlogsNotifier() : super(InitialBlogsState(isloading: true));

  List<Blog> blogsList = [];

  void fetchBlogs() async {
    try {
      List<Blog> blogs = await blogServices.getBlogs();
      blogsList = blogs;
      state = BlogsLoadedState(blogs: blogs, isloading: false);
    } catch (e) {
      state = ErrorBlogsState(message: e.toString(), isloading: false);
    }
  }
}

final addBlogsProvider = StateNotifierProvider<AddBlogsNotifier, AddBlogsState>((ref) => AddBlogsNotifier(ref));

class AddBlogsNotifier extends StateNotifier<AddBlogsState> {
  final Ref ref;
  AddBlogsNotifier(this.ref) : super(LoadingAddBlogsState(isloading: true));

  Future<void> addBlogs(Blog data) async {
    try {
      Map<String, Object> response = await blogServices.addBlog(data);
      if (response['status'] == true) {
        ref.read(blogsProvider.notifier).fetchBlogs();
        state = LoadedAddBlogsState(message: response['data'].toString(), isloading: false);
      } else {
        state = ErrorAddBlogsState(message: response['data'].toString(), isloading: false);
      }
    } catch (e) {
      state = ErrorAddBlogsState(message: e.toString(), isloading: false);
    }
  }
}

final updateBlogsProvider =StateNotifierProvider<UpdateBlogsNotifier, UpdateBlogstate>((ref) => UpdateBlogsNotifier(ref));

class UpdateBlogsNotifier extends StateNotifier<UpdateBlogstate> {
  final Ref ref;
  UpdateBlogsNotifier(this.ref): super(LoadingUpdateBlogstate(isloading: true));

  Future<void> updateBlogs(id,data) async {
    try {
      Map<String, Object> response = await blogServices.updateBlog(id,data);

      if (response['status'] == true) {
        ref.read(blogsProvider.notifier).fetchBlogs();
        state = LoadedUpdateBlogstate(message: response['data'].toString(), isloading: false);
      } else {
        state = ErrorUpdateBlogstate(message: response['data'].toString(), isloading: false);
      }
    } catch (e) {
      state = ErrorUpdateBlogstate(message: e.toString(), isloading: false);
    }
  }
}

final deleteBlogsProvider =StateNotifierProvider<DeleteBlogsNotifier, DeleteBlogstate>((ref) => DeleteBlogsNotifier(ref));

class DeleteBlogsNotifier extends StateNotifier<DeleteBlogstate> {
  final Ref ref;
  DeleteBlogsNotifier(this.ref) : super(LoadingDeleteBlogstate(isloading: true));

  Future<void> deleteBlogs(id) async {
    try {
      Map<String, Object> response = await blogServices.deleteBlog(id);

      if (response['status'] == true) {
        ref.read(blogsProvider.notifier).fetchBlogs();
        state = LoadedDeleteBlogstate(message: response['data'].toString(), isloading: false);
      } else {
        state = ErrorDeleteBlogstate(message: response['data'].toString(), isloading: false);
      }
    } catch (e) {
      state = ErrorDeleteBlogstate(message: e.toString(), isloading: false);
    }
  }
}
