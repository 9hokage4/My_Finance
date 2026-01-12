// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/transaction_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthNames = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    final currentMonth = monthNames[now.month - 1];
    final currentYear = now.year;

    final width = MediaQuery.sizeOf(context).width;
    final buttonSize = (width * 0.15).clamp(50.0, 70.0);
    final spacing = 16.0;

    // Отступ снизу: учитываем навбар и безопасную область
    final bottomPadding = spacing + MediaQuery.viewPaddingOf(context).bottom;

    return SafeArea( // ← ЗАЩИТА от статус-бара и навбара
      bottom: false, // разрешаем контенту доходить до низа (кнопки там)
      child: Stack(
        children: [
          // Основной контент
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16.0, // ← отступ сверху, чтобы не лезть под статус-бар
              16.0,
              bottomPadding + 80, // ← доп. отступ снизу, чтобы карточки не упирались в кнопки
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentMonth,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      currentYear.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CategoryCard(category: 'Обязательные', spent: 25000, limit: 50000),
                const SizedBox(height: 16),
                CategoryCard(category: 'Развлечения', spent: 18000, limit: 30000),
                const SizedBox(height: 16),
                CategoryCard(category: 'Накопления', spent: 5000, limit: 20000),
              ],
            ),
          ),

          // Кнопки — фиксированы в правом нижнем углу
          Positioned(
            right: spacing,
            bottom: bottomPadding, // ← ключевой момент!
            child: Row(
              children: [
                _buildActionButton(
                  context: context,
                  isIncome: true,
                  icon: Icons.attach_money,
                  color: Colors.green[600]!,
                  size: buttonSize,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  context: context,
                  isIncome: false,
                  icon: Icons.money_off,
                  color: Colors.orange[800]!,
                  size: buttonSize,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required bool isIncome,
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return GestureDetector(
      onTap: () async {
        final result = await showDialog(
          context: context,
          builder: (ctx) => TransactionDialog(isIncome: isIncome),
        );
        if (result != null) {
          print('${isIncome ? "Доход" : "Расход"} добавлен: $result');
        }
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}