
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const azul = Color(0xFF2962A3);
const azulEscuro = Color(0xFF1E3550);
const azulClaro = Color(0xFFD6E7FA);
const fundo = Color(0xFFFAF7F0);

class Receita {
  final int id;
  final String nome;
  final String imagem;
  final String descricao;
  final int tempoPreparo;
  final int tempoCozimento;
  final int porcoes;
  final double avaliacao;
  final List<String> categorias;
  final List<String> ingredientes;
  final List<String> preparo;

  Receita({
    required this.id,
    required this.nome,
    required this.imagem,
    required this.descricao,
    required this.tempoPreparo,
    required this.tempoCozimento,
    required this.porcoes,
    required this.avaliacao,
    required this.categorias,
    required this.ingredientes,
    required this.preparo,
  });

  int get tempoTotal => tempoPreparo + tempoCozimento;

  factory Receita.fromJson(Map<String, dynamic> json) {
    return Receita(
      id: json['id'] ?? 0,
      nome: json['name'] ?? 'Receita sem nome',
      imagem: json['image'] ?? '',
      descricao: json['difficulty'] ?? 'Não informada',
      tempoPreparo: json['prepTimeMinutes'] ?? 0,
      tempoCozimento: json['cookTimeMinutes'] ?? 0,
      porcoes: json['servings'] ?? 0,
      avaliacao: (json['rating'] ?? 0).toDouble(),
      categorias: List<String>.from(json['mealType'] ?? []),
      ingredientes: List<String>.from(json['ingredients'] ?? []),
      preparo: List<String>.from(json['instructions'] ?? []),
    );
  }
}

class ReceitaApi {
  static const String baseUrl = 'https://dummyjson.com/recipes';

  static Future<List<Receita>> buscarTodas() async {
    final resposta = await http.get(
      Uri.parse('$baseUrl?limit=50'),
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final lista = dados['recipes'] as List;

      return lista.map((item) => Receita.fromJson(item)).toList();
    }

    throw Exception('Não foi possível carregar as receitas.');
  }

  static Future<List<Receita>> buscarPorNome(String nome) async {
    final url = Uri.parse('$baseUrl/search').replace(
      queryParameters: {'q': nome.trim()},
    );

    final resposta = await http.get(url);

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      final lista = dados['recipes'] as List;

      return lista.map((item) => Receita.fromJson(item)).toList();
    }

    throw Exception('Não foi possível pesquisar as receitas.');
  }


  static Future<Receita> buscarPorId(int id) async {
    final resposta = await http.get(Uri.parse('$baseUrl/$id'));

    if (resposta.statusCode == 200) {
      return Receita.fromJson(jsonDecode(resposta.body));
    }

    throw Exception('Não foi possível carregar os detalhes.');
  }
}


Widget tituloPagina(String titulo, String subtitulo) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: azulEscuro,
          ),
        ),
        const SizedBox(height: 5),
        Text(subtitulo),
      ],
    ),
  );
}


class CampoPesquisa extends StatefulWidget {
  final Function(String) onPesquisar;

  const CampoPesquisa({
    super.key,
    required this.onPesquisar,
  });

  @override
  State<CampoPesquisa> createState() => _CampoPesquisaState();
}

class _CampoPesquisaState extends State<CampoPesquisa> {
  final controller = TextEditingController();

  void pesquisar() {
    final nome = controller.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome de uma receita.'),
        ),
      );
      return;
    }

    widget.onPesquisar(nome);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nome da receita',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: azulEscuro,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onSubmitted: (_) => pesquisar(),
          decoration: InputDecoration(
            hintText: 'Buscar receitas...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: pesquisar,
            style: ElevatedButton.styleFrom(
              backgroundColor: azul,
              foregroundColor: Colors.white,
            ),
            child: const Text('Pesquisar'),
          ),
        ),
      ],
    );
  }
}


class MensagemErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback onTentarNovamente;

  const MensagemErro({
    super.key,
    required this.mensagem,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 45, color: azul),
          const SizedBox(height: 10),
          Text(mensagem, textAlign: TextAlign.center),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onTentarNovamente,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}


