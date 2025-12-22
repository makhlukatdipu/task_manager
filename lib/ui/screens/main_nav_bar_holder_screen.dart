import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancel_task_screen.dart';
import 'package:task_manager/ui/screens/completed_task_screen.dart';
import 'package:task_manager/ui/screens/new_task_screen.dart';
import 'package:task_manager/ui/screens/progress_task_screen.dart';
class MainNavBarHolderScreen extends StatefulWidget {
  const MainNavBarHolderScreen({super.key});

  @override
  State<MainNavBarHolderScreen> createState() => _MainNavBarHolderScreenState();
}

class _MainNavBarHolderScreenState extends State<MainNavBarHolderScreen> {

  int _seletedIndex = 0;
  List<Widget> _screens = [
    NewTaskScreen(),
    ProgressTaskScreen(),
    CompletedTaskScreen(),
    CancelTaskScreen(),

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_seletedIndex],

      bottomNavigationBar: NavigationBar(
          selectedIndex: _seletedIndex,
          onDestinationSelected: (int index){
            _seletedIndex = index;
            setState(() {

            });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.edit_document), label: 'New Task'),
            NavigationDestination(icon: Icon(Icons.edit_document), label: 'Progress'),
            NavigationDestination(icon: Icon(Icons.edit_document), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.edit_document), label: 'Canceled'),

          ]
      ),
    );
  }
}
