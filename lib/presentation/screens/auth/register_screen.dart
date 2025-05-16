import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../providers/auth_provider.dart';
import '../onboarding/onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isEmailChecked = false;
  bool _isEmailChecking = false;
  bool _isEmailAvailable = false;
  bool _termsAgreed = false;

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  // 비밀번호 규칙 체크
  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    
    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    // 비밀번호 입력 변경 시 규칙 체크
    _passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 비밀번호 강도 체크
  void _checkPasswordStrength() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasUppercase = password.contains(RegExp(r'[A-Z]'));
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  // 이메일 유효성 검사
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    if (!_isEmailChecked) {
      return '이메일 중복 확인이 필요합니다';
    }
    if (!_isEmailAvailable) {
      return '이미 사용 중인 이메일입니다';
    }
    return null;
  }

  // 이메일 중복 확인
  Future<void> _checkEmailAvailability() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일을 입력해주세요')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일 형식이 아닙니다')),
      );
      return;
    }

    setState(() {
      _isEmailChecking = true;
      _isEmailChecked = false;
      _isEmailAvailable = false;
    });

    try {
      // 실제 API 호출은 AuthRepository를 통해 이루어져야 하지만
      // 여기서는 임시로 딜레이만 주고 무조건 사용 가능으로 처리합니다.
      // 실제 구현 시 API 호출을 통해 중복 확인을 해야 합니다.
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _isEmailChecking = false;
        _isEmailChecked = true;
        _isEmailAvailable = true;  // 항상 가능하다고 가정 (실제로는 서버 응답에 따라 설정)
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사용 가능한 이메일입니다'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isEmailChecking = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일 확인 중 오류가 발생했습니다: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 비밀번호 검증
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '대문자를 포함해야 합니다';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '숫자를 포함해야 합니다';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return '특수문자를 포함해야 합니다';
    }
    return null;
  }

  // 비밀번호 확인 검증
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 한 번 더 입력해주세요';
    }
    if (value != _passwordController.text) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  // 이름 검증
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '이름을 입력해주세요';
    }
    return null;
  }

  // 전화번호 검증
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 전화번호는 선택사항
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(value.replaceAll('-', ''))) {
      return '올바른 전화번호 형식이 아닙니다';
    }
    return null;
  }

  // 회원가입 처리
  Future<void> _handleRegister() async {
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이용약관에 동의해주세요'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      // 햅틱 피드백
      HapticFeedback.lightImpact();

      try {
        final success = await context.read<AuthProvider>().register(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          phoneNumber: _phoneController.text,
        );

        if (success && mounted) {
          // 회원가입 후 바로 로그인
          final loginSuccess = await context.read<AuthProvider>().login(
            _emailController.text,
            _passwordController.text,
          );

          if (loginSuccess && mounted) {
            // 회원가입 성공 시 온보딩 화면으로 이동
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnboardingScreen(isAfterRegistration: true),
              ),
            );
          } else if (mounted) {
            // 회원가입은 성공했지만 로그인 실패
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('회원가입에 성공했습니다. 로그인 화면에서 로그인해주세요.'),
                backgroundColor: Colors.blue,
              ),
            );
            Navigator.pop(context); // 로그인 화면으로 돌아가기
          }
        }
      } catch (e) {
        // 에러 메시지 처리
        String errorMessage = '회원가입 중 오류가 발생했습니다.';
        
        if (e.toString().contains('Email already registered')) {
          errorMessage = '이미 등록된 이메일입니다. 다른 이메일을 사용하거나 로그인해주세요.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Theme.of(context).colorScheme.error,
              action: e.toString().contains('Email already registered') 
                  ? SnackBarAction(
                      label: '로그인하기',
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop(); // 현재 회원가입 화면 닫기
                      },
                    )
                  : null,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'BeHero',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    '영웅으로 성장하는 여정을 시작하세요',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // 이메일 입력 필드
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: '이메일',
                            hintText: 'example@email.com',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabled: !_isEmailChecked || !_isEmailAvailable,
                            suffixIcon: _isEmailChecking 
                                ? const SizedBox(
                                    width: 20, 
                                    height: 20, 
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : _isEmailChecked && _isEmailAvailable
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : null,
                          ),
                          validator: _validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isEmailChecking || (_isEmailChecked && _isEmailAvailable) 
                              ? null 
                              : _checkEmailAvailability,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('중복 확인'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 비밀번호 입력 필드
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 8),

                  // 비밀번호 강도 표시
                  if (_passwordController.text.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '비밀번호는 다음을 포함해야 합니다:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildPasswordCheckItem('8자 이상', _hasMinLength),
                          _buildPasswordCheckItem('대문자 1개 이상', _hasUppercase),
                          _buildPasswordCheckItem('숫자 1개 이상', _hasNumber),
                          _buildPasswordCheckItem('특수문자 1개 이상', _hasSpecialChar),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 비밀번호 확인 필드
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: '비밀번호 확인',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  // 이름 입력 필드
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '이름',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validateName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),

                  // 전화번호 입력 필드
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: '전화번호 (선택)',
                      hintText: '01012345678',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: _validatePhone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 24),

                  // 약관 동의
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAgreed,
                        onChanged: (value) {
                          setState(() {
                            _termsAgreed = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showTermsDialog();
                          },
                          child: const Text(
                            '이용약관 및 개인정보 처리방침에 동의합니다',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 에러 메시지
                  if (authProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        authProvider.error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // 회원가입 버튼
                  FilledButton(
                    onPressed: authProvider.isLoading ? null : _handleRegister,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // 로그인 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('이미 계정이 있으신가요?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '로그인',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 비밀번호 체크 아이템 위젯
  Widget _buildPasswordCheckItem(String label, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.check_circle_outline,
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // 약관 동의 다이얼로그
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이용약관 및 개인정보 처리방침'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '이용약관',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '본 서비스는 사용자의 개인 성장과 자기 개발을 돕기 위한 서비스입니다. 사용자는 서비스 이용 시 다음 사항을 준수해야 합니다...',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 16),
              Text(
                '개인정보 처리방침',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '회사는 사용자의 개인정보를 안전하게 보호하며, 수집된 정보는 서비스 제공 및 개선을 위해서만 사용됩니다...',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('닫기'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _termsAgreed = true;
              });
              Navigator.pop(context);
            },
            child: const Text('동의'),
          ),
        ],
      ),
    );
  }
}