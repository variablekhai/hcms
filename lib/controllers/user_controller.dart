import 'package:hcms/models/user_model.dart';

final List<Map<String, String>> _dummyUsers = [
  {
    'id': 'de6c5e03-1344-4571',
    'name': 'House Owner 1',
    'email': 'houseowner@gmail.com',
    'password': 'house123',
    'role': 'house_owner',
  },
  {
    'id': 'b3071a3f-b59d-4f27',
    'name': 'Cleaner 1',
    'email': 'cleaner@gmail.com',
    'password': 'cleaner123',
    'role': 'cleaner',
  },
];

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

  List<Map<String, String>> get dummyUsers => _dummyUsers;

  String? getNameById(String id) {
    final user =
        _dummyUsers.firstWhere((user) => user['id'] == id, orElse: () => {});
    return user.isNotEmpty ? user['name'] : null;
  }
}
