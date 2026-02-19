import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LottoApp());
}

class LottoApp extends StatelessWidget {
  const LottoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '로또 번호 생성기',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          surface: Color(0xFF1A1A1A),
        ),
      ),
      home: const LottoScreen(),
    );
  }
}

class LottoScreen extends StatefulWidget {
  const LottoScreen({super.key});

  @override
  State<LottoScreen> createState() => _LottoScreenState();
}

class _LottoScreenState extends State<LottoScreen>
    with TickerProviderStateMixin {
  List<int> numbers = [];
  bool isAnimating = false;
  late AnimationController _buttonController;
  late Animation<double> _buttonScale;
  List<AnimationController> _ballControllers = [];
  List<Animation<double>> _ballAnimations = [];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    for (final c in _ballControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Color ballColor(int n) {
    if (n <= 10) return const Color(0xFFF5C842);
    if (n <= 20) return const Color(0xFF4A90D9);
    if (n <= 30) return const Color(0xFFE05050);
    if (n <= 40) return const Color(0xFF888888);
    return const Color(0xFF4CAF50);
  }

  Future<void> generateNumbers() async {
    if (isAnimating) return;
    setState(() {
      isAnimating = true;
      numbers = [];
    });

    for (final c in _ballControllers) {
      c.dispose();
    }
    _ballControllers = [];
    _ballAnimations = [];

    final rand = Random();
    final pool = List.generate(45, (i) => i + 1);
    pool.shuffle(rand);
    final picked = pool.take(6).toList()..sort();

    for (int i = 0; i < 6; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      final animation = CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      );
      _ballControllers.add(controller);
      _ballAnimations.add(animation);
    }

    for (int i = 0; i < 6; i++) {
      await Future.delayed(Duration(milliseconds: 200 + i * 150));
      setState(() {
        numbers.add(picked[i]);
      });
      _ballControllers[i].forward();
    }

    setState(() {
      isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LOTTO',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFFFD700),
                    letterSpacing: 6,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '번호 생성기',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '1 – 45 중 6개 번호',
                  style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
                ),
                const SizedBox(height: 56),

                // Balls area
                _buildBallsArea(),

                const SizedBox(height: 56),

                // Generate button
                ScaleTransition(
                  scale: _buttonScale,
                  child: GestureDetector(
                    onTapDown: (_) => _buttonController.forward(),
                    onTapUp: (_) {
                      _buttonController.reverse();
                      generateNumbers();
                    },
                    onTapCancel: () => _buttonController.reverse(),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 320),
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(29),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withAlpha(100),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isAnimating ? '생성 중...' : '번호 생성하기',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D0D0D),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                if (numbers.isNotEmpty) _buildLegend(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBallsArea() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF252525)),
      ),
      child: numbers.isEmpty
          ? Column(
              children: [
                Icon(
                  Icons.casino_outlined,
                  size: 52,
                  color: Colors.white.withAlpha(25),
                ),
                const SizedBox(height: 14),
                Text(
                  '버튼을 눌러 번호를 생성하세요',
                  style: TextStyle(
                    color: Colors.white.withAlpha(50),
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: List.generate(numbers.length, (i) {
                return ScaleTransition(
                  scale: _ballAnimations[i],
                  child: _LottoBall(
                    number: numbers[i],
                    color: ballColor(numbers[i]),
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildLegend() {
    final items = [
      ('1–10', const Color(0xFFF5C842)),
      ('11–20', const Color(0xFF4A90D9)),
      ('21–30', const Color(0xFFE05050)),
      ('31–40', const Color(0xFF888888)),
      ('41–45', const Color(0xFF4CAF50)),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: items.map((item) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: item.$2,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              item.$1,
              style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _LottoBall extends StatelessWidget {
  final int number;
  final Color color;

  const _LottoBall({required this.number, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          radius: 0.9,
          colors: [
            Color.lerp(color, Colors.white, 0.45)!,
            color,
            Color.lerp(color, Colors.black, 0.35)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(160),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black38,
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
