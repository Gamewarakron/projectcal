import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  final bool isDarkMode = prefs.getBool('is_dark_mode') ?? false;

  runApp(HealthDietApp(isLoggedIn: isLoggedIn, isDarkMode: isDarkMode));
}

// ==================== Data Models ====================
enum Gender { male, female }
enum GoalType { weightLoss, weightGain }

class UserProfile {
  Gender gender;
  int age;
  double height;
  double weight;
  GoalType goal;
  int targetCalories;

  UserProfile({
    this.gender = Gender.female,
    this.age = 25,
    this.height = 165,
    this.weight = 60,
    this.goal = GoalType.weightLoss,
    this.targetCalories = 1800,
  });
}

class MealItem {
  final String id;
  final String title;
  final int calories;
  final double protein;
  final String category;

  MealItem({
    required this.id,
    required this.title,
    required this.calories,
    required this.protein,
    required this.category,
  });
}

class Ingredient {
  String name;
  String amount;
  bool isChecked;

  Ingredient(this.name, this.amount, {this.isChecked = false});
}

class CookingStep {
  int stepNumber;
  String description;

  CookingStep(this.stepNumber, this.description);
}

class Recipe {
  String id;
  String title;
  int calories;
  int prepTimeMinutes;
  String difficulty;
  double protein;
  double carbs;
  double fat;
  String category;
  List<Ingredient> ingredients;
  List<CookingStep> steps;
  bool isBookmarked;
  bool isLiked;

  Recipe({
    required this.id,
    required this.title,
    required this.calories,
    required this.prepTimeMinutes,
    required this.difficulty,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.isBookmarked = false,
    this.isLiked = false,
  });
}

// ==================== App Theme ====================
class AppColors {
  static const Color mossGreenPrimary = Color(0xFF1B4332);
  static const Color pastelOrange = Color(0xFFF28E51);
  static const Color lightBackground = Color(0xFFF7F9F8);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceTintGreen = Color(0xFFE9F0EC);
  static const Color surfaceTintDark = Color(0xFF263830);
  static const Color textPrimary = Color(0xFF1A1C1A);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textDarkPrimary = Color(0xFFE2E2E2);
  static const Color textDarkSecondary = Color(0xFFAAAAAA);
  static const Color mintCardBg = Color(0xFFE3F2ED);
  static const Color orangeCardBg = Color(0xFFFDF1EB);
}

class HealthDietApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isDarkMode;

  const HealthDietApp({
    super.key,
    required this.isLoggedIn,
    required this.isDarkMode,
  });

  @override
  State<HealthDietApp> createState() => _HealthDietAppState();
}

class _HealthDietAppState extends State<HealthDietApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  Future<void> _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health & Diet App',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mossGreenPrimary,
          primary: AppColors.mossGreenPrimary,
          secondary: AppColors.pastelOrange,
          background: AppColors.lightBackground,
          surface: AppColors.surfaceWhite,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mossGreenPrimary,
          brightness: Brightness.dark,
          primary: AppColors.mossGreenPrimary,
          secondary: AppColors.pastelOrange,
          background: AppColors.darkBackground,
          surface: AppColors.surfaceDark,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Roboto',
      ),
      home: widget.isLoggedIn
          ? GoalCalculatorScreen(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme)
          : LoginScreen(isDarkMode: _isDarkMode, onThemeChanged: _toggleTheme),
    );
  }
}

