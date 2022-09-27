// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:ppo_package_analytics/ppo_package_analytics.dart';

// Use the development keys
// This is referred to as the Project Token in Mixpanel
final MixpanelAnalyticsService mixpanelAnalyticsService = MixpanelAnalyticsService(apiKey: 'dea062e0a41338266ff50f62f9750614');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mixpanelAnalyticsService.configureMixpanel();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mixpanel demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mixpanel Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text('Test Events'),
            dense: true,
          ),
          ListTile(
            title: const Text("Add Event"),
            onTap: _addEvent,
          ),
          ListTile(
            title: const Text("Add Event With Property"),
            onTap: _addEventWithProperties,
          ),
          const Divider(),
          const ListTile(
            title: Text('System'),
            dense: true,
          ),
          ListTile(
            title: const Text('Flush events'),
            onTap: _flushEvents,
          ),
          const Divider(),
          const ListTile(
            title: Text('User Properties'),
            dense: true,
          ),
          ListTile(
            title: const Text('Remove username'),
            onTap: _removeUsername,
          ),
          ListTile(
            onTap: _updateUsername,
            title: TextField(
              controller: userNameController,
              decoration: const InputDecoration(hintText: 'Enter a username'),
            ),
            trailing: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Future<void> _flushEvents() async {
    await mixpanelAnalyticsService.flush();
    print("Flushed");
  }

  Future<void> _removeUsername() async {
    if (!mounted) {
      return;
    }

    await mixpanelAnalyticsService.removeCommonProperty('username');
    setState(() {});
    print('Removed username');
  }

  Future<void> _updateUsername() async {
    final String username = userNameController.text.trim();
    if (!mounted || username.isEmpty) {
      return;
    }

    await mixpanelAnalyticsService.setCommonProperty('username', username);
    setState(() {});
    print('Set username to $username');
  }

  Future<void> _addEvent() async {
    await mixpanelAnalyticsService.track("testEvent");
    print("Tried to pass event testEvent");
  }

  Future<void> _addEventWithProperties() async {
    await mixpanelAnalyticsService.track(
      "testEventWithProperties",
      properties: {
        "testStringProperty": "testPropertyProperty",
      },
    );
    print("Tried to pass event with property testEventWithProperty");
  }
}