class CardReceita extends StatelessWidget {
  final Receita receita;
  final bool favorito;
  final VoidCallback onAbrir;
  final VoidCallback onFavoritar;

  const CardReceita({
    super.key,
    required this.receita,
    required this.favorito,
    required this.onAbrir,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        onTap: onAbrir,
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            receita.imagem,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 70,
                height: 70,
                color: azulClaro,
                child: const Icon(Icons.restaurant, color: azul),
              );
            },
          ),
        ),
        title: Text(
          receita.nome,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: azulEscuro,
          ),
        ),
        subtitle: Text(
          '${receita.tempoTotal} min • '
              '${receita.avaliacao.toStringAsFixed(1)} ⭐',
        ),
        trailing: IconButton(
          onPressed: onFavoritar,
          icon: Icon(
            favorito ? Icons.favorite : Icons.favorite_border,
            color: favorito ? Colors.red : azul,
          ),
        ),
      ),
    );
  }
}


class TelaInicio extends StatelessWidget {
  final List<Receita> receitas;
  final bool carregando;
  final String? erro;
  final Map<int, Receita> favoritos;
  final Function(String) onPesquisar;
  final Function(Receita) onAbrirReceita;
  final Function(Receita) onFavoritar;
  final VoidCallback onTentarNovamente;

  const TelaInicio({
    super.key,
    required this.receitas,
    required this.carregando,
    required this.erro,
    required this.favoritos,
    required this.onPesquisar,
    required this.onAbrirReceita,
    required this.onFavoritar,
    required this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          tituloPagina('Olá!', 'O que vamos cozinhar hoje?'),
          CampoPesquisa(onPesquisar: onPesquisar),
          const SizedBox(height: 25),
          const Text(
            'Receitas populares',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: azulEscuro,
            ),
          ),
          const SizedBox(height: 15),
          if (carregando)
            const Center(child: CircularProgressIndicator())
          else if (erro != null)
            MensagemErro(
              mensagem: erro!,
              onTentarNovamente: onTentarNovamente,
            )
          else if (receitas.isEmpty)
              const Center(child: Text('Nenhuma receita disponível.'))
            else
              ...receitas.take(5).map(
                    (receita) => CardReceita(
                  receita: receita,
                  favorito: favoritos.containsKey(receita.id),
                  onAbrir: () => onAbrirReceita(receita),
                  onFavoritar: () => onFavoritar(receita),
                ),
              ),
        ],
      ),
    );
  }
}


class TelaFavoritos extends StatelessWidget {
  final List<Receita> favoritos;
  final Function(Receita) onAbrirReceita;
  final Function(Receita) onFavoritar;

