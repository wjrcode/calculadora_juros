import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/calculator/domain/finance_calculator.dart';
import 'features/home/presentation/home_view.dart';

void main() => runApp(const FinanceApp());

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Financeira',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: HomeView(calculator: const FinanceCalculator()),
    );
  }
}
