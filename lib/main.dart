import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_finance/models/budget_data.dart';

import 'widgets/category_card.dart';
import 'widgets/transaction_dialog.dart';

import 'package:my_finance/database/app_database.dart';



//  ГЛАВНАЯ СТРАНИЦА
class HomePage extends StatefulWidget {
  final DateTime initialMonth;
  final Function(DateTime) onMonthChanged;

  const HomePage({
    super.key,
    required this.initialMonth,
    required this.onMonthChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _currentDate;

  Future<BudgetData> _loadBudgetData(DateTime month) async {
    final db = AppDatabase();

    // Получаем доходы за месяц
    final incomes = await db.getIncomes();
    final monthlyIncomes = incomes.where((income) {
      final date = DateTime.fromMillisecondsSinceEpoch(income.date);
      return date.year == month.year && date.month == month.month;
    });
    final totalIncome = monthlyIncomes.fold(0.0, (sum, income) => sum + income.amount);

    // Рассчитываем лимиты
    final limits = {
      'Обязательные': totalIncome * 0.5,
      'Развлечения': totalIncome * 0.3,
      'Накопления': totalIncome * 0.2,
    };

    // Получаем расходы за месяц
    final expenses = await db.getExpenses();
    final monthlyExpenses = expenses.where((expense) {
      final date = DateTime.fromMillisecondsSinceEpoch(expense.date);
      return date.year == month.year && date.month == month.month;
    });

    final spent = {
      'Обязательные': 0.0,
      'Развлечения': 0.0,
      'Накопления': 0.0,
    };

    for (final expense in monthlyExpenses) {
      spent[expense.category] = (spent[expense.category] ?? 0.0) + expense.amount;
    }

    return BudgetData(spent: spent, limits: limits);
  }


  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialMonth;
  }

  String _formatMonthYear(DateTime date) {
    final formatted = DateFormat('LLLL yyyy', 'ru_RU').format(date);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  Future<void> _selectMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.blue),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _currentDate) {
      final newDate = DateTime(picked.year, picked.month, 1);
      setState(() {
        _currentDate = newDate;
      });
      widget.onMonthChanged(newDate); //  уведомляем MainScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _formatMonthYear(_currentDate);

    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () => _selectMonth(context),
          child: Text(
            monthName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<BudgetData>(
        future: _loadBudgetData(_currentDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? BudgetData.empty();

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = MediaQuery.sizeOf(context).width;
              final buttonSize = (width * 0.15).clamp(50.0, 70.0);
              final spacing = 16.0;

              return Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryCard(
                            category: 'Обязательные',
                            spent: data.spent['Обязательные'] ?? 0.0,
                            limit: data.limits['Обязательные'] ?? 0.0,
                          ),
                          const SizedBox(height: 16),
                          CategoryCard(
                            category: 'Развлечения',
                            spent: data.spent['Развлечения'] ?? 0.0,
                            limit: data.limits['Развлечения'] ?? 0.0,
                          ),
                          const SizedBox(height: 16),
                          CategoryCard(
                            category: 'Накопления',
                            spent: data.spent['Накопления'] ?? 0.0,
                            limit: data.limits['Накопления'] ?? 0.0,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // Кнопки
                  Positioned(
                    right: spacing,
                    bottom: spacing + MediaQuery.viewPaddingOf(context).bottom,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => TransactionDialog(isIncome: true),
                            );
                            // После добавления — обновляем данные
                            setState(() {});
                          },
                          child: Container(
                            width: buttonSize,
                            height: buttonSize,
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.attach_money, color: Colors.white, size: 30),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (ctx) => TransactionDialog(isIncome: false),
                            );
                            setState(() {}); //  обновляем карточки
                          },
                          child: Container(
                            width: buttonSize,
                            height: buttonSize,
                            decoration: BoxDecoration(
                              color: Colors.orange[800],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
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
          );
        },
      ),
    );
  }
}

// СТРАНИЦА ИСТОРИИ
class HistoryPage extends StatefulWidget {
  final DateTime month;

  const HistoryPage({super.key, required this.month});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Future<List<dynamic>> _getTransactionsForMonth(DateTime month) async {
    final db = AppDatabase();
    final incomes = await db.getIncomes();
    final expenses = await db.getExpenses();

    final filteredIncomes = incomes.where((income) {
      final date = DateTime.fromMillisecondsSinceEpoch(income.date);
      return date.year == month.year && date.month == month.month;
    }).map((i) => {'type': 'income', 'data': i});

    final filteredExpenses = expenses.where((expense) {
      final date = DateTime.fromMillisecondsSinceEpoch(expense.date);
      return date.year == month.year && date.month == month.month;
    }).map((e) => {'type': 'expense', 'data': e});

    final all = <dynamic>[...filteredIncomes, ...filteredExpenses]
      ..sort((a, b) => (b['data'] as dynamic).date.compareTo((a['data'] as dynamic).date));

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getTransactionsForMonth(widget.month),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          final transactions = snapshot.data!;
          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'Нет операций за ${widget.month.month.toString().padLeft(2, '0')}.${widget.month.year}',
              ),
            );
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final item = transactions[index];
              final isIncome = item['type'] == 'income';
              final data = item['data'];
              final amount = data.amount;
              final description = isIncome ? data.source : data.description;
              final date = DateTime.fromMillisecondsSinceEpoch(data.date);
              final id = data.id!;

              return Dismissible(
                key: Key('$isIncome-$id'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Подтверждение'),
                      content: Text(
                        isIncome
                            ? 'Удалить доход "${description}"?'
                            : 'Удалить расход "${description}"?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Отмена'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text('Удалить', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final db = AppDatabase();
                    if (isIncome) {
                      await db.deleteIncome(id);
                    } else {
                      await db.deleteExpense(id);
                    }

                    if (!mounted) return false;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isIncome ? 'Доход удалён' : 'Расход удалён'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }

                  return confirmed == true;
                },
                child: ListTile(
                  title: Text(description),
                  subtitle: Text(
                    '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
                  ),
                  trailing: Text(
                    (isIncome ? '+' : '-') + ' ${amount.toInt()}',
                    style: TextStyle(
                      color: isIncome ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// НАВИГАЦИЯ
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime _selectedMonth = DateTime.now(); // ← общее состояние месяца

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMonthChanged(DateTime newMonth) {
    setState(() {
      _selectedMonth = DateTime(newMonth.year, newMonth.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? HomePage(onMonthChanged: _onMonthChanged, initialMonth: _selectedMonth)
          : HistoryPage(month: _selectedMonth),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'История'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

//  ОСНОВНОЕ ПРИЛОЖЕНИЕ
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ru_RU', null);

  // Инициализируем БД один раз
  final db = AppDatabase();
  await db.init();

  runApp(const FinanceApp());
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(useMaterial3: true),
      home: MainScreen(),
    );
  }
}