  const TelaFavoritos({
    super.key,
    required this.favoritos,
    required this.onAbrirReceita,
    required this.onFavoritar,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tituloPagina('Meus favoritos', 'Suas receitas preferidas.'),
            Expanded(
              child: favoritos.isEmpty
                  ? const Center(
                child: Text('Nenhuma receita favorita ainda.'),
              )
                  : ListView(
                children: favoritos.map((receita) {
                  return CardReceita(
                    receita: receita,
                    favorito: true,
                    onAbrir: () => onAbrirReceita(receita),
                    onFavoritar: () => onFavoritar(receita),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TelaReceitas extends StatefulWidget {
  final List<Receita> receitas;
  final bool carregando;
  final String? erro;
  final String termoPesquisa;
  final Map<int, Receita> favoritos;
  final Function(String) onPesquisar;
  final VoidCallback onLimpar;
  final Function(Receita) onAbrirReceita;
  final Function(Receita) onFavoritar;
  final VoidCallback onTentarNovamente;

  const TelaReceitas({
    super.key,
    required this.receitas,
    required this.carregando,
    required this.erro,
    required this.termoPesquisa,
    required this.favoritos,
    required this.onPesquisar,
    required this.onLimpar,
    required this.onAbrirReceita,
    required this.onFavoritar,
    required this.onTentarNovamente,
  });

  @override
  State<TelaReceitas> createState() => _TelaReceitasState();
}

class _TelaReceitasState extends State<TelaReceitas> {
  late TextEditingController controller;

  String categoriaSelecionada = 'Todas';

  final categorias = [
    'Todas',

  ];

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.termoPesquisa);
  }

  @override
  void didUpdateWidget(covariant TelaReceitas oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.termoPesquisa != widget.termoPesquisa) {
      controller.text = widget.termoPesquisa;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void pesquisar() {
    final nome = controller.text.trim();

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite o nome de uma receita.'),
        ),
      );
      return;
    }

    widget.onPesquisar(nome);
  }

  @override
  Widget build(BuildContext context) {

    final listaFiltrada = widget.receitas.where((receita) {
      if (categoriaSelecionada == 'Todas') {
        return true;
      }

      return receita.categorias.any(
            (categoria) =>
        categoria.toLowerCase() ==
            categoriaSelecionada.toLowerCase(),
      );
    }).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tituloPagina(
              'Todas as receitas',
              'Encontre sua próxima receita favorita.',
            ),
            TextField(
              controller: controller,
              onSubmitted: (_) => pesquisar(),
              decoration: InputDecoration(
                hintText: 'Nome da receita...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.clear();
                    widget.onLimpar();
                  },
                  icon: const Icon(Icons.close),
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: pesquisar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Pesquisar'),
              ),
            ),
            if (widget.termoPesquisa.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Pesquisa: "${widget.termoPesquisa}"'),
              ),
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: categorias.map((categoria) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(categoria),
                      selected: categoriaSelecionada == categoria,
                      onSelected: (_) {
                        setState(() {
                          categoriaSelecionada = categoria;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: widget.carregando
                  ? const Center(child: CircularProgressIndicator())
                  : widget.erro != null
                  ? MensagemErro(
                mensagem: widget.erro!,
                onTentarNovamente: widget.onTentarNovamente,
              )
                  : listaFiltrada.isEmpty
                  ? const Center(
                child: Text('Nenhuma receita encontrada.'),
              )
                  : ListView(
                children: listaFiltrada.map((receita) {
                  return CardReceita(
                    receita: receita,
                    favorito: widget.favoritos
                        .containsKey(receita.id),
                    onAbrir: () =>
                        widget.onAbrirReceita(receita),
                    onFavoritar: () =>
                        widget.onFavoritar(receita),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DetalhesReceita extends StatefulWidget {
  final Receita receita;
  final bool favorito;
  final VoidCallback onFavoritar;

  const DetalhesReceita({
    super.key,
    required this.receita,
    required this.favorito,
    required this.onFavoritar,
  });

  @override
  State<DetalhesReceita> createState() => _DetalhesReceitaState();
}

class _DetalhesReceitaState extends State<DetalhesReceita> {
  late bool favorito;

  @override
  void initState() {
    super.initState();
    favorito = widget.favorito;
  }

  @override
  Widget build(BuildContext context) {
    final receita = widget.receita;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da receita'),
        backgroundColor: fundo,
        foregroundColor: azulEscuro,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Image.network(
            receita.imagem,
            height: 220,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                color: azulClaro,
                child: const Icon(
                  Icons.restaurant,
                  size: 65,
                  color: azul,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            receita.nome,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: azulEscuro,
            ),
          ),
          const SizedBox(height: 10),
          Text('Dificuldade: ${receita.descricao}'),
          Text('Tempo total: ${receita.tempoTotal} minutos'),
          Text('Porções: ${receita.porcoes}'),
          Text('Avaliação: ${receita.avaliacao} ⭐'),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              widget.onFavoritar();
              setState(() {
                favorito = !favorito;
              });
            },
            icon: Icon(
              favorito ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            label: Text(
              favorito
                  ? 'Remover dos favoritos'
                  : 'Adicionar aos favoritos',
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ingredientes',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: azulEscuro,
            ),
          ),
          const SizedBox(height: 10),
          ...receita.ingredientes.map(
                (ingrediente) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: azul),
                  const SizedBox(width: 10),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Modo de preparo',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: azulEscuro,
            ),
          ),
          const SizedBox(height: 10),
          ...receita.preparo.asMap().entries.map(
                (passo) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: azulClaro,
                    child: Text('${passo.key + 1}'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(passo.value)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
