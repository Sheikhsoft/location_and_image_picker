import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapBox extends StatelessWidget {
  final double latitude;
  final double longitude;

  const MapBox({Key key, this.latitude, this.longitude}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
      width: double.infinity,
      height: 150.0,
      child: ClipRRect(
        borderRadius: BorderRadius.all(const Radius.circular(20.0)),
        child: latitude != null && longitude != null
            ? _bulidMapbox()
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget _bulidMapbox() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(latitude, longitude),
        zoom: 10.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken':
                'pk.eyJ1Ijoic2hlaWtoc29mdCIsImEiOiJjanRtdjF1dW8wcWgyNDVvNjE0eWhzYWs2In0.WFFfiKsDMQPvVtm0gU8NRQ',
            'id': 'mapbox.streets',
          },
        ),
        new MarkerLayerOptions(
          markers: [
            new Marker(
              width: 20.0,
              height: 20.0,
              point: new LatLng(latitude, longitude),
              builder: (ctx) => new Container(
                    child: new Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.5),
                            blurRadius:
                                10.0, // has the effect of softening the shadow
                            spreadRadius:
                                10.0, // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              0.0, // vertical, move down 10
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
