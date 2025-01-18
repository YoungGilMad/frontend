import 'package:flutter/material.dart';

class StoreMainScreen extends StatelessWidget {
  const StoreMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
      ),
      body: const Center(
        child: Text('Store Screen'),
      ),
    );
  }
}