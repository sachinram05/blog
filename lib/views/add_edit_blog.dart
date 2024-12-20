import 'package:blog/constants/blog_constant.dart';
import 'package:blog/controllers/blog_controller.dart';
import 'package:blog/custom_widgets/custom_card.dart';
import 'package:blog/custom_widgets/custom_input.dart';
import 'package:blog/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddEditBlog extends ConsumerStatefulWidget {
  const AddEditBlog({super.key,required this.isEditMode,this.blogName,this.content,this.auther,this.id});

  final bool isEditMode;
  final String? blogName;
  final String? content;
  final String? auther;
  final String? id;

  @override
  ConsumerState<AddEditBlog> createState() => _AddEditBlogState();
}

class _AddEditBlogState extends ConsumerState<AddEditBlog> {
  final addBlogFormKey = GlobalKey<FormState>();
  String blogName = '';
  String content = '';
  String auther = '';
  String id = '';
  bool isloading = false;

  @override
  void initState() {
    if (widget.isEditMode) {
      setState(() {
        id = widget.id!;
        blogName = widget.blogName!;
        content = widget.content!;
        auther = widget.auther!;
      });
    }
    super.initState();
  }

  onAddSubmitHandler() async {
    try {
      if (addBlogFormKey.currentState!.validate()) {
        addBlogFormKey.currentState!.save();
        setState(() {isloading = true;});
        if (widget.isEditMode) {
          await ref.read(updateBlogsProvider.notifier).updateBlogs(id, {'blogName': blogName, 'content': content,'auther': auther });
          final updateState = ref.read(updateBlogsProvider);
          if (updateState is LoadingUpdateBlogstate) { setState(() { isloading = updateState.isloading;});}

          if (updateState is LoadedUpdateBlogstate) { setState(() { isloading = updateState.isloading;});
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(updateState.message)));
          }

          if (updateState is ErrorUpdateBlogstate) {setState(() {isloading = updateState.isloading;});
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(updateState.message)));
          }

        } else {
          await ref.read(addBlogsProvider.notifier).addBlogs(Blog(blogName: blogName,auther: auther,content: content,createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now())));
         
          final addState = ref.read(addBlogsProvider);

          if (addState is LoadingAddBlogsState) { setState(() {isloading = addState.isloading;});}

          if (addState is LoadedAddBlogsState) {
             addBlogFormKey.currentState!.reset();
            setState(() {
              blogName = '';
              content = '';
              auther = '';
              isloading = addState.isloading;
            });
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Blog added!')));
          }

          if (addState is ErrorAddBlogsState) {setState(() { isloading = addState.isloading;});
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(addState.message)));
          }
        }
      }
    } catch (err) {
      setState(() { isloading = false;});
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Something went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
      body: SingleChildScrollView(
        child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 40,
                        weight: 600,
                        color:  Color.fromARGB(255, 51, 51, 52)
                      ))),
          
              Container(
                margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: CustomCard(
                  formWidget: Form(
                      key: addBlogFormKey,
                      child: Column(children: [
                         Text(
                        widget.isEditMode ? "Edit Blog" : "Add Blog",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                     const  SizedBox(height: 20),
                        CustomInput(
                      
                            labelName: "Blog Name",
                            textFormField: TextFormField(
                              initialValue: widget.isEditMode ? blogName : null,
                              decoration: const InputDecoration(
                                  labelText: 'Enter Blog Name'),
                              style: Theme.of(context).textTheme.headlineMedium,
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
                                  blogName = newValue!;
                                });
                              },
                            )),
                        const SizedBox(height: 16),
                        CustomInput(
                            labelName: "Auther",
                      
                            textFormField: TextFormField(
                              initialValue: widget.isEditMode ? auther : null,
                              decoration: const InputDecoration(
                                  labelText: 'Enter auther name'),
                              style: Theme.of(context).textTheme.headlineMedium,
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
                                  auther = newValue!;
                                });
                              },
                            )),
                        const SizedBox(height: 16),
                        CustomInput(
                            labelName: "Content",
                      
                            textFormField: TextFormField(
                              initialValue: widget.isEditMode ? content : null,
                              decoration: const InputDecoration(
                                  labelText: 'Enter Content'),
                              style: Theme.of(context).textTheme.headlineMedium,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 10) {
                                  return "Please enter at least 10 characters.";
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  content = newValue!;
                                });
                              },
                            )),
                        const SizedBox(height: 16),
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 1,
                            child: ElevatedButton(
                                onPressed: isloading ? null : onAddSubmitHandler,
                                child: isloading
                                    ? const CircularProgressIndicator()
                                    : Text(widget.isEditMode
                                        ? "Edit Blog"
                                        : "Submit")))
                      ])),
                ),
              )
            ],
          ),
      ),
    );
  }
}
