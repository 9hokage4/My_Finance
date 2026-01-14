import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Словарь ключевых слов -> категория
const Map<String, String> keywordToCategory = {
  // Обязательные
  'жильё': 'Обязательные',
  'аренда': 'Обязательные',
  'интернет': 'Обязательные',
  'лекарства': 'Обязательные',
  'еда': 'Обязательные',
  'продукты': 'Обязательные',
  'маганзин': 'Обязательные',
  'коммуналка': 'Обязательные',
  'кредит': 'Обязательные',
  'связь': 'Обязательные',
  'магнит': 'Обязательные',
  'пятерочка': 'Обязательные',
  'сигатеры': 'Обязательные',

  // Развлечения
  'кино': 'Развлечения',
  'цирк': 'Развлечения',
  'театр': 'Развлечения',
  'цветы': 'Развлечения',
  'одежда': 'Развлечения',
  'кафе': 'Развлечения',
  'ресторан': 'Развлечения',
  'обувь': 'Развлечения',

  // Накопления
  'подушка': 'Накопления',
  'сбережения': 'Накопления',
  'инвестиции': 'Накопления',
  'вклад': 'Накопления',
};

// Определяем категорию по описанию
String getCategoryFromDescription(String description) {
  final lowerDesc = description.toLowerCase();
  for (final entry in keywordToCategory.entries) {
    if (lowerDesc.contains(entry.key)) {
      return entry.value;
    }
  }
  // По умолчанию — развлечения
  return 'Развлечения';
}

// Модель дохода
class Income {
  final int? id;
  final double amount;
  final String source;
  final int date; // millisecondsSinceEpoch

  Income({
    this.id,
    required this.amount,
    required this.source,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'date': date,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      amount: map['amount'],
      source: map['source'],
      date: map['date'],
    );
  }
}

// Модель расхода
class Expense {
  final int? id;
  final double amount;
  final String description;
  final String category;
  final int date;

  Expense({
    this.id,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'category': category,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      category: map['category'],
      date: map['date'],
    );
  }
}

// Класс базы данных
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  late Database _db;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'finance_app.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Таблица доходов
        await db.execute('''
          CREATE TABLE income(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            source TEXT NOT NULL,
            date INTEGER NOT NULL
          )
        ''');

        // Таблица расходов
        await db.execute('''
          CREATE TABLE expense(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL NOT NULL,
            description TEXT NOT NULL,
            category TEXT NOT NULL,
            date INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // --- Доходы ---
  Future<int> insertIncome(Income income) {
    return _db.insert('income', income.toMap());
  }

  Future<List<Income>> getIncomes() async {
    final List<Map<String, dynamic>> maps = await _db.query('income');
    return List.generate(maps.length, (i) => Income.fromMap(maps[i]));
  }

  // --- Расходы ---
  Future<int> insertExpense(Expense expense) {
    return _db.insert('expense', expense.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final List<Map<String, dynamic>> maps = await _db.query('expense');
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }

  // Закрыть БД (опционально)
  Future<void> close() async => _db.close();

  // Удаление дохода по ID
  Future<int> deleteIncome(int id) {
    return _db.delete('income', where: 'id = ?', whereArgs: [id]);
  }

// Удаление расхода по ID
  Future<int> deleteExpense(int id) {
    return _db.delete('expense', where: 'id = ?', whereArgs: [id]);
  }
}

