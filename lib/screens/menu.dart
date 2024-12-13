import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senha_facil/services/autentication.dart';
import 'cadastrar_rede.dart'; // Importação da tela de cadastro

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

      final networks = await WiFiForIoTPlugin.loadWifiList();

      setState(() {
        wifiNetworks = networks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao buscar redes Wi-Fi: $e')),
      );
    }
  }

  Future<void> conectarRede(String ssid, String senha) async {
    try {
      bool conectado = await WiFiForIoTPlugin.isConnected();
      if (!conectado) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conecte-se a uma rede Wi-Fi primeiro')),
        );
        return;
      }

      if (senha.isEmpty) {
        conectado = await WiFiForIoTPlugin.connect(
          ssid,
          joinOnce: true,
        );
      } else {
        conectado = await WiFiForIoTPlugin.connect(
          ssid,
          password: senha,
          security: NetworkSecurity.WPA,
          joinOnce: true,
        );

        if (!conectado) {
          conectado = await WiFiForIoTPlugin.connect(
            ssid,
            password: senha,
            security: NetworkSecurity.NONE,
            joinOnce: true,
          );
        }
      }

      if (conectado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Conectado à rede $ssid com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao conectar à rede $ssid.')),
        );
      }
    } catch (e) {
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
        backgroundColor: Color(0xFF008C4A), // Tom de verde do iFood
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6CCF6D), // Tom de verde mais claro
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout,
                  color: Color(0xFF008C4A)), // Verde principal
              title: const Text(
                "Deslogar",
                style: TextStyle(color: Color(0xFF008C4A)), // Verde principal
              ),
              onTap: () {
                AutenticacaoServico().deslogar();
                Navigator.pop(context);
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
                  leading: const Icon(Icons.wifi,
                      color: Color(0xFF008C4A)), // Verde para o ícone
                  title:
                      Text(ssid, style: const TextStyle(color: Colors.black)),
                  tileColor: index % 2 == 0
                      ? const Color(0xFFF4F7F4) // Cor de fundo alternada
                      : Colors.white, // Cor de fundo alternada
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
                                  Navigator.pop(context);
                                  await conectarRede(ssid, senha);
                                },
                                child: const Text("Conectar"),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      // Redireciona para a tela de cadastro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastrarRede(nomeRede: ssid),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
