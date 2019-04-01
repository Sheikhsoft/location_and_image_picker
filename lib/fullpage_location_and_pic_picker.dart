import 'package:flutter/material.dart';
import 'package:location_and_image_picker/utils.dart';

import 'location_and_pic_picker.dart';

class FullPageLocationAndImagePicker extends StatelessWidget {
  final Map mapData;
  final Widget container;
  final String title;
  final String route;

  FullPageLocationAndImagePicker(
      {Key key, this.mapData, this.container, this.title, this.route})
      : super(key: key);

  Map<String, String> _sixthPageMap = new Map();

  @override
  Widget build(BuildContext context) {
    print(mapData);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            container != null ? container : Container(),
            TopTitle(
              topMargin: 80.0,
              leftMargin: 50.0,
              title: title,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 25.0),
              child: LocationAndPicPicker(
                onChanged: getLocationAndPic,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.black87,
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  print(_sixthPageMap);

                  if (_sixthPageMap['latitude'] != null &&
                      _sixthPageMap['longitude'] != null) {
                    mapData['latitude'] = _sixthPageMap['latitude'];
                    mapData['longitude'] = _sixthPageMap['longitude'];
                    mapData['image'] = _sixthPageMap['image'];
                    Navigator.pushNamed(context, route, arguments: mapData);
                  } else {
                    Utils().showMyDialog(
                        context, "You Need To give Location Permission");
                  }
                },
              ),
            ),
            MyBackButton(),
          ],
        ),
      ),
    );
  }

  void getLocationAndPic(Map value) {
    _sixthPageMap = value;
  }
}
