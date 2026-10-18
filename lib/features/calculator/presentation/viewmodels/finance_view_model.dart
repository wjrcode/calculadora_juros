import 'package:flutter/foundation.dart';

import '../../domain/finance_calculator.dart';

class FinanceViewModel extends ChangeNotifier {
  FinanceViewModel(this._calculator, this.mode);

  final FinanceCalculator _calculator;
  final CalculationMode mode;

  FinanceResult? _result;
  FinanceResult? get result => _result;

  RatePeriod _ratePeriod = RatePeriod.monthly;
  RatePeriod get ratePeriod => _ratePeriod;

  RateConvention _rateConvention = RateConvention.effective;
  RateConvention get rateConvention => _rateConvention;

  DurationUnit _durationUnit = DurationUnit.years;
  DurationUnit get durationUnit => _durationUnit;

  void setRatePeriod(RatePeriod period) {
    _ratePeriod = period;
    _result = null;
    notifyListeners();
  }

  void setRateConvention(RateConvention convention) {
    _rateConvention = convention;
    _result = null;
    notifyListeners();
  }

  void setDurationUnit(DurationUnit unit) {
    _durationUnit = unit;
    _result = null;
    notifyListeners();
  }

  void calculate({
    required double principal,
    required double rate,
    required double duration,
    double monthlyContribution = 0,
  }) {
    _result = switch (mode) {
      CalculationMode.simple => _calculator.simpleInterest(
        principal: principal,
        ratePercent: rate,
        ratePeriod: _ratePeriod,
        years: duration * _durationUnit.yearsPerUnit,
      ),
      CalculationMode.compound => _calculator.compoundInterest(
        principal: principal,
        ratePerPeriodPercent: rate,
        years: duration * _durationUnit.yearsPerUnit,
        frequency: _ratePeriod,
      ),
      CalculationMode.investment => _calculator.investment(
        initialAmount: principal,
        monthlyContribution: monthlyContribution,
        ratePercent: rate,
        ratePeriod: _ratePeriod,
        months: duration * _durationUnit.yearsPerUnit * 12,
        rateConvention: _rateConvention,
      ),
    };
    notifyListeners();
  }

  void clear() {
    _result = null;
    notifyListeners();
  }
}
