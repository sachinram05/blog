import 'package:blog/constants/blog_constant.dart';
import 'package:blog/controllers/blog_controller.dart';
import 'package:blog/custom_widgets/custom_card.dart';
import 'package:blog/models/blog_model.dart';
import 'package:blog/views/add_edit_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Blogs extends ConsumerStatefulWidget {
  const Blogs({super.key});

  @override
  ConsumerState<Blogs> createState() => _BlogsState();
}

class _BlogsState extends ConsumerState<Blogs> {
  bool isloading = false;
  String selectedId = '';
  @override
  void initState() {
    ref.read(blogsProvider.notifier).fetchBlogs();
    super.initState();
  }

  void onDeletedHandler(id) async {
    try {
      selectedId = id.toString();
      setState(() {
        isloading = true;
        selectedId = selectedId;
      });
      await ref.read(deleteBlogsProvider.notifier).deleteBlogs(selectedId);
      final deleteState = ref.read(deleteBlogsProvider);
      if (deleteState is LoadingDeleteBlogstate) {setState(() {isloading = deleteState.isloading;});
      }
      if (deleteState is LoadedDeleteBlogstate) {
        setState(() {
          isloading = deleteState.isloading;
          selectedId = '';
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(deleteState.message)));
      }

      if (deleteState is ErrorDeleteBlogstate) {
        setState(() {
          isloading = deleteState.isloading;
          selectedId = '';
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(deleteState.message)));
      }
      setState(() {
        isloading = false;
        selectedId = '';
      });
    } catch (err) {
      setState(() {isloading = false;});
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }



  @override
  Widget build(BuildContext context) {
    BlogsState blogdataState = ref.watch(blogsProvider);

    if (blogdataState is InitialBlogsState) {
      return const Center(child: CircularProgressIndicator());
    }
    if (blogdataState is ErrorBlogsState) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
      return const Center(child: Text("Blogs not found,Retry!"));
    }
    if (blogdataState is BlogsLoadedState) { return buildBlogList(blogdataState); }

    return const Text("Blog is empty");
  }

  Widget buildBlogList(BlogsLoadedState blogDataState) {
    List<Blog> totalBlogs = blogDataState.blogs;

    return totalBlogs.isEmpty
        ? Expanded(
            child: Center(
                child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Blogs not found!",
                  style: Theme.of(context).textTheme.headlineMedium),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) =>
                                const AddEditBlog(isEditMode: false)));
                  },
                  child: const Text('+ Add blog'))
            ],
          )))
        : Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: totalBlogs.length,
                itemBuilder: (context, index) {
                  Blog blog = totalBlogs[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomCard(
                        formWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                   SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6, child: Text(blog.blogName,
                                  overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displayMedium)),
                                   Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                     AddEditBlog(
                                                      isEditMode: true,
                                                      blogName: blog.blogName,
                                                      auther: blog.auther,
                                                      content: blog.content,
                                                      id: blog.id,
                                                    )));
                                      },
                                      child: const Icon(Icons.edit,color: Color.fromARGB(255, 51, 51, 52),)),
                                  GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  //
                                                  title: Text(
                                                    "Delete Blog",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  content: Text(
                                                      'Are you sure you want to delete this blog?',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      61,
                                                                      60,
                                                                      59)),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          onDeletedHandler(
                                                              blog.id);
                                                        },
                                                        child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      186,
                                                                      38,
                                                                      28)),
                                                        ))
                                                  ],
                                                ));
                                      },
                                      child: isloading &&
                                              selectedId ==
                                                  blog.id.toString()
                                          ? const SizedBox(
                                              width: 12,
                                              height: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                              ))
                                          : const Icon(Icons.delete,
                                              color:  Color.fromARGB(
                                                  255, 51, 51, 52)))
                                ],
                              )
                              ],
                            ),
                             
                             const SizedBox(height: 10),
                             Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                  Text("By ", style: Theme.of(context).textTheme.headlineSmall),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4, 
                                child :Text(blog.auther,
                                        overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.displaySmall),
                                  ),
                              ],
                             ),
                              Text(blog.createdAt, style: Theme.of(context).textTheme.displaySmall),
                              ],
                             ),
                            const  SizedBox(height: 4,),
                const Divider(
                  thickness: 0.8,
                  indent: 0,
                  endIndent: 0,
                  color: Color.fromARGB(255, 61, 61, 61),
                ),
                const SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Text("Content ", style: Theme.of(context).textTheme.headlineSmall),
                        SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  child: SingleChildScrollView(child: Text(blog.content,style: Theme.of(context).textTheme.displaySmall),
                                  )),
                    ],
                  )

                             
                          ],
                        )
                         
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  );
                }),
          );
  }
}
