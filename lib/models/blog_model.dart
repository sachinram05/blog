class Blog {
  Blog({this.id, required this.blogName,required this.auther,required this.content,required this.createdAt});

  final String? id;
  final String blogName;
  final String auther;
  final String content;
  final String createdAt;

  factory Blog.fromMap(Map<dynamic, dynamic> map) {
    return Blog(id: map['id'] as String, blogName: map['blogName'] as String,auther: map['auther'] as String, content: map['content'] as String,createdAt: map['createdAt'] as String);
  }
 
}
