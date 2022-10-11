// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:ppoa/client/home/home_view_model.dart';
import 'home_keys.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final HomeViewModel viewModel;

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
