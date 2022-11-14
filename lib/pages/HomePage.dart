import 'package:day_counter/EventTimeStampCard.dart';
import 'package:day_counter/pages/DayCalculator.dart';
import 'package:day_counter/pages/DaysPage.dart';
import 'package:day_counter/service/DayService.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 100), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Days',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              label: 'Calculator',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (value) => {
            setState(() {
              _selectedIndex = value;
            })
          },
          children: const [
            DaysPage(),
            DayCalculator(),
          ],
        )
    );
  }
}
