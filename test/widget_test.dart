// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_juros/main.dart';

void main() {
  testWidgets('home abre calculadora e mascara valores em reais', (
    tester,
  ) async {
    await tester.pumpWidget(const FinanceApp());

    expect(find.text('Calculadoras'), findsOneWidget);
    await tester.tap(find.text('Juros simples'));
    await tester.pumpAndSettle();

    expect(find.text('Valor inicial'), findsOneWidget);
    expect(find.text('Taxa de juros'), findsOneWidget);
    expect(find.text('mensal'), findsOneWidget);
    expect(find.text('anos'), findsOneWidget);
    expect(find.text('Calcular'), findsOneWidget);

    final principalField = find.byType(TextFormField).first;
    await tester.enterText(principalField, '123456');
    expect(
      tester.widget<TextFormField>(principalField).controller?.text,
      '1.234,56',
    );
  });

  testWidgets('oculta o resultado quando um valor é alterado', (tester) async {
    await tester.pumpWidget(const FinanceApp());

    await tester.tap(find.text('Juros simples'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '1000');
    await tester.enterText(fields.at(1), '5');
    await tester.enterText(fields.at(2), '1');
    await tester.tap(find.text('Calcular'));
    await tester.pumpAndSettle();

    expect(find.text('Resultado'), findsOneWidget);

    await tester.enterText(fields.at(0), '2000');
    await tester.pumpAndSettle();

    expect(find.text('Resultado'), findsNothing);
  });
}
