import 'package:flutter/material.dart';
import '../services/location_service.dart';

class LocationButton extends StatelessWidget {
  final String location;
  final Function(String) onLocationUpdate;

  const LocationButton({super.key, required this.location, required this.onLocationUpdate});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final newLocation = await LocationService.getCurrentLocation();
        onLocationUpdate(newLocation);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        location,
        style: const TextStyle(fontSize: 16, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
