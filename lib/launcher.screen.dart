import 'package:flutter/material.dart';
import 'package:to_do_ui_flutter/calendar.screen.dart';
import 'package:to_do_ui_flutter/complete.screen.dart';
import 'package:to_do_ui_flutter/home.screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  late PageController pageController;
  int pageIndex = 0;

  List<Widget> menuScreens = <Widget>[
    const HomeScreen(),
    const CalendarScreen(),
    const CompleteScreen(),
  ];

  List<BottomNavigationBarItem> menuItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(Icons.list, color: Colors.white),
          Text(
            'ToDo',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      label: 'ToDo',
    ),
    const BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(Icons.calendar_month, color: Colors.white),
          Text(
            'Calendar',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      label: 'Calendar',
    ),
    const BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(Icons.how_to_reg, color: Colors.white),
          Text(
            'Complete',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      label: 'Complete',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadProvider();
  }

  loadProvider() {
    pageController = PageController(initialPage: 0);
  }

  onPageChange(int index) {
    setState(() {
      pageIndex = index;
    });
    pageController.jumpToPage(index);
  }

  onItemTapped(int index) {
    setState(() {
      pageIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: PageView(
          controller: pageController,
          onPageChanged: onPageChange,
          children: menuScreens,
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.zero,
        child: BottomNavigationBar(
          selectedFontSize: 0, //จำเป็นมากต้องใส่ ไม่งั้นมันจะลอย !!
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          enableFeedback: false,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => onItemTapped(index),
          items: menuItems,
          backgroundColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
