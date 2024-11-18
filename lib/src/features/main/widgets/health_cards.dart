import 'dart:math' as math;
import 'package:flutter/material.dart';

class HealthInsightsCard extends StatefulWidget {
  const HealthInsightsCard({super.key});

  @override
  State<HealthInsightsCard> createState() => _HealthInsightsCardState();
}

class _HealthInsightsCardState extends State<HealthInsightsCard> {
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
          child: const _HealthCard(
            title: 'Steps Taken',
            value: '1578',
            unit: 'total',
            color: Color(0xFFFF4081),
            child: StepsGraph(),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
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
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.show_chart,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
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
              const SizedBox(height: 16),
              ClipRect(
                child: SizedBox(
                  height: 60,
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepsGraph extends StatelessWidget {
  const StepsGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 60),
      painter: StepsGraphPainter(),
    );
  }
}

class StepsGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final itemWidth = size.width / 7;
    final barWidth = 6.0;

    for (int i = 0; i < 7; i++) {
      // Draw bar
      final barHeight = 20.0 + math.Random().nextDouble() * 40;
      final barX = (itemWidth * i) + (itemWidth - barWidth) / 2;
      final barY = size.height - barHeight - 14; // Leave space for text

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barWidth, barHeight),
        const Radius.circular(3),
      );
      canvas.drawRRect(rect, paint);

      // Draw text
      textPainter.text = TextSpan(
        text: 'D${i + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: itemWidth,
      );
      
      final textX = (itemWidth * i) + (itemWidth - textPainter.width) / 2;
      final textY = size.height - textPainter.height;
      
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}