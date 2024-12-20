import 'dart:convert' as convert;
import 'package:blog/models/blog_model.dart';
import 'package:http/http.dart' as http;

class BlogServices {
  static const String _baseUrl ='https://67641bba17ec5852caeb3801.mockapi.io/blog';

  Future<List<Blog>> getBlogs() async {
    const String endPoint = "/blog";
    List<Blog> blogs = [];

    try {
      Uri blogUri = Uri.parse('$_baseUrl$endPoint');
      http.Response response = await http.get(blogUri);
      if (response.statusCode == 200) {
        List<dynamic> blogList = convert.jsonDecode(response.body);
        for (var blogItem in blogList) {
          Blog blog = Blog.fromMap(blogItem);
          blogs.add(blog);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return blogs;
  }

  Future<Map<String, Object>> addBlog(Blog data) async {
    const String endPoint = "/blog";
    try {
      Uri blogUri = Uri.parse('$_baseUrl$endPoint');
      http.Response response = await http.post(blogUri,headers: {'Content-Type': 'application/json'},body: convert.jsonEncode({ "blogName": data.blogName,'auther': data.auther,'content': data.content,'createdAt': data.createdAt}));

      if (response.statusCode == 201) {
        return {"status": true, "data": 'Blog is created'};
      } else {
        throw Exception('Failed to add blog!');
      }
    } catch (err) {
      return {"status": false, "data": err.toString()};
    }
  }

  updateBlog(id, data) async {
    String endPoint = "/blog/$id";
    try {
      Uri blogUri = Uri.parse('$_baseUrl$endPoint');
      http.Response response = await http.put(blogUri,headers: { 'Content-Type': 'application/json'},body: convert.jsonEncode({"blogName": data["blogName"],'auther': data['auther'],'content': data['content']}));

      if (response.statusCode == 200) {
        return {"status": true, "data": 'Blog updated!'};
      } else {
        throw Exception('Failed to update blog!');
      }
    } catch (err) {
      return {"status": false, "data": err.toString()};
    }
  }

  deleteBlog(id) async {
    String endPoint = "/blog/$id";
    try {
      Uri blogUri = Uri.parse('$_baseUrl$endPoint');
      http.Response response = await http.delete(blogUri);

      if (response.statusCode == 200) {
        return {"status": true, "data": 'Blog deleted!'};
      } else {
        throw Exception('Failed to delete blog!');
      }
    } catch (err) {
      return {"status": false, "data": err.toString()};
    }
  }
}
