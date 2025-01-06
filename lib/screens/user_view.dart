import 'package:flutter/material.dart';
import 'package:hcms/models/user_model.dart';
import 'package:provider/provider.dart';
import '../controllers/user_controller.dart';

class UserView extends StatefulWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  void initState() {
    super.initState();

    // Fetch users when the view is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Consumer<UserController>(
        builder: (context, userController, child) {
          if (userController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: userController.users.length,
            itemBuilder: (context, index) {
              final user = userController.users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    userController.removeUser(user.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You could add a dialog or navigate to an add user screen
          context.read<UserController>().addUser(
                User(
                  id: DateTime.now().toString(),
                  name: 'New User',
                  email: 'new@example.com',
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
