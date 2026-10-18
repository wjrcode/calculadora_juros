import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/finance_calculator.dart';
import 'viewmodels/finance_view_model.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({
    super.key,
    required this.mode,
    required this.calculator,
  });

  final CalculationMode mode;
  final FinanceCalculator calculator;

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final _formKey = GlobalKey<FormState>();
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  final _periodController = TextEditingController();
  final _contributionController = TextEditingController();
  late final FinanceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = FinanceViewModel(widget.calculator, widget.mode);
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _periodController.dispose();
    _contributionController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _configFor(widget.mode);
    final isInvestment = widget.mode == CalculationMode.investment;
    final ratePeriods = widget.mode == CalculationMode.compound
        ? RatePeriod.values
        : const [RatePeriod.monthly, RatePeriod.annual];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          config.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                children: [
                  _LabeledNumberField(
                    controller: _principalController,
                    label: isInvestment ? 'Valor inicial' : 'Valor inicial',
                    prefix: 'R\$',
                    color: config.color,
                    currency: true,
                    onChanged: (_) => _viewModel.clear(),
                    validator: _validator('Informe o valor inicial'),
                  ),
                  if (isInvestment) ...[
                    const SizedBox(height: 11),
                    _LabeledNumberField(
                      controller: _contributionController,
                      label: 'Aporte mensal',
                      prefix: 'R\$',
                      color: config.color,
                      currency: true,
                      onChanged: (_) => _viewModel.clear(),
                      validator: _validator('Informe o aporte mensal'),
                    ),
                  ],
                  const SizedBox(height: 11),
                  _LabeledNumberField(
                    controller: _rateController,
                    label: 'Taxa de juros',
                    prefix: '%',
                    color: config.color,
                    trailing: _InlineSelect<RatePeriod>(
                      value: _viewModel.ratePeriod,
                      options: ratePeriods,
                      width: widget.mode == CalculationMode.compound ? 112 : 95,
                      onChanged: _viewModel.setRatePeriod,
                    ),
                    onChanged: (_) => _viewModel.clear(),
                    validator: _validator('Informe a taxa de juros'),
                  ),
                  if (isInvestment) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Interpretação da taxa',
                          style: TextStyle(fontSize: 11),
                        ),
                        const Spacer(),
                        _InlineSelect<RateConvention>(
                          value: _viewModel.rateConvention,
                          options: RateConvention.values,
                          width: 115,
                          onChanged: _viewModel.setRateConvention,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 11),
                  _LabeledNumberField(
                    controller: _periodController,
                    label: 'Período',
                    prefix: 'calendar',
                    color: config.color,
                    trailing: _InlineSelect<DurationUnit>(
                      value: _viewModel.durationUnit,
                      options: DurationUnit.values,
                      onChanged: _viewModel.setDurationUnit,
                    ),
                    onChanged: (_) => _viewModel.clear(),
                    validator: _validator('Informe o período', positive: true),
                  ),
                  if (widget.mode == CalculationMode.compound) ...[
                    const SizedBox(height: 6),
                    const Text(
                      'A taxa é aplicada a cada período selecionado.',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ],
                  const SizedBox(height: 17),
                  SizedBox(
                    height: 46,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: config.color,
                        foregroundColor: config.foreground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: _calculate,
                      child: const Text(
                        'Calcular',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: _clear,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: config.color,
                        side: BorderSide(color: config.color),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text(
                        'Limpar',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  AnimatedBuilder(
                    animation: _viewModel,
                    builder: (context, _) {
                      final result = _viewModel.result;
                      if (result == null) return const SizedBox.shrink();
                      return _ResultsPanel(
                        result: result,
                        config: config,
                        mode: widget.mode,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormFieldValidator<String> _validator(
    String message, {
    bool positive = false,
  }) {
    return (value) {
      final parsed = _parseNumber(value ?? '');
      if (parsed == null) return message;
      if (parsed < 0 || (positive && parsed == 0)) {
        return positive
            ? 'O período deve ser maior que zero'
            : 'Use um valor igual ou maior que zero';
      }
      return null;
    };
  }

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    _viewModel.calculate(
      principal: _parseNumber(_principalController.text)!,
      rate: _parseNumber(_rateController.text)!,
      duration: _parseNumber(_periodController.text)!,
      monthlyContribution: widget.mode == CalculationMode.investment
          ? _parseNumber(_contributionController.text)!
          : 0,
    );
  }

  void _clear() {
    _formKey.currentState?.reset();
    _principalController.clear();
    _rateController.clear();
    _periodController.clear();
    _contributionController.clear();
    _viewModel.clear();
    FocusScope.of(context).unfocus();
  }
}

class _LabeledNumberField extends StatelessWidget {
  const _LabeledNumberField({
    required this.controller,
    required this.label,
    required this.prefix,
    required this.color,
    required this.validator,
    this.trailing,
    this.currency = false,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String prefix;
  final Color color;
  final FormFieldValidator<String> validator;
  final Widget? trailing;
  final bool currency;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 4),
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          height: 43,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: color.withValues(alpha: 0.85)),
            borderRadius: BorderRadius.circular(11),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                width: 42,
                height: double.infinity,
                color: color,
                alignment: Alignment.center,
                child: prefix == 'calendar'
                    ? Icon(
                        Icons.calendar_month_rounded,
                        color: _prefixForeground(color),
                        size: 17,
                      )
                    : Text(
                        prefix,
                        style: TextStyle(
                          color: _prefixForeground(color),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    currency
                        ? BrazilianCurrencyInputFormatter()
                        : _DecimalInputFormatter(),
                  ],
                  validator: validator,
                  onChanged: onChanged,
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    filled: false,
                    hintText: '0,00',
                  ),
                ),
              ),
              if (trailing != null) ...[
                Container(
                  width: 1,
                  height: 27,
                  color: color.withValues(alpha: 0.28),
                ),
                trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InlineSelect<T> extends StatelessWidget {
  const _InlineSelect({
    required this.value,
    required this.options,
    required this.onChanged,
    this.width = 92,
  });

  final T value;
  final List<T> options;
  final ValueChanged<T> onChanged;
  final double width;

  String _label(T option) => switch (option) {
    RatePeriod period => period.label.toLowerCase(),
    DurationUnit unit => unit.label.toLowerCase(),
    RateConvention convention => convention.label.toLowerCase(),
    _ => option.toString(),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 17),
          padding: const EdgeInsets.only(left: 8, right: 5),
          style: const TextStyle(fontSize: 11, color: AppColors.muted),
          items: [
            for (final option in options)
              DropdownMenuItem<T>(
                value: option,
                child: Text(
                  _label(option),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: (next) {
            if (next != null) onChanged(next);
          },
        ),
      ),
    );
  }
}

class BrazilianCurrencyInputFormatter extends TextInputFormatter {
  static final _currency = NumberFormat('#,##0.00', 'pt_BR');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    if (digits.length > 15) return oldValue;
    final cents = int.parse(digits);
    final formatted = _currency.format(cents / 100);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.replaceAll(RegExp(r'[^0-9,.]'), '');
    if (filtered.split(RegExp(r'[,.]')).length > 2) return oldValue;
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

Color _prefixForeground(Color background) =>
    background == AppColors.lime ? AppColors.ink : Colors.white;

class _ResultsPanel extends StatelessWidget {
  const _ResultsPanel({
    required this.result,
    required this.config,
    required this.mode,
  });

  final FinanceResult result;
  final _ModeConfig config;
  final CalculationMode mode;

  static final _money = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: config.color,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resultado',
                style: TextStyle(
                  color: config.foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 9),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _money.format(result.futureValue),
                  style: TextStyle(
                    color: config.foreground,
                    fontSize: 22,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        const Text(
          'Detalhamento',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 7),
        _ResultRow(
          label: mode == CalculationMode.investment
              ? 'Total investido:'
              : 'Valor inicial:',
          value: result.investedAmount,
        ),
        _ResultRow(label: 'Total em juros:', value: result.interestAmount),
        _ResultRow(label: 'Total total:', value: result.futureValue),
        if (mode == CalculationMode.investment) ...[
          const SizedBox(height: 9),
          const Text(
            'Aportes no fim de cada mês. Rentabilidade não garantida.',
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final double value;

  static final _money = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Text(_money.format(value), style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ModeConfig {
  const _ModeConfig({
    required this.title,
    required this.description,
    required this.color,
    required this.foreground,
    required this.icon,
  });

  final String title;
  final String description;
  final Color color;
  final Color foreground;
  final IconData icon;
}

_ModeConfig _configFor(CalculationMode mode) => switch (mode) {
  CalculationMode.simple => const _ModeConfig(
    title: 'Juros Simples',
    description: 'Juros simples',
    color: AppColors.teal,
    foreground: Colors.white,
    icon: Icons.percent_rounded,
  ),
  CalculationMode.compound => const _ModeConfig(
    title: 'Juros Compostos',
    description: 'Juros compostos',
    color: AppColors.pink,
    foreground: Colors.white,
    icon: Icons.stacked_line_chart_rounded,
  ),
  CalculationMode.investment => const _ModeConfig(
    title: 'Simulação de investimentos',
    description: 'Investimentos',
    color: AppColors.lime,
    foreground: AppColors.ink,
    icon: Icons.savings_outlined,
  ),
};

double? _parseNumber(String raw) {
  var value = raw.trim().replaceAll(' ', '');
  if (value.isEmpty) return null;
  if (value.contains(',') && value.contains('.')) {
    value = value.replaceAll('.', '').replaceAll(',', '.');
  } else {
    value = value.replaceAll(',', '.');
  }
  return double.tryParse(value);
}
