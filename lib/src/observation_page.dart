import 'dart:developer';
import 'dart:io';
import 'package:cbac_app/src/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:archive/archive_io.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file_functions.dart';
import 'map_box.dart';


enum ImageSourceType { gallery, camera }

class ObservationPage extends StatefulWidget {
  const ObservationPage({Key? key}) : super(key: key);

  @override
  _ObservationPageState createState() => _ObservationPageState();
}

class Model{
  String? subject;
  String? email;
  String? name;
  String? forecastZone;
  String? routeDesc;
  String? snowpack;
  String? weather;
}

class _ObservationPageState extends State<ObservationPage> {
  final _formKey = GlobalKey<FormState>();
  final Model _model = Model();
  DateTime selectedDate = DateTime.now();
  final List<String> _imagePaths = List<String>.empty(growable: true);
  bool isChecked = false;

  Future<void> _handleImageButtonPress(BuildContext context, var type) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type))).then((val){
      _imagePaths.addAll(val);
    });
  }

  late String? _initialName, _initialEmail;

  void _refreshUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _initialName = prefs.getString('Username');
      _initialEmail = prefs.getString('Email');
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

  bool _dragOverMap = false;
  final GlobalKey _pointerKey = GlobalKey();
  final GlobalKey _mapBoxKey = GlobalKey<MapWidgetState>();

  _checkDrag(Offset position, bool up) {
    if (!up) {
      // find your widget
      RenderBox? box = _pointerKey.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) {
        //get offset
        Offset boxOffset = box.localToGlobal(Offset.zero);

        // check if your pointerdown event is inside the widget (you could do the same for the width, in this case I just used the height)
        if (position.dy > boxOffset.dy &&
            position.dy < boxOffset.dy + box.size.height) {
          // check x dimension aswell
          if (position.dx > boxOffset.dx &&
              position.dx < boxOffset.dx + box.size.width) {
            setState(() {
              _dragOverMap = true;
            });
          }
        }
      }
    } else {
      setState(() {
        _dragOverMap = false;
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Observation Page"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
      ),
      body: Listener(
          onPointerUp: (ev) {
            _checkDrag(ev.position, true);
          },
          onPointerDown: (ev) {
            _checkDrag(ev.position, false);
          },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics:
            _dragOverMap ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
            child: Column(
              children: [
                  TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Subject'
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Subject';
                    }
                    return null;
                  },
                    onSaved: (value){
                      _model.subject = value;
                    },
                ),
                Text("${selectedDate.toLocal()}".split(' ')[0]),
                ElevatedButton(onPressed: () => _selectedDate(context), child: const Text('Change Date'),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Name'
                  ),
                  initialValue: _initialName,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Name';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _model.name = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email'
                  ),
                  initialValue: _initialEmail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _model.email = value;
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
                      return 'Please enter a Forecast Zone';
                    }
                    return null;
                    }, onChanged: (String? value) {  },
                  onSaved: (value){
                    _model.forecastZone = value as String;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Route Description'
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a Route Description';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _model.routeDesc = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Snowpack'
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your snowpack observations';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _model.snowpack = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Weather'
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weather observations';
                    }
                    return null;
                  },
                  onSaved: (value){
                    _model.weather = value;
                  },
                ),
                MaterialButton(
                  color: Colors.blue,
                  child: const Text(
                    "Pick Image from Gallery",
                    style: TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    _handleImageButtonPress(context, ImageSourceType.gallery);
                  },
                ),
                SizedBox(
                  key: _pointerKey, // key for finding the widget
                  height: 300,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child:
                    MapWidget(
                      key: _mapBoxKey
                  )
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
                      //gather state

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                      String markers = "";
                      var mapWidgetState = _mapBoxKey.currentState as MapWidgetState;
                      for(var symbol in mapWidgetState.mapController.symbols) {
                        stdout.writeln(symbol.options.geometry);
                        if (markers.isNotEmpty) {
                          markers += "; ";
                        }
                        markers+='${symbol.options.geometry?.latitude}:${symbol.options.geometry?.longitude}';
                      }

                      try{
                        var ff = FileFunctions();
                        //write state to csv
                        final csvFile = await ff.formEntriesFile;



                        const String headers = "subject,date,email,name,forecastZone,routeDesc,snowpack,weather,mailingList,coordinates\n";
                        List<String> data = [_model.subject!,DateFormat('dd/MM/yyyy').format(selectedDate),_model.email!,_model.name!,_model.forecastZone!,_model.routeDesc!,_model.snowpack!,_model.weather!,(isChecked? "true":"false"),markers];

                        await csvFile.writeAsString(headers + data.join(',')+"\n");

                        //zip to file
                        final sendFile = await ff.formEntriesZip;

                        var encoder = ZipFileEncoder();
                        encoder.open(sendFile.path);

                        encoder.addFile(csvFile);
                        int imageNumber = 1;
                        for(var imagePath in _imagePaths) {
                          var f = File(imagePath);
                          encoder.addFile(f,"image"+imageNumber.toString()+extension(f.path),0);
                          imageNumber++;
                        }
                        encoder.close();

                      }
                      catch(e){
                        log('error: $e');
                      }
                      _formKey.currentState?.reset();
                      _imagePaths.clear();
                      mapWidgetState.mapController.clearSymbols();
                    },
                    child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}