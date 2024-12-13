import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastrarRede extends StatefulWidget {
  final String? nomeRede;

  const CadastrarRede({Key? key, this.nomeRede}) : super(key: key);

  @override
  _CadastrarRedeState createState() => _CadastrarRedeState();
}

class _CadastrarRedeState extends State<CadastrarRede> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> salvarRede() async {
    final nomeRede = widget.nomeRede ?? '';

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('redes_wifi')
          .where('nome', isEqualTo: nomeRede)
          .get();

      if (snapshot.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rede já cadastrada.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('redes_wifi').add({
        'nome': nomeRede,
        'senha': _senhaController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rede cadastrada com sucesso!')),
      );

      Navigator.pop(context); // Fecha a tela de cadastro
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar a rede: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Rede"),
        backgroundColor: Colors.green, // Alterado para verde
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.nomeRede,
                decoration: const InputDecoration(
                  labelText: "Nome da Rede",
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _senhaController,
                decoration: const InputDecoration(
                  labelText: "Senha da Rede",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, insira a senha.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Atribuindo a cor diretamente
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    salvarRede();
                  }
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
