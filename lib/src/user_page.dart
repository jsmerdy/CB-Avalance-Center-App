import 'package:cbac_app/src/user_info.dart';
import 'package:flutter/material.dart';
import 'package:cbac_app/src/user_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Page"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onSaved: (String? value) {
                name = value!;
              },
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              onSaved: (String? value) {
                email = value!;
              },
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    var user = User(id: 0, name: name, email: email);
                    startDatabase(user);


                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

