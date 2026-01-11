import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_finance/utils/app_constants.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final double spent;
  final double limit;

  const CategoryCard({
    super.key,
    required this.title,
    required this.limit,
    required this.spent,
  });

  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

  Color get progressColor {
    final progress = this.progress;

    if (progress <= 0.5) {
      double t = progress / 0.5;
      return Color.lerp(Colors.green, Colors.yellow, t.clamp(0.0, 1.0))!;
    } else {
      double t = (progress - 0.5) / 0.5;
      return Color.lerp(Colors.yellow, Colors.red, t.clamp(0.0, 1.0))!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: Colors.grey.shade200,
              ),
              Text(
                '${(progress * 100).toInt()}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: progressColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Потрачено: ${spent.toInt()} из ${limit.toInt()}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
