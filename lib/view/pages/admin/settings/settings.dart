import "package:flutter/material.dart";

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.purple,
        width: double.infinity,
        height: double.infinity,
        child: const Text("Settings page"),
      ),
    );
  }
}