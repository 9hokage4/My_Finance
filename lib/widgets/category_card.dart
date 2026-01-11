import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final double spent;
  final double limit;

  const CategoryCard({
    super.key,
    required this.title,
    required this.spent,
    required this.limit,
  });

  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

  Color get progressColor {
    final p = progress;
    if (p <= 0.5) {
      return Color.lerp(Colors.green, Colors.yellow, (p / 0.5).clamp(0.0, 1.0))!;
    } else {
      return Color.lerp(Colors.yellow, Colors.red, ((p - 0.5) / 0.5).clamp(0.0, 1.0))!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Адаптивные размеры
    final titleSize = (width * 0.06).clamp(18.0, 24.0);
    final infoTextSize = (width * 0.045).clamp(14.0, 18.0);
    final progressBarHeight = (width * 0.05).clamp(8.0, 16.0); // 5% ширины -> высота бара

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Название категории
          Text(
            title,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Текст "Потрачено: X из Y"
          Text(
            'Потрачено: ${spent.toInt()} из ${limit.toInt()}',
            style: TextStyle(fontSize: infoTextSize, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Линейный прогресс-бар
          LinearProgressIndicator(
            value: progress,
            minHeight: progressBarHeight,
            color: progressColor,
            backgroundColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}