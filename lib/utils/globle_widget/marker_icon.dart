import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> getByFromAsset(String path, int width) async {
  var data = await rootBundle.load(path);
  ui.Codec c = await ui.instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  ui.FrameInfo fi = await c.getNextFrame();
  final imageData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
  final image = imageData?.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(image!);
}