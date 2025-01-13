import 'package:flutter/material.dart';
import 'package:hcms/screens/auth/logout.dart';
import 'package:hcms/screens/cleaner/cleaner_jobs.dart';
import 'package:hcms/screens/report/cleaner_dashboard.dart';

class BottomNavCleaner extends StatefulWidget {
  const BottomNavCleaner({super.key});

  @override
  State<BottomNavCleaner> createState() => _BottomNavCleanerState();
}

class _BottomNavCleanerState extends State<BottomNavCleaner> {
  int _selectedIndex = 0;

// Letak Page Korang
  final List<Widget> _pages = [
    CleanerJobs(),
    CleanerDashboard(),
    LogoutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
