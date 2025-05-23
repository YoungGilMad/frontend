import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/repositories/auth_repository.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'core/theme/app_theme.dart';  // AppTheme import 추가
import 'data/repositories/statistics_repository.dart';
import 'presentation/providers/statistics_provider.dart';
import 'presentation/providers/quest_timer_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final authRepository = AuthRepository();

  runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => QuestTimerProvider()),
      ChangeNotifierProvider(
        create: (_) => AuthProvider(
          authRepository: authRepository,
          prefs: prefs,
        ),
      ),
      ChangeNotifierProxyProvider<AuthProvider, StatisticsProvider?>(
        create: (_) => null,
        update: (_, authProvider, __) => authProvider.isAuthenticated && authProvider.user != null
            ? StatisticsProvider(
                repository: StatisticsRepository(),
                token: authProvider.token!,
                userId: authProvider.user!.id,
              )
            : null,
      ),
    ],
    child: const MyApp(),
  ),
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeHero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,  // 여기서 AppTheme 적용
      home: const InitialScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
      },
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    // 토큰 확인 중
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // 이미 로그인된 상태인지 확인
    if (authProvider.isAuthenticated) {
      // 온보딩 완료 여부 확인
      final onboardingCompleted = authProvider.prefs.getBool('onboarding_completed') ?? false;
      
      // 온보딩을 완료하지 않았다면 온보딩 화면으로
      if (!onboardingCompleted) {
        return const OnboardingScreen();
      }
      
      // 온보딩을 완료했다면 로그인 화면으로
      return const LoginScreen();
    }
    
    // 로그인되지 않은 상태
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'BeHero',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            FilledButton(  // ElevatedButton 대신 FilledButton 사용
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}