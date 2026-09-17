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

##