import 'package:flutter/material.dart';
import 'package:my_finance/widgets/category_card.dart';

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
      appBar: AppBar(title: const Text('Мои финансы'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CategoryCard(title: 'Могу', limit: 50000, spent: 25000),
              const SizedBox(height: 16),
              CategoryCard(title: 'Хочу', limit: 30000, spent: 25000),
              const SizedBox(height: 16),
              CategoryCard(title: 'Надо', limit: 20000, spent: 5000),
            ],
          ),
        ),
      ),
    );
  }
}
