import 'package:flutter/material.dart';
import '../utils/number_formater.dart';


class CategoryCard extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;

  const CategoryCard({
    super.key,
    required this.category,
    required this.spent,
    required this.limit,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final titleSize = (width * 0.072).clamp(16.0, 18.0);
    final needSize = (width * 0.085).clamp(26.0, 36.0);
    final spentSize = (width * 0.055).clamp(18.0, 24.0);
    final progressBarHeight = (width * 0.07).clamp(14.0, 24.0);

    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок категории
          Text(
            category,
            style: TextStyle(fontSize: titleSize, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatNumber(limit),
                style: TextStyle(
                  fontSize: needSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                formatNumber(spent),
                style: TextStyle(
                  fontSize: spentSize,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Прогресс-бар с закруглёнными краями
          _CustomReverseProgressBar(
            progress: progress,
            height: progressBarHeight,
            borderRadius: 16, // скругление
          ),
        ],
      ),
    );
  }
}

class _CustomReverseProgressBar extends StatelessWidget {
  final double progress;
  final double height;
  final double borderRadius;

  const _CustomReverseProgressBar({
    required this.progress,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          // Фон — нейтральный светло-серый
          Container(
            height: height,
            color: Colors.grey[200], //  мягкий фон
          ),
          // Заполнение — справа, градиент зелёный
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: height,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC8E6C9), Color(0xFF4CAF50)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}