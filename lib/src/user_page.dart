import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String? _initialName, _initialEmail;
  late String _name, _email;

  bool _isLoading = true;

  void _refreshUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _initialName = prefs.getString('Username');
      _initialEmail = prefs.getString('Email');
      _isLoading = false;

    });
  }
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _refreshUsers();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
    constraints: const BoxConstraints.expand(),
    decoration: const BoxDecoration(
    image: DecorationImage(
    image: AssetImage("images/cb background.jpg"), fit: BoxFit.cover)),
      child:
        Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("User Page"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
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
                textCapitalization: TextCapitalization.words,
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
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('Username', _name);
                      await prefs.setString('Email', _email);
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

