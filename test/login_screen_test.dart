import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:senha_facil/screens/login_screen.dart';
import 'mock_autenticacao_servico.dart';

void main() {
  testWidgets('Testa o fluxo de login com sucesso',
      (WidgetTester tester) async {
    // Criar um mock do serviço de autenticação
    final mockAutenticacao = MockAutenticacaoServico();

    // Simula o comportamento esperado do login
    when(mockAutenticacao.logarUsuario(
            email: "test@example.com", senha: "senha123"))
        .thenAnswer((_) async => null); // Login bem-sucedido

    // Carregar a tela de login
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(),
    ));

    // Preencher os campos de login
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'senha123');

    // Pressionar o botão de login
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Aguarda a execução da função assíncrona

    // Verificar se o login foi bem-sucedido
    expect(find.text('Credenciais inválidas'),
        findsNothing); // Nenhuma mensagem de erro
  });

  testWidgets('Testa o fluxo de login com falha', (WidgetTester tester) async {
    // Criar um mock do serviço de autenticação
    final mockAutenticacao = MockAutenticacaoServico();

    // Simula o comportamento do login com falha
    when(mockAutenticacao.logarUsuario(
            email: "test@example.com", senha: "senhaErrada"))
        .thenAnswer((_) async => "Credenciais inválidas");

    // Carregar a tela de login
    await tester.pumpWidget(MaterialApp(
      home: LoginScreen(),
    ));

    // Preencher os campos de login
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'senhaErrada');

    // Pressionar o botão de login
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Aguarda a execução da função assíncrona

    // Verificar se a mensagem de erro foi exibida
    expect(find.text("Credenciais inválidas"), findsOneWidget);
  });
}
