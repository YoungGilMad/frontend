import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/menu/menu_screen.dart';
import '../home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final bool isAfterRegistration;
  
  const OnboardingScreen({
    super.key, 
    this.isAfterRegistration = false
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      'title': '영웅으로 성장하세요',
      'description': '퀘스트를 완료하고 경험치를 쌓아 당신만의 영웅으로 성장하세요.',
      'image': 'assets/icons/superhero.png',
    },
    {
      'title': '목표를 달성하세요',
      'description': '자기주도 퀘스트와 AI 퀘스트를 통해 새로운 목표를 설정하고 달성해보세요.',
      'image': 'assets/icons/checklist.png',
    },
    {
      'title': '친구들과 함께하세요',
      'description': '친구들과 함께 성장하고 서로 응원하며 더 높은 목표에 도전하세요.',
      'image': 'assets/icons/store.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    // 온보딩 완료 후 홈 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MenuScreen()),
    );
    
    // 온보딩 완료 상태 저장 (다음 로그인 시에는 온보딩 스킵)
    final prefs = Provider.of<AuthProvider>(context, listen: false).prefs;
    prefs.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip 버튼
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _finishOnboarding,
                  child: const Text('건너뛰기'),
                ),
              ),
            ),
            
            // 페이지 뷰
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(
                    _onboardingData[index]['title'],
                    _onboardingData[index]['description'],
                    _onboardingData[index]['image'],
                  );
                },
              ),
            ),
            
            // 인디케이터
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _totalPages,
                  (index) => _buildDotIndicator(index),
                ),
              ),
            ),
            
            // 버튼
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FilledButton(
                onPressed: _nextPage,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: Text(
                  _currentPage < _totalPages - 1 ? '다음' : '시작하기',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이미지
          Expanded(
            flex: 3,
            child: Image.asset(
              imagePath,
              height: 200,
              width: 200,
            ),
          ),
          
          // 제목
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // 설명
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Theme.of(context).colorScheme.primary
            : Colors.grey[300],
      ),
    );
  }
}