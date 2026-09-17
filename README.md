# Analisador Léxico - TONTO (Textual Ontology Language)

Este projeto implementa um Analisador Léxico (Scanner) para a linguagem TONTO, construído como parte de avaliação da disciplina de Compiladores da Universidade Federal Rural do Semi-Árido (UFERSA).

O analisador foi desenvolvido em **C++** utilizando a ferramenta **Flex** para a geração do Autômato Finito Determinístico (DFA), e **CMake** para o gerenciamento do processo de *build*.

## Estrutura do Projeto

```text
tonto-compiler/
├── CMakeLists.txt     # Configuração do CMake
├── casos.txt          # Dicionário contendo as palavras fixas da linguagem
├── include/           # Arquivos de cabeçalho (.h)
│   ├── tabela.h
│   └── tokens.h
├── src/               # Código-fonte principal (.cpp)
│   └── tabela.cpp     # Lógica de carregamento do dicionário
├── tests/             # Diretório contendo os arquivos .tonto para teste
├── build/             # Diretório gerado para os artefatos de compilação
└── lexer.l            # Regras léxicas e expressões regulares (Flex)
```

# Tutorial de execução

### Instalação das dependências

Para compilar e executar o projeto, você precisará ter instalado em seu ambiente (Linux / WSL):

- GCC / G++ (Suporte a C++17)
- Flex (sudo apt-get install flex)
- CMake (sudo apt-get install cmake)
- Make (sudo apt-get install make)

### Baixar repositório do github
Abra o terminal a partir do diretorio em que deseja alocar o projeto e digite os seguintes comandos:
```bash
# Clonar repositorio na máquina local
git clone https://github.com/Lucassilv7/tonto_compiler.git

# Navegar para o diretório do projeto
cd CompTonto

# Abrir o VS Code
code 
```

### Build

Para gerar o executável do projeto, certifique-se de que está no diretório raiz do projeto e siga os seguintes passos no terminal

```bash
# 1. Acesse a pasta build (crie-a caso não exista):
mkdir -p build && cd build

# 2. Gere os arquivos de configuração do CMake:
cmake ..

# 3. Compile o projeto:
make 
```

### Execução
Para executar o projeto, siga os seguintes comandos no terminal:

```bash
# 1. Verifique em que diretório está (caso ainda esteja em build), execute o aquivo passando o conteudo de teste.tonto como argumaneto
./tonto ../tests/nome_do_arquivo.tonto

# 2. Caso tenha voltado para raiz `cd ..`, execute da seguinte forma ainda passando o conteudo de teste.tonto como argumento
build/tonto ../tests/nome_do_arquivo.tonto 
```
