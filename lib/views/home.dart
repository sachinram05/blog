import 'package:blog/custom_widgets/custom_gradient.dart';
import 'package:blog/views/add_edit_blog.dart';
import 'package:blog/views/blogs.dart';
import 'package:blog/views/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  static const List<Widget> widgetOptions = <Widget>[ Blogs(),Profile(),];

  void onItemTapped(int index) {
    setState(() { selectedIndex = index;});
  }

  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(top: 16),
           child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           child:  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                 selectedIndex == 0
                ? 'Blogs'
                : selectedIndex == 1
                    ? 'Profile'
                    : 'Not Found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
               if (selectedIndex == 0)
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (ctx) => const AddEditBlog(
                                            isEditMode: false)));
                              },
                              child: const Icon(
                                Icons.add,
                                size: 40,
                                weight: 600,
                                color:  Color.fromARGB(
                                          255, 51, 51, 52)
                              ))
              ])),
             widgetOptions.elementAt(selectedIndex)])),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:const Color.fromARGB(255, 209, 196, 248),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: selectedIndex == 0
                ? const Icon(Icons.grid_view_rounded)
                : const Icon(Icons.grid_view_outlined),
            label: 'Blogs',
          ),
          BottomNavigationBarItem(
            icon: selectedIndex == 1
                ? const Icon(Icons.person_2)
                : const Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
          
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 110, 36, 214),
        onTap: onItemTapped,
      ),
    );
  }
}
