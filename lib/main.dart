import 'package:flutter/material.dart';
import 'package:my_finance/widgets/category_card.dart';

import 'utils/app_constants.dart';

void main() {
  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
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
      body: const Padding(
        padding: const EdgeInsets.all(AppConstants.spacing),
        child: Column(
          children: [
            CategoryCard(title: 'Могу', limit: 50000, spent: 25000),
            const SizedBox(height: AppConstants.spacing),
            CategoryCard(title: 'Хочу', limit: 30000, spent: 25000),
            const SizedBox(height: AppConstants.spacing),
            CategoryCard(title: 'Надо', limit: 20000, spent: 5000),
          ],
        ),
      ),
    );
  }
}
