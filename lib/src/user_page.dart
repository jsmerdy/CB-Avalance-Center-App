import 'package:flutter/material.dart';
import 'package:cbac_app/src/user_database.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String _initialName, _initialEmail;
  late String _name, _email;
  late List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  void _refreshUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _users = data;
      _isLoading = false;
      if(_users.isEmpty) {
        _initialName = "enter name";
        _initialEmail = "enter email";
      } else {
        _initialName = _users[0]['name'];
        _initialEmail = _users[0]['email'];
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _addItem(name, email) async {
    await SQLHelper.createItem(name, email);
  }

  Future<void> _updateItem(name, email) async {
    await SQLHelper.updateItem(
        1, name, email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("images/TestPic.jpg"), fit: BoxFit.cover)),
      child:
        Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("User Page"),
          backgroundColor: Colors.transparent,
        ),
          body: _isLoading ? const Center(
            child: CircularProgressIndicator(),
        )
        :Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _initialName,
                onSaved: (String? value) {
                  _name = value!;
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
                initialValue: _initialEmail,
                onSaved: (String? value) {
                  _email = value!;
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
                      if(_users.isEmpty) {
                        _addItem(_name, _email);
                      }
                      else {
                        _updateItem(_name, _email);
                      }
                      _refreshUsers();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ));
  }
}

