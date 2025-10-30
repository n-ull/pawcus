import 'package:flutter/material.dart';
import 'package:pawcus/core/hooks/show_scaffold_message.dart';
import 'package:pawcus/core/models/settings.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/core/services/settings_service.dart';
import 'package:pawcus/features/permissions/permissions_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Settings settings;
  bool _isLoading = false;

  @override
  void initState() {
    // Get settings from settings service
    settings = sl<SettingsService>().getSettings();
    super.initState();
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    final showMessage = useShowScaffoldMessage(context);
    try {
      await sl<SettingsService>().saveSettings(settings);
      await showMessage('Settings saved', type: MessageType.success);
    } catch (e) {
      await showMessage(
        'Failed to save settings: ${e.toString()}',
        type: MessageType.danger,
        duration: const Duration(seconds: 4),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Deep Focus"),
              subtitle: Text("Prevents you from using non-productive apps."),
              trailing: Switch(
                value: settings.deepFocusEnabled,
                onChanged: (value) {
                  setState(() {
                    settings.deepFocusEnabled = value;
                  });
                },
              ),
            ),
            PermissionsScreen(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    "App Usage Threshold: ${settings.appUsageThreshold.round()} minutes",
                  ),
                  Slider(
                    value: settings.appUsageThreshold,
                    max: 40,
                    min: 10,
                    divisions: 4,
                    label: settings.appUsageThreshold.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        settings.appUsageThreshold = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveSettings,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Save Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
