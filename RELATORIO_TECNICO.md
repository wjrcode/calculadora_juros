# Relatório técnico — Calculadora Financeira

## Visão geral

Aplicativo em Flutter e Dart para estimar juros simples, juros compostos e o crescimento de investimentos com aportes mensais. A interface permite informar valores, taxa, frequência e duração, e apresenta o valor aplicado, os juros estimados e o valor futuro. Os resultados são estimativas e não constituem recomendação financeira.

## Tecnologias e organização

- **Flutter / Dart** (`sdk: ^3.9.2`): interface multiplataforma com Material Design.
- **intl**: formatação de valores monetários.
- **flutter_test** e **flutter_lints**: testes automatizados e análise estática.

O código segue uma separação simples por responsabilidades:

- `lib/main.dart`: inicializa o app, tema e tela inicial.
- `lib/features/home/presentation/home_view.dart`: apresenta as modalidades e navegação.
- `lib/features/calculator/presentation/calculator_view.dart`: formulário, validação e exibição dos resultados.
- `lib/features/calculator/presentation/viewmodels/finance_view_model.dart`: converte unidades e coordena as operações da calculadora.
- `lib/features/calculator/domain/finance_calculator.dart`: contém os modelos, convenções e fórmulas financeiras, sem dependência da interface.
- `lib/core/theme/`: componentes visuais e tema.

## Regras de cálculo

- **Juros simples:** `juros = capital × taxa × número de períodos`; o montante é capital mais juros, sem capitalização.
- **Juros compostos:** `montante = capital × (1 + taxa)^n`, em que `n` considera a frequência selecionada (mensal, trimestral, semestral ou anual).
- **Investimentos:** capital inicial capitalizado mais o valor futuro dos aportes mensais. A taxa pode ser interpretada como efetiva ou nominal; a taxa da frequência informada é convertida para equivalente mensal. Os aportes são considerados no fim dos meses completos. A fração de mês, quando houver, capitaliza o saldo, sem incluir novo aporte.

As taxas são informadas em porcentagem. A duração pode ser expressa em meses ou anos; o app converte os valores para a unidade necessária em cada cálculo.