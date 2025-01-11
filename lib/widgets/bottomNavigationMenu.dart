import 'package:flutter/material.dart';
import 'package:hcms/screens/booking/booking_list.dart';
import 'package:hcms/screens/house/house_list.dart';
import 'package:hcms/screens/payment/checkout.dart';
import '../screens/user_view.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu({super.key});

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  int _selectedIndex = 0;

// Letak Page Korang
  final List<Widget> _pages = [
    HouseListScreen(),
    BookingList(),
    const Checkout(),
    const UserView(),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Booking',
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
