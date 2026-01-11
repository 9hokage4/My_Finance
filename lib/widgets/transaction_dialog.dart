import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  final bool isIncome; // true = доход, false = расход

  const TransactionDialog({super.key, required this.isIncome});

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final amountText = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Заполните все поля')),
      );
      return;
    }

    // Проверка, что сумма — число
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректную сумму')),
      );
      return;
    }

    // Передаём данные обратно (пока просто печатаем)
    Navigator.of(context).pop({
      'amount': amount,
      'description': description,
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isIncome ? 'Новый доход' : 'Новый расход';
    final descriptionHint = widget.isIncome ? 'Источник (зарплата, подарок...)' : 'Описание (продукты, кино...)';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Поле суммы (только цифры)
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Сумма',
                hintText: '1000',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // Поле описания/источника
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: widget.isIncome ? 'Источник' : 'Описание',
                hintText: descriptionHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () => _onSubmit(context),
          child: const Text('Добавить'),
        ),
      ],
    );
  }
}