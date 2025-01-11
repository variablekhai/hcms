import 'package:hcms/models/user_model.dart';

class UserController {
  static final UserController _instance = UserController._internal();
  UserModel? _currentUser;

  factory UserController() {
    return _instance;
  }

  UserController._internal();

  void setUser(String id, String name, String email, String role) {
    _currentUser = UserModel(id: id, name: name, email: email, role: role);
  }

  void clearUser() {
    _currentUser = null;
  }

  UserModel? get currentUser => _currentUser;
}
