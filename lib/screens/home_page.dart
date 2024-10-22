import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/ip_storage_service.dart';
import '../widgets/barcode_scanner_button.dart';
import '../widgets/location_button.dart';
import 'ip_settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String barcode = 'Tap to scan';
  String location = 'Tap to get location';
  String? _storedIP;

  @override
  void initState() {
    super.initState();
    _loadStoredIP();
  }

  Future<void> _loadStoredIP() async {
    String? storedIP = await IPStorageService.getIPAddress();
    if (mounted) {
      setState(() {
        _storedIP = storedIP;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            location = 'Location services are disabled. Please enable them.';
          });
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              location = 'Location permissions are denied.';
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            location = 'Location permissions are permanently denied.';
          });
        }
        return;
      }

      Position currentPosition = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          location = 'Lat: ${currentPosition.latitude}, Long: ${currentPosition.longitude}';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          location = 'Error fetching location.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Await the result from IPSettingsPage
                  final updatedIP = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const IPSettingsPage(),
                    ),
                  );

                  // If a new IP address was returned, refresh the state
                  if (updatedIP != null && updatedIP is String && mounted) {
                    setState(() {
                      _storedIP = updatedIP;
                    });
                  }
                },
                child: const Text('Configure IP Address'),
              ),
              const SizedBox(height: 20),
              if (_storedIP != null) ...[
                Text('Stored IP Address: $_storedIP'),
                const SizedBox(height: 20),
              ],
              BarcodeScannerButton(
                onScan: (String scannedValue) async {
                  if (mounted) {
                    setState(() {
                      barcode = scannedValue;
                    });
                  }

                  // Fetch the new location after a successful scan
                  await _getCurrentLocation();
                },
              ),
              const SizedBox(height: 20),
              Text(barcode),
              const SizedBox(height: 20),
              LocationButton(
                location: location,
                onLocationUpdate: (String newLocation) {
                  if (mounted) {
                    setState(() {
                      location = newLocation;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
