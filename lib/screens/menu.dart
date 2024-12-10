import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senha_facil/services/autentication.dart';

class InicioTela extends StatefulWidget {
  const InicioTela({super.key});

  @override
  State<InicioTela> createState() => _InicioTelaState();
}

class _InicioTelaState extends State<InicioTela> {
  List<WifiNetwork> wifiNetworks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWifiNetworks();
  }

  Future<void> fetchWifiNetworks() async {
    try {
      bool isWifiEnabled = await WiFiForIoTPlugin.isEnabled();
      if (!isWifiEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wi-Fi desativado. Ative o Wi-Fi para continuar.'),
          ),
        );
        return;
      }

      print('Wi-Fi está habilitado. Buscando redes...');
      final networks = await WiFiForIoTPlugin.loadWifiList();
      print('Redes encontradas: ${networks.length}');

      setState(() {
        wifiNetworks = networks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao buscar redes Wi-Fi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar redes Wi-Fi: $e')),
      );
    }
  }

  Future<void> conectarRede(String ssid, String senha) async {
    try {
      print('Tentando conectar à rede: $ssid com senha: $senha');

      // Verifica se o dispositivo está conectado a alguma rede Wi-Fi
      bool conectado = await WiFiForIoTPlugin.isConnected();
      if (!conectado) {
        print('O dispositivo não está conectado à uma rede Wi-Fi');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conecte-se a uma rede Wi-Fi primeiro')),
        );
        return;
      }

      // Tenta conectar à rede Wi-Fi com a senha fornecida
      if (senha.isEmpty) {
        // Conectar sem senha se a rede não exigir
        conectado = await WiFiForIoTPlugin.connect(
          ssid,
          joinOnce: true, // Conectar sem precisar de senha
        );
      } else {
        // Tente conectar com WPA ou sem segurança, se WPA falhar
        conectado = await WiFiForIoTPlugin.connect(
          ssid,
          password: senha,
          security: NetworkSecurity.WPA,
          joinOnce: true,
        );

        if (!conectado) {
          print('Falha ao conectar com WPA, tentando sem segurança');
          conectado = await WiFiForIoTPlugin.connect(
            ssid,
            password: senha,
            security: NetworkSecurity.NONE, // Tentar sem segurança
            joinOnce: true,
          );
        }
      }

      if (conectado) {
        print('Conectado à rede $ssid com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conectado à rede $ssid com sucesso!')),
        );
      } else {
        print('Falha ao conectar à rede $ssid');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao conectar à rede $ssid.')),
        );
      }
    } catch (e) {
      print('Erro durante a conexão à rede $ssid: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro durante a conexão: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redes Wi-Fi Disponíveis"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              onTap: () {
                AutenticacaoServico().deslogar();
                Navigator.pop(context); // Fecha o menu
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: wifiNetworks.length,
              itemBuilder: (context, index) {
                final localNetwork = wifiNetworks[index];
                final ssid = localNetwork.ssid ?? "SSID desconhecido";

                return ListTile(
                  leading: const Icon(Icons.wifi),
                  title: Text(ssid),
                  onTap: () async {
                    print('Rede selecionada: $ssid');
                    final snapshot = await FirebaseFirestore.instance
                        .collection('redes_wifi')
                        .where('nome', isEqualTo: ssid)
                        .get();

                    if (snapshot.docs.isNotEmpty) {
                      final senha =
                          snapshot.docs.first['senha'] as String? ?? '';

                      if (senha.isEmpty) {
                        await conectarRede(ssid, senha);
                      } else {
                        // Se houver senha, mostrar a tela de conexão
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Conectar à Rede"),
                            content: Text("Deseja se conectar à rede '$ssid'?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancelar"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Fecha o diálogo
                                  await conectarRede(ssid, senha);
                                },
                                child: const Text("Conectar"),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      // Caso a rede não seja encontrada no Firestore
                      print('Rede não encontrada no Firestore.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Rede não cadastrada.')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