// ==================== Screen 0: Login Screen ====================
class LoginScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const LoginScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'user@health.com');
  final TextEditingController _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    await Future.delayed(const Duration(seconds: 1));

    if (_emailController.text.isNotEmpty && _passwordController.text.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_email', _emailController.text);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GoalCalculatorScreen(
            isDarkMode: widget.isDarkMode,
            onThemeChanged: widget.onThemeChanged,
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'กรุณากรอกอีเมลและรหัสผ่านอย่างน้อย 6 ตัวอักษร';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.mossGreenPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🥗', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Health & Diet App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.mossGreenPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'เริ่มต้นดูแลสุขภาพและโภชนาการของคุณวันนี้',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 36),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'เข้าสู่ระบบ (Login)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pastelOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'อีเมล (Email)',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน (Password)',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mossGreenPrimary,
                              foregroundColor: AppColors.surfaceWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                            ),
                            onPressed: _isLoading ? null : _handleLogin,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('เข้าสู่ระบบ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ยังไม่มีบัญชีใช่ไหม? ', style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              isDarkMode: widget.isDarkMode,
                              onThemeChanged: widget.onThemeChanged,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Screen 0.5: Register Screen ====================
class RegisterScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const RegisterScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    await Future.delayed(const Duration(seconds: 1));

    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน';
      });
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => GoalCalculatorScreen(
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'สร้างบัญชีใหม่ ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.mossGreenPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'เริ่มต้นเส้นทางสุขภาพที่ดีของคุณกับเรา',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'สมัครสมาชิก (Sign Up)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pastelOrange,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'ชื่อ-นามสกุล (Full Name)',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'อีเมล (Email)',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'รหัสผ่าน (Password)',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscurePassword,
                          style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          decoration: InputDecoration(
                            labelText: 'ยืนยันรหัสผ่าน (Confirm Password)',
                            prefixIcon: const Icon(Icons.lock_reset),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 13)),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mossGreenPrimary,
                              foregroundColor: AppColors.surfaceWhite,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                            ),
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('สมัครสมาชิก', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('มีบัญชีอยู่แล้วใช่ไหม? ', style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'เข้าสู่ระบบ',
                        style: TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Screen 1: Goal & BMR/TDEE Calculator ====================
class GoalCalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const GoalCalculatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<GoalCalculatorScreen> createState() => _GoalCalculatorScreenState();
}

class _GoalCalculatorScreenState extends State<GoalCalculatorScreen> {
  Gender _gender = Gender.female;
  final TextEditingController _ageController = TextEditingController(text: '25');
  final TextEditingController _heightController = TextEditingController(text: '165');
  final TextEditingController _weightController = TextEditingController(text: '60');
  GoalType _selectedGoal = GoalType.weightLoss;

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gender = (prefs.getString('gender') == 'male') ? Gender.male : Gender.female;
      _ageController.text = (prefs.getInt('age') ?? 25).toString();
      _heightController.text = (prefs.getDouble('height') ?? 165).toString();
      _weightController.text = (prefs.getDouble('weight') ?? 60).toString();
      _selectedGoal = (prefs.getString('goal') == 'gain') ? GoalType.weightGain : GoalType.weightLoss;
    });
  }

  Future<void> _calculateAndNavigate() async {
    final int age = int.tryParse(_ageController.text) ?? 25;
    final double height = double.tryParse(_heightController.text) ?? 165;
    final double weight = double.tryParse(_weightController.text) ?? 60;

    double bmr = (_gender == Gender.male)
        ? (10 * weight) + (6.25 * height) - (5 * age) + 5
        : (10 * weight) + (6.25 * height) - (5 * age) - 161;
    double tdee = bmr * 1.375;
    int target = _selectedGoal == GoalType.weightLoss
        ? (tdee - 400).toInt()
        : (tdee + 400).toInt();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', _gender == Gender.male ? 'male' : 'female');
    await prefs.setInt('age', age);
    await prefs.setDouble('height', height);
    await prefs.setDouble('weight', weight);
    await prefs.setString('goal', _selectedGoal == GoalType.weightGain ? 'gain' : 'loss');
    await prefs.setInt('target_calories', target);

    UserProfile profile = UserProfile(
      gender: _gender,
      age: age,
      height: height,
      weight: weight,
      goal: _selectedGoal,
      targetCalories: target,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationContainer(
          userProfile: profile,
          isDarkMode: widget.isDarkMode,
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'เริ่มต้นดูแลสุขภาพของคุณวันนี้',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'กรอกข้อมูลเพื่อคำนวณพลังงานที่เหมาะสม',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: AppColors.pastelOrange),
                        onPressed: () => widget.onThemeChanged(!isDark),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ข้อมูลส่วนตัว',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pastelOrange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('เพศ', style: TextStyle(fontSize: 14, color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _genderButton('ชาย', _gender == Gender.male, isDark, () {
                              setState(() => _gender = Gender.male);
                            }),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _genderButton('หญิง', _gender == Gender.female, isDark, () {
                              setState(() => _gender = Gender.female);
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _textField(_ageController, 'อายุ (ปี)', isDark),
                      const SizedBox(height: 12),
                      _textField(_heightController, 'ส่วนสูง (ซม.)', isDark),
                      const SizedBox(height: 12),
                      _textField(_weightController, 'น้ำหนักปัจจุบัน (กก.)', isDark),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'เป้าหมายของคุณ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _goalCard(
                title: 'ลดน้ำหนัก',
                subtitle: 'ลด 300-500 kcal จาก TDEE',
                icon: Icons.trending_down,
                isMint: true,
                isSelected: _selectedGoal == GoalType.weightLoss,
                isDark: isDark,
                onTap: () => setState(() => _selectedGoal = GoalType.weightLoss),
              ),
              const SizedBox(height: 12),
              _goalCard(
                title: 'เพิ่มน้ำหนัก / สร้างกล้ามเนื้อ',
                subtitle: 'เพิ่ม 300-500 kcal จาก TDEE',
                icon: Icons.trending_up,
                isMint: false,
                isSelected: _selectedGoal == GoalType.weightGain,
                isDark: isDark,
                onTap: () => setState(() => _selectedGoal = GoalType.weightGain),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mossGreenPrimary,
                    foregroundColor: AppColors.surfaceWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  ),
                  onPressed: _calculateAndNavigate,
                  child: const Text(
                    'คำนวณและจัดมื้ออาหาร',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label, bool isDark) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _genderButton(String title, bool isSelected, bool isDark, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintGreen)
              : (isDark ? AppColors.surfaceDark : AppColors.surfaceWhite),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.mossGreenPrimary : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.mossGreenPrimary : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _goalCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isMint,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    Color bgCard = isMint
        ? (isDark ? const Color(0xFF162E24) : AppColors.mintCardBg)
        : (isDark ? const Color(0xFF33231A) : AppColors.orangeCardBg);
    Color accentColor = isMint ? AppColors.mossGreenPrimary : AppColors.pastelOrange;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 13, color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: accentColor),
          ],
        ),
      ),
    );
  }
}

