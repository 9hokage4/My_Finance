import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
  switch (category) {
    case 'Mogu':
      return Colors.blue;
    case 'Hochu':
      return Colors.orange;
    case 'Nado':
      return Colors.green;
    default:
      return Colors.grey;
  }
}