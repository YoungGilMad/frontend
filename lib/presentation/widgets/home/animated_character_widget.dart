import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedCharacterWidget extends StatefulWidget {
  const AnimatedCharacterWidget({super.key});

  @override
  State<AnimatedCharacterWidget> createState() => _AnimatedCharacterWidgetState();
}

class _AnimatedCharacterWidgetState extends State<AnimatedCharacterWidget> {
  int _currentIndex = 0;
  final List<String> _frames = [
    // Frame 1 - Normal
    '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="50" r="40" fill="#FFD93D"/>
      <g transform="translate(0,2)">
        <circle cx="35" cy="42" r="8" fill="white"/>
        <circle cx="35" cy="42" r="4" fill="black"/>
        <circle cx="37" cy="40" r="2" fill="white"/>
        <circle cx="65" cy="42" r="8" fill="white"/>
        <circle cx="65" cy="42" r="4" fill="black"/>
        <circle cx="67" cy="40" r="2" fill="white"/>
      </g>
      <circle cx="30" cy="55" r="8" fill="#FF9999" opacity="0.4"/>
      <circle cx="70" cy="55" r="8" fill="#FF9999" opacity="0.4"/>
      <path d="M 40 58 Q 50 68 60 58" fill="none" stroke="#FF6B6B" stroke-width="4" stroke-linecap="round"/>
    </svg>''',

    // Frame 2 - Blink
    '''<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
      <circle cx="50" cy="50" r="40" fill="#FFD93D"/>
      <g transform="translate(0,2)">
        <path d="M 31 42 L 39 42" stroke="black" stroke-width="3" stroke-linecap="round"/>
        <path d="M 61 42 L 69 42" stroke="black" stroke-width="3" stroke-linecap="round"/>
      </g>
      <circle cx="30" cy="55" r="8" fill="#FF9999" opacity="0.4"/>
      <circle cx="70" cy="55" r="8" fill="#FF9999" opacity="0.4"/>
      <path d="M 40 58 Q 50 68 60 58" fill="none" stroke="#FF6B6B" stroke-width="4" stroke-linecap="round"/>
    </svg>''',
  ];  // 오직 2개의 프레임만 포함

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % 2;  // 명시적으로 2개의 프레임만 사용
        });
        _startAnimation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: SvgPicture.string(
        _frames[_currentIndex],
        key: ValueKey<int>(_currentIndex),
        width: 200,
        height: 200,
      ),
    );
  }
}