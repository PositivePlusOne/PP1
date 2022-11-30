import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:ppoa/business/services/service_mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTool extends StatefulWidget {
  const SharedPreferencesTool({super.key});

  @override
  State<SharedPreferencesTool> createState() => _SharedPreferencesToolState();
}

class _SharedPreferencesToolState extends State<SharedPreferencesTool> with ServiceMixin {
  SharedPreferences? sharedPreferences;
  Timer? sharedPreferencesUpdateTime;

  final Map<String, dynamic> keys = <String, dynamic>{};

  @override
  void initState() {
    setupPreferences();
    super.initState();
  }

  @override
  void dispose() {
    sharedPreferencesUpdateTime?.cancel();
    super.dispose();
  }

  Future<void> setupPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferencesUpdateTime = Timer.periodic(const Duration(seconds: 2), updateSharedPreferences);
    updateSharedPreferences(null);
  }

  void updateSharedPreferences(Timer? timer) {
    if (sharedPreferences == null || !mounted) {
      return;
    }

    final Set<String> sharedKeys = sharedPreferences!.getKeys();
    for (final String key in sharedKeys) {
      final Object? obj = sharedPreferences!.get(key);
      if (obj == null || !key.startsWith('ppo_')) {
        continue;
      }

      keys[key] = obj;
    }

    setState(() {});
  }

  Future<void> resetSharedPreferences() async {
    log.fine('Attempting to clear shared preferences');
    if (sharedPreferences == null || !mounted) {
      return;
    }

    final Set<String> sharedKeys = sharedPreferences!.getKeys();
    for (final String key in sharedKeys) {
      if (!key.startsWith('ppo_')) {
        continue;
      }

      log.fine('Removing key: $key');
      await sharedPreferences!.remove(key);
      keys.remove(key);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences == null || keys.isEmpty) {
      return const ToolPanelSection(
        title: 'Waiting for Keys',
        children: <Widget>[],
      );
    }

    return ToolPanelSection(
      title: 'Keys',
      children: <Widget>[
        ListTile(
          title: const Text('Reset keys'),
          subtitle: const Text('Resets all stored keys. Note: you may have to start from the onboarding flows again.'),
          onTap: resetSharedPreferences,
        ),
        for (final String key in keys.keys) ...<Widget>[
          ListTile(
            title: Text(key),
            subtitle: Text('(${keys[key].runtimeType}) - ${keys[key]}'),
          ),
        ],
      ],
    );
  }
}
