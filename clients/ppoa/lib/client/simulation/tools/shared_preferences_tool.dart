// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:ppoa/business/services/service_mixin.dart';

class SharedPreferencesTool extends StatefulWidget {
  const SharedPreferencesTool({super.key});

  @override
  State<SharedPreferencesTool> createState() => _SharedPreferencesToolState();
}

class _SharedPreferencesToolState extends State<SharedPreferencesTool> with ServiceMixin {
  SharedPreferences? preferences;
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
    preferences = await SharedPreferences.getInstance();
    sharedPreferencesUpdateTime = Timer.periodic(const Duration(seconds: 2), updateSharedPreferences);
    updateSharedPreferences(null);
  }

  void updateSharedPreferences(Timer? timer) {
    if (preferences == null || !mounted) {
      return;
    }

    final Set<String> sharedKeys = sharedPreferences.getKeys();
    for (final String key in sharedKeys) {
      final Object? obj = sharedPreferences.get(key);
      if (obj == null || !key.startsWith('ppo_')) {
        continue;
      }

      keys[key] = obj;
    }

    setState(() {});
  }

  Future<void> resetSharedPreferences() async {
    log.v('Attempting to clear shared preferences');
    if (preferences == null || !mounted) {
      return;
    }

    final Set<String> sharedKeys = sharedPreferences.getKeys();
    for (final String key in sharedKeys) {
      if (!key.startsWith('ppo_')) {
        continue;
      }

      log.v('Removing key: $key');
      await preferences!.remove(key);
      keys.remove(key);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (preferences == null || keys.isEmpty) {
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
