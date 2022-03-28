import 'package:cbac_app/src/user_database.dart';
import 'package:flutter/material.dart';

class ObservationPage extends StatefulWidget {
  const ObservationPage({Key? key}) : super(key: key);

  @override
  _ObservationPageState createState() => _ObservationPageState();
}

class _ObservationPageState extends State<ObservationPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool isChecked = false;

  late String _initialName, _initialEmail;
  late List<Map<String, dynamic>> _users = [];

  void _refreshUsers() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _users = data;
      if(_users.isEmpty) {
        _initialName = "enter name";
        _initialEmail = "enter email";
      } else {
        _initialName = _users[0]['name'];
        _initialEmail = _users[0]['email'];
      }
    });
  }

  Future<void> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2050));
    if(picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Observation Page"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Subject'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            ElevatedButton(onPressed: () => _selectedDate(context), child: const Text('Change Date'),
            ),
            TextFormField(
              initialValue: _initialEmail,
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
            TextFormField(
              initialValue: _initialName,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Name'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Name';
                }
                return null;
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Forecast Zone'
              ),
              items: const [
                DropdownMenuItem(child: Text('North West Mountains'), value: "North West Mountains"),
                DropdownMenuItem(child: Text('South East Mountains'), value: "South East Mountains"),
              ],
              validator: (value) {
                if (value == null) {
                  return 'Please enter your email';
                }
                return null;
                }, onChanged: (String? value) {  },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Route Description'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Snowpack'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter snowpack description';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Weather'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter weather';
                }
                return null;
              },
            ),
            const Text("Add me to the CBAC mailing list"),
            Checkbox(value: isChecked,
                onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();

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