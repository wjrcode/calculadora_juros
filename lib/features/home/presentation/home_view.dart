import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../calculator/domain/finance_calculator.dart';
import '../../calculator/presentation/calculator_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.calculator});

  final FinanceCalculator calculator;

  @override
  Widget build(BuildContext context) {
    final options = [
      _CalculatorOption(
        mode: CalculationMode.simple,
        title: 'Juros simples',
        description: 'Calcule os juros e o montante de uma aplicação linear.',
        icon: Icons.percent_rounded,
        color: AppColors.teal,
        chip: 'Rende de forma linear',
      ),
      _CalculatorOption(
        mode: CalculationMode.compound,
        title: 'Juros compostos',
        description: 'Veja o efeito dos juros sobre juros ao longo do tempo.',
        icon: Icons.stacked_line_chart_rounded,
        color: AppColors.pink,
        chip: 'Juros sobre juros',
      ),
      _CalculatorOption(
        mode: CalculationMode.investment,
        title: 'Simulação de investimentos',
        description: 'Projete o valor futuro com aportes mensais recorrentes.',
        icon: Icons.savings_outlined,
        color: const Color(0xFF8CB400),
        chip: 'Aportes mensais',
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 760;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    wide ? 36 : 22,
                    32,
                    wide ? 36 : 22,
                    32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.ink,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.calculate_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Calculadoras',
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Cálculos financeiros simples e claros',
                                  style: TextStyle(color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'O que você quer calcular?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (wide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final option in options)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 14),
                                  child: _OptionCard(
                                    option: option,
                                    onTap: () => _open(context, option.mode),
                                  ),
                                ),
                              ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            for (final option in options) ...[
                              _OptionCard(
                                option: option,
                                onTap: () => _open(context, option.mode),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        'Os valores são estimativas e não constituem recomendação financeira.',
                        style: TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _open(BuildContext context, CalculationMode mode) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CalculatorView(mode: mode, calculator: calculator),
      ),
    );
  }
}

class _CalculatorOption {
  const _CalculatorOption({
    required this.mode,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.chip,
  });

  final CalculationMode mode;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String chip;
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.option, required this.onTap});

  final _CalculatorOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          constraints: const BoxConstraints(minHeight: 190),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: option.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(option.icon, color: option.color),
              ),
              const SizedBox(height: 16),
              Text(
                option.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                option.description,
                style: const TextStyle(color: AppColors.muted, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      option.chip,
                      style: TextStyle(
                        color: option.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: option.color,
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
