import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class CustomDrawer extends StatefulWidget {
  final Function(Widget) onScreenChange;

  const CustomDrawer({
    super.key,
    required this.onScreenChange,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showColors = false;

  final List<Color> themeColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 60,
      child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            const SizedBox(height: 40), // 색상 선택기와 홈 아이콘 사이 간격
            // Theme Color Button
            GestureDetector(
              onTap: () {
                setState(() {
                  _showColors = !_showColors;
                });
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue,
                ),
              ),
            ),
            // Color Options
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showColors ? (themeColors.length * 41.0) : 0,
              curve: Curves.easeInOut,
              child: SingleChildScrollView(
                child: Column(
                  children: themeColors.map((color) => Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: GestureDetector(
                      onTap: () {
                        // Add theme change logic here
                        setState(() {
                          _showColors = false;
                        });
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: color,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            const SizedBox(height: 80), // 상단 여백 증가
            // Home Icon
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                widget.onScreenChange(const HomeScreen());
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24), // 아이콘들 사이 간격
            // Profile Icon
            IconButton(
              icon: const Icon(Icons.person_outline),
              color: Colors.grey,
              onPressed: () {
                widget.onScreenChange(const Center(child: Text('Profile Screen')));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            // Settings Icon
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              color: Colors.grey,
              onPressed: () {
                widget.onScreenChange(const Center(child: Text('Settings Screen')));
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            // Bottom Icon (e.g., Logout)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IconButton(
                icon: const Icon(Icons.coffee_outlined),
                color: Colors.grey,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Widget _currentScreen = const HomeScreen();

  void _changeScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(onScreenChange: _changeScreen),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentScreen,
    );
  }
}