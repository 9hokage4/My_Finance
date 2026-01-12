import 'package:flutter/material.dart';

class TransactionDialog extends StatefulWidget {
  final bool isIncome;

  const TransactionDialog({super.key, required this.isIncome});

  @override
  State<TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  FocusNode _descriptionFocusNode = FocusNode();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final amountText = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (amountText.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Заполните все поля'),
          backgroundColor: Colors.grey[800],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      );
      return;
    }

    final amount = double.tryParse(amountText.replaceAll(' ', '').replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Сумма должна быть больше 0'),
          backgroundColor: Colors.grey[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.of(context).pop({'amount': amount, 'description': description});
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isIncome ? 'Новый доход' : 'Новый расход';
    final descriptionHint = widget.isIncome ? 'Источник (зарплата, подарок...)' : 'Описание (продукты, кино...)';
    final detailedHint = widget.isIncome
        ? 'Укажите источник дохода'
        : 'Например: аптека, билет в кино, цветы';

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Поле "Сумма"
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.attach_money, size: 20, color: Colors.grey),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),

            // Поле "Описание / Источник"
            TextField(
              controller: _descriptionController,
              focusNode: _descriptionFocusNode,
              decoration: InputDecoration(
                hintText: _descriptionFocusNode.hasFocus ? detailedHint : descriptionHint,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.description, size: 20, color: Colors.grey),
                prefixIconConstraints: const BoxConstraints(minWidth: 40),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),

            // Кнопка "Добавить"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onSubmit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.isIncome ? Colors.green[600] : Colors.orange[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Добавить', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),

            // Кнопка "Отмена"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // прозрачный фон
                  shadowColor: Colors.transparent,     // без тени
                  elevation: 0,
                  side: const BorderSide(color: Colors.grey, width: 2.0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      elevation: 2,
    );
  }
}