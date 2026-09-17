#pragma once

#include <string>
#include "tokens.h"

using std::string;

// Carrega casos.txt para dentro da tabela de símbolos.
// Cada linha do arquivo tem o formato:
//   <categoria> palavra1 palavra2 palavra3 ...
// onde <categoria> é um dos nomes usados em categoria_para_tipo() (tabela.cpp).
void carregar_tabela(const string& caminho_casos);

// Insere uma palavra fixa na tabela com o tipo/categoria dado.
void inserir(int tipo, const string& palavra);

// Busca uma palavra na tabela.
// Retorna a categoria (ESTEREOTIPO_CLASSE, PALAVRA_RESERVADA, ...) se achar,
// ou CONSULTA (0) se a palavra não é uma palavra fixa da linguagem —
// nesse caso, quem chamou deve classificar por convenção de escrita.
int buscar(const string& palavra);
