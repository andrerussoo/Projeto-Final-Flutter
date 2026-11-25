
import 'package:flutter/material.dart';
import 'principal.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tituloPagina(
              'Meu perfil',
              'Informações e configurações.',
            ),

            const SizedBox(height: 20),

            const Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: azulClaro,
                child: Icon(
                  Icons.person,
                  size: 65,
                  color: azul,
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                'Usuário',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: azulEscuro,
                ),
              ),
            ),

            const Center(
              child: Text(
                'Bem-vindo ao Receitas!',
                style: TextStyle(fontSize: 15),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              color: Colors.white,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: azul,
                    ),
                    title: const Text('Meus dados'),
                    subtitle: const Text(
                      'Informações do usuário',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Área de dados em desenvolvimento.',
                          ),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: azul,
                    ),
                    title: const Text('Notificações'),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Configurações em desenvolvimento.',
                          ),
                        ),
                      );
                    },
                  ),

                  const Divider(height: 1),

                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: azul,
                    ),
                    title: const Text('Sobre o aplicativo'),
                    subtitle: const Text(
                      'Receitas - Versão 1.0',
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Receitas',
                        applicationVersion: '1.0',
                        applicationLegalese:
                        'Aplicativo de receitas.',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
