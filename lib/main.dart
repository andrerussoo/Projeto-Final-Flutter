
import 'package:flutter/material.dart';
import 'principal.dart';
import 'perfil.dart';

void main() {
  runApp(const ReceitasApp());
}

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saborê',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF7F0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2962A3),
        ),
      ),
      home: const Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int paginaSelecionada = 0;

  List<Receita> receitas = [];
  final Map<int, Receita> favoritos = {};

  bool carregando = false;
  String? erro;
  String termoPesquisa = '';

  @override
  void initState() {
    super.initState();
    carregarReceitas();
  }

  // CARREGAR RECEITAS DA API
  Future<void> carregarReceitas() async {
    setState(() {
      carregando = true;
      erro = null;
      termoPesquisa = '';
    });

    try {
      final resultado = await ReceitaApi.buscarTodas();

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = e.toString();
      });
    }
  }

  // PESQUISAR RECEITAS PELO NOME
  Future<void> pesquisarReceitas(String termo) async {
    final consulta = termo.trim();

    if (consulta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Digite o nome de uma receita para pesquisar.',
          ),
        ),
      );
      return;
    }

    setState(() {
      carregando = true;
      erro = null;
      termoPesquisa = consulta;
      paginaSelecionada = 2;
    });

    try {
      final resultado = await ReceitaApi.buscarPorNome(consulta);

      if (!mounted) return;

      setState(() {
        receitas = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
        erro = e.toString();
      });
    }
  }

  // ADICIONAR OU REMOVER FAVORITO
  void alterarFavorito(Receita receita) {
    setState(() {
      if (favoritos.containsKey(receita.id)) {
        favoritos.remove(receita.id);
      } else {
        favoritos[receita.id] = receita;
      }
    });
  }

  // ABRIR DETALHES DA RECEITA
  Future<void> abrirReceita(Receita receita) async {
    try {
      final detalhe = await ReceitaApi.buscarPorId(receita.id);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalhesReceita(
            receita: detalhe,
            favorito: favoritos.containsKey(detalhe.id),
            onFavoritar: () {
              alterarFavorito(detalhe);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Não foi possível abrir a receita: $e',
          ),
          action: SnackBarAction(
            label: 'Tentar novamente',
            onPressed: () {
              abrirReceita(receita);
            },
          ),
        ),
      );
    }
  }

  // LIMPAR PESQUISA
  Future<void> limparPesquisa() async {
    await carregarReceitas();

    if (!mounted) return;

    setState(() {
      paginaSelecionada = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final telas = [
      TelaInicio(
        receitas: receitas,
        carregando: carregando,
        erro: erro,
        favoritos: favoritos,
        onPesquisar: pesquisarReceitas,
        onAbrirReceita: abrirReceita,
        onFavoritar: alterarFavorito,
        onTentarNovamente: carregarReceitas,
      ),

      TelaFavoritos(
        favoritos: favoritos.values.toList(),
        onAbrirReceita: abrirReceita,
        onFavoritar: alterarFavorito,
      ),

      TelaReceitas(
        receitas: receitas,
        carregando: carregando,
        erro: erro,
        termoPesquisa: termoPesquisa,
        favoritos: favoritos,
        onPesquisar: pesquisarReceitas,
        onLimpar: limparPesquisa,
        onAbrirReceita: abrirReceita,
        onFavoritar: alterarFavorito,
        onTentarNovamente: () {
          if (termoPesquisa.isEmpty) {
            carregarReceitas();
          } else {
            pesquisarReceitas(termoPesquisa);
          }
        },
      ),

      const TelaPerfil(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: paginaSelecionada,
        children: telas,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaSelecionada,
        onDestinationSelected: (index) {
          setState(() {
            paginaSelecionada = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Receitas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
