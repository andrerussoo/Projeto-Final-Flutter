# SabSaborêAplicativo de Receitas

## Descrição

O **Saborê** é um aplicativo mobile desenvolvido em Flutter que permite aos usuários descobrir, pesquisar e visualizar receitas de diferentes categorias.

O aplicativo utiliza a API pública DummyJSON Recipes para carregar as receitas, exibindo informações como imagem, ingredientes e modo de preparo.

## Funcionalidades

- **Página inicial:** exibe receitas disponíveis no aplicativo.
- **Listagem de receitas:** apresenta o nome e a imagem de cada receita.
- **Pesquisa:** permite pesquisar receitas pelo nome.
- **Categorias:** possibilita filtrar receitas por categorias.
- **Detalhes da receita:** apresenta ingredientes e instruções de preparo.
- **Favoritos:** permite adicionar e remover receitas dos favoritos.
- **Perfil:** possui uma tela dedicada ao perfil do usuário.
- **Tratamento de erros:** apresenta mensagens quando ocorre algum problema ao carregar as receitas.

## Tecnologias e dependências

- **Flutter:** framework utilizado para desenvolver a interface e a aplicação mobile.
- **Dart:** linguagem de programação utilizada no projeto.
- **HTTP (`http: ^1.6.0`):** biblioteca utilizada para realizar requisições à API.
- **Material Design:** utilizado na construção dos componentes visuais.

## SDK utilizado

- **Flutter SDK:** Flutter 3.47.7 
- **Dart SDK:** Dart 3.13.5


## API utilizada

O projeto utiliza a API pública **DummyJSON Recipes** para obter os dados das receitas.

Endereço: https://dummyjson.com/recipes

## Instruções de execução

### 1. Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- Flutter SDK
- Dart SDK
- Android Studio ou Visual Studio Code
- Emulador Android ou dispositivo físico

### 2. Clonar o repositório

```bash
git clone https://github.com/andrerussoo/Projeto-Final-Flutter.git
```

### 3. Entrar na pasta do projeto

```bash
cd primeiro_app
```

### 4. Instalar as dependências

```bash
flutter pub get
```

### 5. Verificar possíveis problemas

```bash
flutter analyze
```

### 6. Executar o aplicativo

```bash
flutter run
```

Também é possível abrir o projeto pelo Android Studio, selecionar um dispositivo ou emulador e clicar em **Run**.

## Estrutura do projeto

```text
lib/
├── main.dart
├── principal.dart
└── perfil.dart

pubspec.yaml
README.md
```

- `main.dart`: arquivo principal responsável por iniciar o aplicativo.
- `principal.dart`: contém as telas, funcionalidades e integração com a API de receitas.
- `perfil.dart`: contém a tela de perfil.
- `pubspec.yaml`: arquivo de configuração do projeto e suas dependências.

## Desenvolvido com

Projeto acadêmico desenvolvido utilizando Flutter e Dart.
