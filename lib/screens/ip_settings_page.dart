import 'package:flutter/material.dart';
import '../services/ip_storage_service.dart';

class IPSettingsPage extends StatefulWidget {
  const IPSettingsPage({super.key});

  @override
  State<IPSettingsPage> createState() => _IPSettingsPageState();
}

class _IPSettingsPageState extends State<IPSettingsPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStoredIP();
  }

  Future<void> _loadStoredIP() async {
    String? storedIP = await IPStorageService.getIPAddress();
    if (mounted) {
      setState(() {
        _ipController.text = storedIP ?? '';
      });
    }
  }

  Future<void> _saveIPAddress() async {
    String newIP = _ipController.text.trim();

    // Save the new IP address using the service
    await IPStorageService.saveIPAddress(newIP);

    // Ensure that the widget is still mounted before using `Navigator.pop`
    if (mounted) {
      Navigator.pop(context, newIP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure IP Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Enter IP Address',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIPAddress,
              child: const Text('Save IP Address'),
            ),
          ],
        ),
      ),
    );
  }
}
