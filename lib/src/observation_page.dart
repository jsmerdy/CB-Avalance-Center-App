import 'dart:io';

import 'package:cbac_app/src/user_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';

enum ImageSourceType { gallery, camera }

class ObservationPage extends StatefulWidget {
  const ObservationPage({Key? key}) : super(key: key);

  @override
  _ObservationPageState createState() => _ObservationPageState();
}
class ImageFromGalleryEx extends StatefulWidget {
  final type;
  const ImageFromGalleryEx(this.type);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState(this.type);
}
class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 52,
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                    color: Colors.white),
                child: _image != null
                    ? Image.file(
                  _image,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                )
                    : Container(
                  decoration: const BoxDecoration(
                      color: Colors.white),
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ObservationPageState extends State<ObservationPage> {
  late GoogleMapController mapController;
  List<Marker> myMarker = [];
  final Location _location = Location();
  final LatLng _center = const LatLng(45.521563, -122.677433);
  final ImagePicker _picker = ImagePicker();
  // Pick an image


  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool isChecked = false;

  void _handleImageButtonPress(BuildContext context, var type) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImageFromGalleryEx(type)));
  }

  void _onMapCreated(GoogleMapController _cntlr)
  {
    mapController = _cntlr;
    _location.onLocationChanged.listen((l) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
  }



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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Observation Page"),
      ),
      body: Form(
        child: SingleChildScrollView(
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
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              ElevatedButton(onPressed: () => _selectedDate(context), child: const Text('Change Date'),
              ),
              TextFormField(
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
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Name'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
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
                    return 'Please enter your email';
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
                    return 'Please enter your email';
                  }
                  return null;
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
                height: 200,
                child:
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                  markers: Set.from(myMarker),
                  onTap: _handleTap,
                ),
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
      )
    );
  }
  _handleTap(LatLng observationPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(
          Marker(
            markerId: MarkerId(observationPoint.toString()),
            position: observationPoint,
          )
      );
    });
  }
}