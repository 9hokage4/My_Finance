import 'package:flutter/material.dart';
import 'widgets/category_card.dart';
import 'widgets/transaction_dialog.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final buttonSize = (width * 0.15).clamp(50.0, 70.0);
    final spacing = 16.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Мои финансы')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Основной контент
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryCard(category: 'Обязательные', spent: 25000, limit: 50000),
                      const SizedBox(height: 16),
                      CategoryCard(category: 'Развлечения', spent: 18000, limit: 30000),
                      const SizedBox(height: 16),
                      CategoryCard(category: 'Накопления', spent: 5000, limit: 20000),
                      const SizedBox(height: 100), // дополнительный отступ снизу
                    ],
                  ),
                ),
              ),

              // Кнопки
              // Кнопки в правом нижнем углу — ГОРИЗОНТАЛЬНО
              Positioned(
                right: spacing,
                bottom: spacing + MediaQuery.viewPaddingOf(context).bottom,
                child: Row(
                  children: [
                    // Кнопка "Доход" (слева)
                    GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (ctx) => const TransactionDialog(isIncome: true),
                        );
                        if (result != null) {
                          print('Доход добавлен: $result');
                        }
                      },
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          shape: BoxShape.circle, // ← КРУГЛАЯ форма
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.attach_money, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Кнопка "Расход" (справа)
                    GestureDetector(
                      onTap: () async {
                        final result = await showDialog(
                          context: context,
                          builder: (ctx) => const TransactionDialog(isIncome: false),
                        );
                        if (result != null) {
                          print('Расход добавлен: $result');
                        }
                      },
                      child: Container(
                        width: buttonSize,
                        height: buttonSize,
                        decoration: BoxDecoration(
                          color: Colors.orange[800],
                          shape: BoxShape.circle, // ← КРУГЛАЯ форма
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.money_off, color: Colors.white, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}