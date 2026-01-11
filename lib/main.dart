import 'package:flutter/material.dart';
import 'widgets/category_card.dart';
import 'widgets/transaction_dialog.dart'; // ← импорт нового виджета

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
    return Scaffold(
      appBar: AppBar(title: const Text('Мои финансы')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Карточки
              CategoryCard(title: 'Могу', spent: 25000, limit: 50000),
              const SizedBox(height: 16),
              CategoryCard(title: 'Хочу', spent: 18000, limit: 30000),
              const SizedBox(height: 16),
              CategoryCard(title: 'Надо', spent: 5000, limit: 20000),
              const SizedBox(height: 24),

              // Кнопки
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (ctx) => const TransactionDialog(isIncome: true),
                      );
                      if (result != null) {
                        // Пока просто выводим в консоль
                        print('Доход добавлен: $result');
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Доход'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (ctx) => const TransactionDialog(isIncome: false),
                      );
                      if (result != null) {
                        print('Расход добавлен: $result');
                      }
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Расход'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}