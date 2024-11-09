import 'dart:math' as math;
import 'package:flutter/material.dart';

class HealthInsightsCard extends StatefulWidget {
  const HealthInsightsCard({super.key});

  @override
  State<HealthInsightsCard> createState() => _HealthInsightsCardState();
}

class _HealthInsightsCardState extends State<HealthInsightsCard> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Insights',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_horiz),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              _HealthCard(
                title: 'Heart Rate',
                value: '97',
                unit: 'bpm',
                color: Color(0xFF8BC34A),
                child: HeartRateGraph(),
              ),
              _HealthCard(
                title: 'Steps Taken',
                value: '1578',
                unit: 'total',
                color: Color(0xFFFF4081),
                child: StepsGraph(),
              ),
              _HealthCard(
                title: 'Hydration',
                value: '85',
                unit: '%',
                color: Color(0xFF2196F3),
                child: Icon(
                  Icons.water_drop,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? const Color(0xFF5C6BC0)
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final Color color;
  final Widget child;

  const _HealthCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 60,
            child: child,
          ),
        ],
      ),
    );
  }
}

class HeartRateGraph extends StatelessWidget {
  const HeartRateGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: HeartRateGraphPainter(),
    );
  }
}

class HeartRateGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    // Create a smooth curve
    for (var i = 0; i < size.width; i++) {
      final x = i.toDouble();
      final y = size.height * 0.5 +
          math.sin(x * 0.05) * 20 +
          math.sin(x * 0.01) * 10;
      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StepsGraph extends StatelessWidget {
  const StepsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        7,
            (index) => Container(
          width: 8,
          height: 20.0 + math.Random().nextDouble() * 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}