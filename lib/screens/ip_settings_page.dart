import 'package:flutter/material.dart';
import '../services/ip_storage_service.dart';

class IPSettingsPage extends StatefulWidget {
  const IPSettingsPage({super.key});

  @override
  State<IPSettingsPage> createState() => _IPSettingsPageState();
}

class _IPSettingsPageState extends State<IPSettingsPage> {
  final TextEditingController _ipController = TextEditingController();
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

  Future<void> _saveIP() async {
    String ip = _ipController.text.trim();
    if (ip.isNotEmpty) {
      await IPStorageService.saveIPAddress(ip);
      if (mounted) {
        setState(() {
          _storedIP = ip;
        });
        _ipController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('IP Address saved successfully!')),
          );
        }
      }
    }
  }

  Future<void> _clearIP() async {
    await IPStorageService.removeIPAddress();
    if (mounted) {
      setState(() {
        _storedIP = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('IP Address removed!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_storedIP != null) ...[
              Text('Stored IP Address: $_storedIP'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _clearIP,
                child: const Text('Clear IP Address'),
              ),
              const SizedBox(height: 20),
            ],
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Enter IP Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveIP,
              child: const Text('Save IP Address'),
            ),
          ],
        ),
      ),
    );
  }
}
