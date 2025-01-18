import 'package:flutter/material.dart';

class SocialMainScreen extends StatelessWidget {
  const SocialMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social'),
      ),
      body: const Center(
        child: Text('Social Screen'),
      ),
    );
  }
}