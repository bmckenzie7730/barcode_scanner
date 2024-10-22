// ignore_for_file: avoid_print

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';

class LocationService {
  static final Logger _logger = Logger('LocationService');

static Future<String> getCurrentLocation() async {
  _logger.info('Starting location retrieval process.');
  print('DEBUG: Starting location retrieval process.');

  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    _logger.warning('Location services are disabled. Please enable them.');
    print('DEBUG: Location services are disabled.');
    return 'Location services are disabled. Please enable them.';
  }
  _logger.info('Location services are enabled.');
  print('DEBUG: Location services are enabled.');

  // Check for location permissions
  permission = await Geolocator.checkPermission();
  _logger.info('Current location permission status: $permission');
  print('DEBUG: Permission status: $permission');

  if (permission == LocationPermission.denied) {
    _logger.warning('Location permission is denied. Requesting permission...');
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      _logger.warning('Location permissions are denied by the user.');
      print('DEBUG: Permission denied by user.');
      return 'Location permissions are denied.';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    _logger.warning('Location permissions are permanently denied. Unable to request permissions.');
    print('DEBUG: Permission permanently denied.');
    return 'Location permissions are permanently denied. Please enable them in settings.';
  }

  _logger.info('Location permissions granted.');
  print('DEBUG: Location permissions granted.');

  // Get the current location with new LocationSettings
  try {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.low, // Lower accuracy for faster response
      distanceFilter: 100, // Minimum distance (in meters) to trigger updates
    );

    _logger.info('Attempting to get current position...');
    print('DEBUG: Attempting to get current position...');

    Position currentPosition = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        _logger.severe('Location request timed out.');
        print('DEBUG: Location request timed out.');
        throw TimeoutException('Location request timed out.');
      },
    );

    final locationString = 'Lat: ${currentPosition.latitude}, Long: ${currentPosition.longitude}';
    _logger.info('Successfully retrieved location: $locationString');
    print('DEBUG: Successfully retrieved location: $locationString');
    return locationString;
  } catch (e) {
    _logger.severe('Error fetching location: $e');
    print('DEBUG: Error fetching location: $e');

    // Try to get the last known position as a fallback
    _logger.info('Attempting to get last known position...');
    print('DEBUG: Attempting to get last known position...');
    Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
    if (lastKnownPosition != null) {
      final fallbackLocation = 'Lat: ${lastKnownPosition.latitude}, Long: ${lastKnownPosition.longitude} (Last known)';
      _logger.info('Successfully retrieved last known location: $fallbackLocation');
      print('DEBUG: Successfully retrieved last known location: $fallbackLocation');
      return fallbackLocation;
    }

    return 'Error fetching location. Make sure permissions are granted and try again.';
  }
}

}