// ==================== Main Navigation Container (Tabs) ====================
class MainNavigationContainer extends StatefulWidget {
  final UserProfile userProfile;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainNavigationContainer({
    super.key,
    required this.userProfile,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;
  int _consumedCalories = 520;
  int _waterGlasses = 4;
  final List<Recipe> _bookmarkedRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadDailyProgress();
    _initDefaultRecipes();
  }

  Future<void> _loadDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _consumedCalories = prefs.getInt('consumed_calories') ?? 520;
      _waterGlasses = prefs.getInt('water_glasses') ?? 4;
    });
  }

  Future<void> _saveDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('consumed_calories', _consumedCalories);
    await prefs.setInt('water_glasses', _waterGlasses);
  }

  void _initDefaultRecipes() {
    _bookmarkedRecipes.add(
      Recipe(
        id: 'recipe_1',
        title: 'ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน',
        calories: 520,
        prepTimeMinutes: 15,
        difficulty: 'ง่ายมาก',
        protein: 35,
        carbs: 45,
        fat: 12,
        category: 'โปรตีนสูง',
        ingredients: [
          Ingredient('อกไก่หั่นชิ้น', '150 กรัม'),
          Ingredient('ใบกะเพราออร์แกนิก', '1 กำมือ'),
          Ingredient('พริกขี้หนูสวน & กระเทียม', '1 ช้อนโต๊ะ'),
          Ingredient('น้ำปลาสูตรลดโซเดียม', '1 ช้อนชา'),
          Ingredient('ไข่ไก่ (ทอดด้วยน้ำเปล่า)', '1 ฟอง'),
          Ingredient('ข้าวกล้องไรซ์เบอร์รี', '1 ทัพพี'),
        ],
        steps: [
          CookingStep(1, 'โขลกพริกและกระเทียมพอหยาบ เตรียมไว้สำหรับผัด'),
          CookingStep(2, 'ตั้งกระทะเทฟลอน ใส่กระเทียมและพริกผัดกับน้ำเปล่าเล็กน้อยจนหอม ไม่ใช้น้ำมัน'),
          CookingStep(3, 'ใส่ออกไก่หั่นชิ้นลงไปผัดจนสุก ปรุงรสด้วยน้ำปลาสูตรลดโซเดียม ใส่ใบกะเพรา ปิดไฟทันที'),
          CookingStep(4, 'ทอดไข่ดาวในกระทะเทฟลอนโดยใช้น้ำเปล่าแทนน้ำมัน ตักเสิร์ฟคู่กับข้าวกล้องไรซ์เบอร์รี'),
        ],
        isBookmarked: true,
        isLiked: true,
      ),
    );
  }

  void _addCalories(int cals) {
    setState(() {
      _consumedCalories += cals;
    });
    _saveDailyProgress();
  }

  void _updateWater(int delta) {
    setState(() {
      _waterGlasses = (_waterGlasses + delta).clamp(0, 12);
    });
    _saveDailyProgress();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DailyMealPlannerTab(
        userProfile: widget.userProfile,
        consumedCalories: _consumedCalories,
        waterGlasses: _waterGlasses,
        onAddCalories: _addCalories,
        onUpdateWater: _updateWater,
        onSelectRecipe: (recipe) async {
          final addedCals = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
          if (addedCals != null && addedCals is int) {
            _addCalories(addedCals);
          }
        },
      ),
      MealPlannerSearchTab(
        onSelectRecipe: (recipe) async {
          final addedCals = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
          if (addedCals != null && addedCals is int) {
            _addCalories(addedCals);
          }
        },
      ),
      FavoritesTab(
        bookmarkedRecipes: _bookmarkedRecipes,
        onSelectRecipe: (recipe) async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
          setState(() {});
        },
      ),
      ProfileSettingsTab(
        userProfile: widget.userProfile,
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        onLogout: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', false);
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(
                isDarkMode: widget.isDarkMode,
                onThemeChanged: widget.onThemeChanged,
              ),
            ),
            (route) => false,
          );
        },
        onResetData: () async {
          setState(() {
            _consumedCalories = 0;
            _waterGlasses = 0;
          });
          _saveDailyProgress();
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        backgroundColor: widget.isDarkMode ? AppColors.surfaceDark : AppColors.surfaceWhite,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          NavigationDestination(icon: Icon(Icons.restaurant_menu), label: 'แผนอาหาร'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'รายการโปรด'),
          NavigationDestination(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
      ),
    );
  }
}

