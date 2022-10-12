// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'home_keys.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: kPageHomeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Home'),
      ),
    );
  }
}
