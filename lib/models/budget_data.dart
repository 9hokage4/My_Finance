class BudgetData {
  final Map<String, double> spent;
  final Map<String, double> limits;

  BudgetData({required this.spent, required this.limits});

  factory BudgetData.empty(){
    return BudgetData(
        spent: const {'Обязательные': 0.0, 'Развлечения': 0.0, 'Накопления': 0.0},
        limits: const {'Обязательные': 0.0, 'Развлечения': 0.0, 'Накопления': 0.0}
    );
  }
}