// ==================== Tab 1: Daily Meal Planner ====================
class DailyMealPlannerTab extends StatelessWidget {
  final UserProfile userProfile;
  final int consumedCalories;
  final int waterGlasses;
  final ValueChanged<int> onAddCalories;
  final ValueChanged<int> onUpdateWater;
  final ValueChanged<Recipe> onSelectRecipe;

  const DailyMealPlannerTab({
    super.key,
    required this.userProfile,
    required this.consumedCalories,
    required this.waterGlasses,
    required this.onAddCalories,
    required this.onUpdateWater,
    required this.onSelectRecipe,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (consumedCalories / userProfile.targetCalories).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สวัสดี, คุณรักสุขภาพ 👋', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 2),
                    Text('แผนโภชนาการประจำวันของคุณ', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('สถิติและสรุปสุขภาพ'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('เป้าหมาย: ${userProfile.targetCalories} kcal'),
                            Text('ทานไปแล้ว: $consumedCalories kcal'),
                            Text('น้ำที่ดื่ม: $waterGlasses / 8 แก้ว'),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(value: progress),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ปิด'))
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.insights, color: AppColors.pastelOrange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              color: AppColors.mossGreenPrimary,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'เป้าหมายวันนี้: ${userProfile.targetCalories} kcal',
                      style: TextStyle(color: AppColors.surfaceWhite.withOpacity(0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor: AppColors.surfaceWhite.withOpacity(0.2),
                            color: AppColors.pastelOrange,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$consumedCalories',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.surfaceWhite),
                            ),
                            Text(
                              'ทานไป (kcal)',
                              style: TextStyle(fontSize: 11, color: AppColors.surfaceWhite.withOpacity(0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _MacroBadge(label: 'คาร์บ', value: '165g', color: AppColors.pastelOrange),
                        _MacroBadge(label: 'โปรตีน', value: '95g', color: Colors.lightBlueAccent),
                        _MacroBadge(label: 'ไขมัน', value: '45g', color: Colors.amberAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ดื่มน้ำประจำวัน', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                            Text('$waterGlasses / 8 แก้ว (250 มล.)', style: TextStyle(fontSize: 13, color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => onUpdateWater(-1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                          onPressed: () => onUpdateWater(1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _mealSectionHeader('มื้อเช้า (Breakfast)', '350 kcal', () {}),
            const SizedBox(height: 8),
            _mealCard('โจ๊กหมูสับใส่ไข่ลวก', 350, 18, isDark, () {
              onSelectRecipe(_sampleRecipe('โจ๊กหมูสับใส่ไข่ลวก', 350));
            }),
            const SizedBox(height: 16),
            _mealSectionHeader('มื้อกลางวัน (Lunch)', '520 kcal', () {}),
            const SizedBox(height: 8),
            _mealCard('ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน', 520, 35, isDark, () {
              onSelectRecipe(_sampleRecipe('ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน', 520));
            }),
            const SizedBox(height: 16),
            _mealSectionHeader('มื้อเย็น (Dinner)', '400 kcal', () {}),
            const SizedBox(height: 8),
            _mealCard('สลัดอกไก่ย่างน้ำใส', 400, 28, isDark, () {
              onSelectRecipe(_sampleRecipe('สลัดอกไก่ย่างน้ำใส', 400));
            }),
          ],
        ),
      ),
    );
  }

  Recipe _sampleRecipe(String title, int cals) {
    return Recipe(
      id: title.hashCode.toString(),
      title: title,
      calories: cals,
      prepTimeMinutes: 15,
      difficulty: 'ง่าย',
      protein: 30,
      carbs: 40,
      fat: 10,
      category: 'คลีน',
      ingredients: [
        Ingredient('วัตถุดิบหลัก', '200 กรัม'),
        Ingredient('เครื่องปรุงรสโซเดียมต่ำ', '1 ช้อนชา'),
      ],
      steps: [
        CookingStep(1, 'เตรียมวัตถุดิบให้พร้อมสะอาด'),
        CookingStep(2, 'ปรุงตามสูตรสุขภาพและจัดเสิร์ฟ'),
      ],
      isBookmarked: true,
      isLiked: true,
    );
  }

  Widget _mealSectionHeader(String title, String kcal, VoidCallback onSwap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('แนะนำ: $kcal', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        TextButton(
          onPressed: onSwap,
          child: const Text('สลับเมนูอื่น', style: TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _mealCard(String title, int cals, double protein, bool isDark, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintGreen,
            shape: BoxShape.circle,
          ),
          child: const Center(child: Text('🍲', style: TextStyle(fontSize: 24))),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            children: [
              Text('$cals Kcal', style: const TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(width: 8),
              Text('โปรตีน ${protein.toInt()}g', style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroBadge({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.surfaceWhite.withOpacity(0.8))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.surfaceWhite)),
        ],
      ),
    );
  }
}

// ==================== Tab 2: Search & Filter Recipes ====================
class MealPlannerSearchTab extends StatefulWidget {
  final ValueChanged<Recipe> onSelectRecipe;

  const MealPlannerSearchTab({super.key, required this.onSelectRecipe});

  @override
  State<MealPlannerSearchTab> createState() => _MealPlannerSearchTabState();
}

class _MealPlannerSearchTabState extends State<MealPlannerSearchTab> {
  String _searchQuery = '';
  String _selectedCategory = 'ทั้งหมด';

  final List<Recipe> _allRecipes = [
    Recipe(
      id: 'r1',
      title: 'ข้าวกะเพราอกไก่ไข่ดาวไร้น้ำมัน',
      calories: 520,
      prepTimeMinutes: 15,
      difficulty: 'ง่ายมาก',
      protein: 35,
      carbs: 45,
      fat: 12,
      category: 'โปรตีนสูง',
      ingredients: [Ingredient('อกไก่', '150g'), Ingredient('ไข่ไก่', '1 ฟอง')],
      steps: [CookingStep(1, 'ผัดอกไก่กับพริกกระเทียมน้ำเปล่า'), CookingStep(2, 'ทอดไข่ดาวไร้น้ำมัน')],
    ),
    Recipe(
      id: 'r2',
      title: 'สลัดอกไก่ย่างน้ำใส',
      calories: 320,
      prepTimeMinutes: 10,
      difficulty: 'ง่าย',
      protein: 28,
      carbs: 15,
      fat: 8,
      category: 'อาหารคลีน',
      ingredients: [Ingredient('อกไก่ย่าง', '120g'), Ingredient('ผักสลัดรวม', '1 จาน')],
      steps: [CookingStep(1, 'ย่างอกไก่ให้สุก'), CookingStep(2, 'จัดเสิร์ฟพร้อมน้ำสลัดใส')],
    ),
    Recipe(
      id: 'r3',
      title: 'ข้าวกล้องปลาแซลมอนย่างเกลือ',
      calories: 480,
      prepTimeMinutes: 20,
      difficulty: 'ปานกลาง',
      protein: 32,
      carbs: 40,
      fat: 15,
      category: 'ลดน้ำหนัก',
      ingredients: [Ingredient('ปลาแซลมอน', '120g'), Ingredient('ข้าวกล้อง', '1 ทัพพี')],
      steps: [CookingStep(1, 'ย่างแซลมอนโรยเกลือเล็กน้อย'), CookingStep(2, 'เสิร์ฟคู่ข้าวกล้อง')],
    ),
    Recipe(
      id: 'r4',
      title: 'ไข่ตุ๋นทรงเครื่องกุ้งสด',
      calories: 250,
      prepTimeMinutes: 12,
      difficulty: 'ง่าย',
      protein: 22,
      carbs: 5,
      fat: 10,
      category: 'โปรตีนสูง',
      ingredients: [Ingredient('ไข่ไก่', '2 ฟอง'), Ingredient('กุ้งสด', '50g')],
      steps: [CookingStep(1, 'ตีไข่ผสมน้ำซุปและกุ้ง'), CookingStep(2, 'นึ่งจนสุกนุ่ม')],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ['ทั้งหมด', 'อาหารคลีน', 'โปรตีนสูง', 'ลดน้ำหนัก'];

    final filteredRecipes = _allRecipes.where((r) {
      final matchesSearch = r.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'ทั้งหมด' || r.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ค้นหาเมนูอาหารและสูตรสุขภาพ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ค้นหาชื่อเมนู...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.mossGreenPrimary,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.black)),
                      onSelected: (selected) => setState(() => _selectedCategory = cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = filteredRecipes[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceTintGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(child: Text('🍲', style: TextStyle(fontSize: 24))),
                      ),
                      title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('${recipe.calories} Kcal • ${recipe.category}', style: const TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold)),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => widget.onSelectRecipe(recipe),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Tab 3: Favorites ====================
class FavoritesTab extends StatelessWidget {
  final List<Recipe> bookmarkedRecipes;
  final ValueChanged<Recipe> onSelectRecipe;

  const FavoritesTab({super.key, required this.bookmarkedRecipes, required this.onSelectRecipe});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('รายการโปรดของคุณ (Favorites)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            bookmarkedRecipes.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text('ยังไม่มีรายการโปรด', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: bookmarkedRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = bookmarkedRecipes[index];
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceTintGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(child: Text('⭐', style: TextStyle(fontSize: 24))),
                            ),
                            title: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : Colors.black)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('${recipe.calories} Kcal • โปรตีน ${recipe.protein.toInt()}g', style: const TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold)),
                            ),
                            trailing: const Icon(Icons.favorite, color: Colors.red),
                            onTap: () => onSelectRecipe(recipe),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ==================== Tab 4: Profile & Settings ====================
class ProfileSettingsTab extends StatelessWidget {
  final UserProfile userProfile;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;
  final VoidCallback onResetData;

  const ProfileSettingsTab({
    super.key,
    required this.userProfile,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLogout,
    required this.onResetData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('โปรไฟล์และการตั้งค่า', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, child: Text('👤', style: TextStyle(fontSize: 36))),
                    const SizedBox(height: 12),
                    Text('คุณรักสุขภาพ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                    const SizedBox(height: 4),
                    Text('เป้าหมาย: ${userProfile.targetCalories} Kcal / วัน', style: const TextStyle(color: AppColors.pastelOrange, fontWeight: FontWeight.bold)),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('โหมดมืด (Dark Mode)'),
                        Switch(
                          value: isDarkMode,
                          activeColor: AppColors.mossGreenPrimary,
                          onChanged: onThemeChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: onResetData,
                child: const Text('รีเซ็ตข้อมูลประจำวัน (Reset Data)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mossGreenPrimary,
                  foregroundColor: AppColors.surfaceWhite,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: onLogout,
                child: const Text('ออกจากระบบ (Logout)', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== Screen 3: Recipe Detail Screen ====================
class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool isBookmarked;
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.recipe.isBookmarked;
    isLiked = widget.recipe.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      bottomNavigationBar: Container(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mossGreenPrimary,
              foregroundColor: AppColors.surfaceWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
            ),
            onPressed: () {
              Navigator.pop(context, widget.recipe.calories);
            },
            child: Text(
              'ทานมื้อนี้แล้ว (+${widget.recipe.calories} kcal)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  color: Colors.green.shade100,
                  child: const Center(
                    child: Text('🍛', style: TextStyle(fontSize: 80)),
                  ),
                ),
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.surfaceWhite.withOpacity(0.8),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.surfaceWhite.withOpacity(0.8),
                              child: IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: isBookmarked ? AppColors.pastelOrange : AppColors.textPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                    widget.recipe.isBookmarked = isBookmarked;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: AppColors.surfaceWhite.withOpacity(0.8),
                              child: IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : AppColors.textPrimary,
                                ),
                                onPressed: () => setState(() => isLiked = !isLiked),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _infoTag('🔥', '${widget.recipe.calories} Kcal', isDark),
                        const SizedBox(width: 8),
                        _infoTag('⏱️', '${widget.recipe.prepTimeMinutes} นาที', isDark),
                        const SizedBox(width: 8),
                        _infoTag('⭐', widget.recipe.difficulty, isDark),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: isDark ? Colors.grey.shade800 : Colors.black12),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _nutritionItem('โปรตีน', '${widget.recipe.protein.toInt()}g', isDark),
                        _nutritionItem('คาร์โบไฮเดรต', '${widget.recipe.carbs.toInt()}g', isDark),
                        _nutritionItem('ไขมัน', '${widget.recipe.fat.toInt()}g', isDark),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ส่วนผสม (Ingredients)',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.pastelOrange),
                    ),
                    const SizedBox(height: 8),
                    ...widget.recipe.ingredients.map((ing) => CheckboxListTile(
                          title: Text('${ing.name} - ${ing.amount}', style: TextStyle(color: ing.isChecked ? AppColors.textSecondary : (isDark ? Colors.white : Colors.black))),
                          value: ing.isChecked,
                          activeColor: AppColors.mossGreenPrimary,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (val) {
                            setState(() {
                              ing.isChecked = val ?? false;
                            });
                          },
                        )),
                    const SizedBox(height: 24),
                    const Text(
                      'ขั้นตอนการทำ (Steps)',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.pastelOrange),
                    ),
                    const SizedBox(height: 12),
                    ...widget.recipe.steps.map((step) => Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${step.stepNumber}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.mossGreenPrimary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    step.description,
                                    style: TextStyle(fontSize: 14, color: isDark ? Colors.white : AppColors.textPrimary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTag(String icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceTintDark : AppColors.surfaceTintGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.mossGreenPrimary)),
        ],
      ),
    );
  }

  Widget _nutritionItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.textPrimary)),
      ],
    );
  }
}
