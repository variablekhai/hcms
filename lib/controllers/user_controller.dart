import 'package:flutter/foundation.dart';
import 'package:hcms/models/user_model.dart';

class UserController extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  // Simulate fetching users from an API/DB
  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock data
    _users = [
      User(id: '1', name: 'Khairul Azfar', email: 'khairu@gmail.com'),
      User(id: '2', name: 'Danial Nabil', email: 'danial@gmail.com')
    ];

    _isLoading = false;
    notifyListeners();
  }

  // Add a new user
  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  // Remove a user
  void removeUser(String userId) {
    _users.removeWhere((user) => user.id == userId);
    notifyListeners();
  }
}
