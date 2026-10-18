# Calculadora Financeira Básica

Aplicativo Android para calcular juros simples, juros compostos e estimar investimentos com aportes mensais. Este guia explica como instalar e usar o arquivo APK, sem precisar instalar o Flutter ou conectar o celular ao computador.

## Instalar o aplicativo

### 1. Obtenha o APK

Baixe o arquivo APK fornecido pela pessoa ou pelo canal responsável pelo aplicativo. Se o arquivo foi enviado por link, faça o download no próprio celular ou transfira-o para o aparelho por USB. Por segurança, instale somente APKs de uma origem em que você confia.

### 2. Permita a instalação do arquivo

No Android, a autorização pode ser solicitada ao abrir o APK. Se isso acontecer:

1. Toque em **Configurações** na mensagem de bloqueio.
2. Ative **Permitir desta fonte** ou **Permitir instalação de apps**, para o navegador ou gerenciador de arquivos que está abrindo o APK.
3. Volte à tela do arquivo e toque novamente nele.

Em algumas versões do Android, essa opção fica em **Configurações > Apps > Acesso especial a apps > Instalar apps desconhecidos**. Os nomes e caminhos podem variar conforme a versão do Android e o fabricante. Se preferir, desative essa permissão depois da instalação.

### 3. Conclua a instalação

1. Abra o arquivo baixado, geralmente na pasta **Downloads**, usando a notificação de download ou o aplicativo **Arquivos**.
2. Confirme em **Instalar** e aguarde a conclusão.
3. Toque em **Abrir** ou localize **Calculadora Financeira** na lista de aplicativos do celular.

Se o Android informar que o aplicativo não pode ser instalado, confirme que o download terminou e que o arquivo é um APK válido. Apague um download incompleto e obtenha novamente o arquivo de uma fonte confiável. Caso já exista uma versão instalada e a atualização seja recusada, solicite ao responsável uma versão compatível; não remova a versão atual sem saber se isso apagará dados locais.

## Usar o aplicativo

Na tela inicial, toque em uma das três opções:

- **Juros simples**: calcula o crescimento linear de um valor inicial.
- **Juros compostos**: calcula o crescimento com juros incorporados ao saldo em cada capitalização.
- **Simulação de investimentos**: projeta o valor inicial junto com aportes mensais recorrentes.

Na tela da calculadora, informe os valores e toque em **Calcular**. O resultado aparece em reais, com o total futuro e o detalhamento dos valores investidos e dos juros. Para fazer outro cálculo na mesma modalidade, toque em **Limpar**. Use a seta no topo para voltar à tela inicial e escolher outra calculadora.

### Juros simples

1. Informe o **Valor inicial** em reais.
2. Informe a **Taxa de juros** em porcentagem e escolha se ela é **mensal** ou **anual**.
3. Informe o **Período** e escolha **meses** ou **anos**.
4. Toque em **Calcular**.

A taxa e o período precisam usar unidades coerentes. Por exemplo, para uma taxa mensal durante 6 meses, selecione **mensal** e **meses**.

### Juros compostos

1. Informe o **Valor inicial** em reais.
2. Informe a taxa percentual correspondente à frequência selecionada.
3. Escolha a frequência de capitalização: **mensal**, **trimestral**, **semestral** ou **anual**.
4. Informe o **Período** em meses ou anos e toque em **Calcular**.

Neste modo, a taxa informada é aplicada a cada período de capitalização escolhido. Por exemplo, para usar 1% ao mês por 2 anos, informe `1` como taxa, selecione **mensal** e informe `2` **anos**. Não informe uma taxa anual junto com a opção mensal, a menos que queira que esse percentual seja aplicado todos os meses.

### Simulação de investimentos

1. Informe o **Valor inicial** em reais.
2. Informe o **Aporte mensal** em reais. Para simular sem novos aportes, informe zero.
3. Informe a **Taxa de juros** em porcentagem e selecione se ela é **mensal** ou **anual**.
4. Informe o **Período** em meses ou anos e toque em **Calcular**.

O valor inicial rende desde o começo. Cada aporte é considerado no fim do mês correspondente. O resultado mostra o total aplicado (valor inicial mais aportes), os juros estimados e o valor futuro.

## Desenvolvimento

### Tecnologias e dependências

- Flutter com Dart SDK `^3.9.2`, interface Material e suporte às plataformas configuradas no projeto.
- `intl` para formatação de valores e `cupertino_icons` para ícones.
- `flutter_test` para testes e `flutter_lints` para análise estática.
