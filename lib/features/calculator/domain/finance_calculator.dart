import 'dart:math' as math;

enum CalculationMode { simple, compound, investment }

enum RateConvention {
  effective('Efetiva'),
  nominal('Nominal');

  const RateConvention(this.label);

  final String label;
}

enum RatePeriod {
  monthly('Mensal', 12),
  quarterly('Trimestral', 4),
  semiannual('Semestral', 2),
  annual('Anual', 1);

  const RatePeriod(this.label, this.periodsPerYear);

  final String label;
  final int periodsPerYear;
}

enum DurationUnit {
  months('Meses', 1 / 12),
  years('Anos', 1);

  const DurationUnit(this.label, this.yearsPerUnit);

  final String label;
  final double yearsPerUnit;
}

class FinanceResult {
  const FinanceResult({
    required this.investedAmount,
    required this.interestAmount,
    required this.futureValue,
  });

  final double investedAmount;
  final double interestAmount;
  final double futureValue;
}

class FinanceCalculator {
  const FinanceCalculator();

  FinanceResult simpleInterest({
    required double principal,
    required double ratePercent,
    required RatePeriod ratePeriod,
    required double years,
  }) {
    final ratePeriodCount = years * ratePeriod.periodsPerYear;
    final interest = principal * (ratePercent / 100) * ratePeriodCount;
    return FinanceResult(
      investedAmount: principal,
      interestAmount: interest,
      futureValue: principal + interest,
    );
  }

  FinanceResult compoundInterest({
    required double principal,
    required double ratePerPeriodPercent,
    required double years,
    required RatePeriod frequency,
  }) {
    final periods = frequency.periodsPerYear;
    final ratePerPeriod = ratePerPeriodPercent / 100;
    final totalPeriods = years * periods;
    final futureValue = principal * _pow(1 + ratePerPeriod, totalPeriods);
    return FinanceResult(
      investedAmount: principal,
      interestAmount: futureValue - principal,
      futureValue: futureValue,
    );
  }

  FinanceResult investment({
    required double initialAmount,
    required double monthlyContribution,
    required double ratePercent,
    required RatePeriod ratePeriod,
    required double months,
    RateConvention rateConvention = RateConvention.effective,
  }) {
    final periodRate = ratePercent / 100;
    final monthlyRate = switch (rateConvention) {
      RateConvention.effective =>
        _pow(1 + periodRate, ratePeriod.periodsPerYear / 12) - 1,
      RateConvention.nominal => periodRate * ratePeriod.periodsPerYear / 12,
    };
    final growth = _pow(1 + monthlyRate, months);
    final completeMonths = months.floor();
    final fractionalMonth = months - completeMonths;
    final contributionFutureValue = monthlyRate == 0
        ? monthlyContribution * completeMonths
        : monthlyContribution *
              ((_pow(1 + monthlyRate, completeMonths.toDouble()) - 1) /
                  monthlyRate) *
              _pow(1 + monthlyRate, fractionalMonth);
    final futureValue = initialAmount * growth + contributionFutureValue;
    final invested = initialAmount + monthlyContribution * completeMonths;
    return FinanceResult(
      investedAmount: invested,
      interestAmount: futureValue - invested,
      futureValue: futureValue,
    );
  }

  double _pow(double base, double exponent) {
    return math.pow(base, exponent).toDouble();
  }
}
