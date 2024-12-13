import 'package:senha_facil/services/autentication.dart';

class MockAutenticacaoServico extends AutenticacaoServico {
  @override
  Future<String?> logarUsuario(
      {required String email, required String senha}) async {
    // Simula um login bem-sucedido ou com erro.
    if (email == "test@example.com" && senha == "senha123") {
      return null; // Login bem-sucedido
    } else {
      return "Credenciais inválidas";
    }
  }

  @override
  Future<String?> cadastrarUsuario(
      {required String nome,
      required String email,
      required String senha}) async {
    // Simula um cadastro bem-sucedido ou com erro.
    if (email == "test@example.com") {
      return "E-mail já cadastrado";
    }
    return null; // Cadastro bem-sucedido
  }
}
