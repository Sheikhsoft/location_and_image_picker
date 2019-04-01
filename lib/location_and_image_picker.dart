library location_and_image_picker;

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'map_box.dart';

class LocationAndPicPicker extends StatefulWidget {
  final ValueChanged<Map> onChanged;

  const LocationAndPicPicker({Key key, this.onChanged}) : super(key: key);

  @override
  _LocationAndPicPickerState createState() => _LocationAndPicPickerState();
}

class _LocationAndPicPickerState extends State<LocationAndPicPicker> {
  Map<String, String> _map = new Map();

  Future<File> _imageFile;
  Position _position;
  Image image1;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      _map['latitude'] = position.latitude.toString();
      _map['longitude'] = position.longitude.toString();
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    _publishSelection(_map);

    setState(() {
      _position = position;
    });
  }

  Widget _buildMapBox() {
    return FutureBuilder<GeolocationStatus>(
        future: Geolocator().checkGeolocationPermissionStatus(),
        builder:
            (BuildContext context, AsyncSnapshot<GeolocationStatus> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == GeolocationStatus.disabled) {
            return const MapBox();
          }

          if (snapshot.data == GeolocationStatus.denied) {
            return const MapBox();
          }

          return _position != null
              ? new MapBox(
                  latitude: _position.latitude,
                  longitude: _position.longitude,
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPicText() => new Container(
          padding: EdgeInsets.only(left: 50.0, bottom: 30.0, top: 50.0),
          child: Text(
            "Picture of the incident (optional)",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[_buildMapBox(), _buildPicText(), _imageContainer()],
    );
  }

  Widget _imageContainer() {
    return new Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 3.0, // has the effect of extending the shadow
                  offset: Offset(
                    5.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
              color: Colors.white,
              border: new Border.all(width: 1.0, color: Colors.white),
              borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
            ),
            margin: EdgeInsets.symmetric(horizontal: 25.0),
            width: 200.0,
            height: 150.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
              child: _previewImage(),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery);
                  },
                  heroTag: 'image0',
                  tooltip: 'Pick Image from gallery',
                  child: const Icon(Icons.photo_library),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _onImageButtonPressed(ImageSource.camera);
                    },
                    heroTag: 'image1',
                    tooltip: 'Take a Photo',
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
        future: _imageFile,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            _map['image'] = snapshot.data.path;
            return Image.file(
              snapshot.data,
              fit: BoxFit.cover,
            );
          } else if (snapshot.error != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: const Text(
                'Error picking image.',
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: const Text(
                'You have not yet picked an image.',
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }

  void _onImageButtonPressed(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  void _publishSelection(Map<String, String> map) {
    if (widget.onChanged != null) {
      widget.onChanged(map);
    }
  }
}
