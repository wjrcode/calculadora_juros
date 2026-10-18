import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_juros/features/calculator/domain/finance_calculator.dart';

void main() {
  const calculator = FinanceCalculator();

  group('FinanceCalculator', () {
    test('calcula juros simples sem capitalizar os juros', () {
      final result = calculator.simpleInterest(
        principal: 1000,
        ratePercent: 5,
        ratePeriod: RatePeriod.annual,
        years: 2,
      );

      expect(result.interestAmount, closeTo(100, 0.000001));
      expect(result.futureValue, closeTo(1100, 0.000001));
      expect(result.investedAmount, 1000);
    });

    test('aplica a frequência escolhida nos juros compostos', () {
      final result = calculator.compoundInterest(
        principal: 1000,
        ratePerPeriodPercent: 1,
        years: 1,
        frequency: RatePeriod.monthly,
      );

      expect(result.futureValue, closeTo(1126.825030, 0.00001));
      expect(result.interestAmount, closeTo(126.825030, 0.00001));
    });

    test('simula aporte no fim de cada mês e taxa zero', () {
      final result = calculator.investment(
        initialAmount: 1000,
        monthlyContribution: 100,
        ratePercent: 0,
        ratePeriod: RatePeriod.monthly,
        months: 12,
      );

      expect(result.investedAmount, 2200);
      expect(result.futureValue, 2200);
      expect(result.interestAmount, 0);
    });

    test('capitaliza saldo inicial e aportes mensais', () {
      final result = calculator.investment(
        initialAmount: 1000,
        monthlyContribution: 100,
        ratePercent: 1,
        ratePeriod: RatePeriod.monthly,
        months: 12,
      );

      expect(result.investedAmount, 2200);
      expect(result.futureValue, closeTo(2395.077, 0.01));
      expect(result.interestAmount, closeTo(195.077, 0.01));
    });

    test('converte taxa anual para equivalente mensal na simulação', () {
      final result = calculator.investment(
        initialAmount: 0,
        monthlyContribution: 100,
        ratePercent: 12,
        ratePeriod: RatePeriod.annual,
        months: 12,
      );

      expect(result.futureValue, closeTo(1268.25, 0.01));
    });
  });
}
