import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../social/social_screen.dart';
import '../settings/settings_screen.dart';

class CustomDrawer extends StatefulWidget {
  final Function(Widget) onScreenChange;
  final int currentIndex;  // 추가: 현재 선택된 화면 인덱스

  const CustomDrawer({
    super.key,
    required this.onScreenChange,
    required this.currentIndex,  // 추가
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _showColors = false;
  late int _selectedIndex;  // widget.currentIndex로 초기화됨

  final List<Color> themeColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;  // 초기화
  }

  @override
  void didUpdateWidget(CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _selectedIndex = widget.currentIndex;  // 업데이트
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 60,
      child: Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            const SizedBox(height: 40),
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
            const SizedBox(height: 80),
            IconButton(
              icon: const Icon(Icons.home),
              color: _selectedIndex == 0 ? Colors.black : Colors.grey,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
                widget.onScreenChange(const HomeScreen());
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
            IconButton(
              icon: const Icon(Icons.person),
              color: _selectedIndex == 1 ? Colors.black : Colors.grey,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
                widget.onScreenChange(const SocialScreen());
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
            IconButton(
              icon: const Icon(Icons.settings),
              color: _selectedIndex == 2 ? Colors.black : Colors.grey,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
                widget.onScreenChange(const SettingsScreen());
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: IconButton(
                icon: const Icon(Icons.coffee),
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
  int _currentIndex = 0;  // 추가: 현재 화면 인덱스 추적

  void _changeScreen(Widget screen) {
    setState(() {
      _currentScreen = screen;
      // 화면에 따라 인덱스 업데이트
      if (screen is HomeScreen) {
        _currentIndex = 0;
      } else if (screen is SocialScreen) {
        _currentIndex = 1;
      } else if (screen is SettingsScreen) {
        _currentIndex = 2;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        onScreenChange: _changeScreen,
        currentIndex: _currentIndex,  // 현재 인덱스 전달
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _currentScreen,
    );
  }
}