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
              // Основной контент (прокручиваемый)
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CategoryCard(title: 'Могу', spent: 25000, limit: 50000),
                      const SizedBox(height: 16),
                      CategoryCard(title: 'Хочу', spent: 18000, limit: 30000),
                      const SizedBox(height: 16),
                      CategoryCard(title: 'Надо', spent: 5000, limit: 20000),
                      const SizedBox(height: 100), // дополнительный отступ снизу
                    ],
                  ),
                ),
              ),

              // Кнопки
              Positioned(
                right: 16,
                bottom: 16 + MediaQuery.viewPaddingOf(context).bottom,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Доход
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
                        width: (MediaQuery.sizeOf(context).width * 0.15).clamp(50.0, 70.0),
                        height: (MediaQuery.sizeOf(context).width * 0.15).clamp(50.0, 70.0),
                        decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 30),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Расход
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
                        width: (MediaQuery.sizeOf(context).width * 0.15).clamp(50.0, 70.0),
                        height: (MediaQuery.sizeOf(context).width * 0.15).clamp(50.0, 70.0),
                        decoration: BoxDecoration(
                          color: Colors.orange[900],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.remove, color: Colors.white, size: 30),
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