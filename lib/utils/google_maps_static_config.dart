import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GoogleMapsStaticConfig {
  static String apiKey = dotenv.env['GOOGLE_CLIENT_ID']!;

  static Future<Uint8List?> fetchStaticMapImage({
    required List<LatLng> waypoints,
    double zoom = 15.0,
    required Size viewportSize,
  }) async {
    final path = waypoints.map((point) => '${point.latitude},${point.longitude}').join('|');
    final params = <String, dynamic>{
      'size': '${viewportSize.width.round()}x${viewportSize.height.round()}',
      'path': 'color:0xff0000ff|weight:5|$path',
      'zoom': zoom.round(),
      'key': apiKey,
    };

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/staticmap',
      params,
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load static map image');
      }
    } catch (e) {
      print('Error fetching static map image: $e');
      return null;
    }
  }
}
