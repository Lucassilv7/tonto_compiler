#include "tabela.h"

#include <fstream>
#include <iostream>
#include <sstream>
#include <unordered_map>

using namespace std;

static unordered_map<string, int> tabela;
static unordered_map<string, Simbolo> tabela_sintatica;

void inserir(int tipo, const string& palavra) {
    tabela[palavra] = tipo;
}

int buscar(const string& palavra) {
    auto it = tabela.find(palavra);
    return (it != tabela.end()) ? it->second : CONSULTA;
}

// Nome da categoria (1ª palavra da linha em casos.txt) -> código em tokens.h
static int categoria_para_tipo(const string& categoria) {
    static const unordered_map<string, int> categorias = {
        {"estereotipo_classe",  ESTEREOTIPO_CLASSE},
        {"estereotipo_relacao", ESTEREOTIPO_RELACAO},
        {"palavra_reservada",   PALAVRA_RESERVADA},
        {"tipo_nativo",         TIPO_NATIVO},
        {"meta_atributo",       META_ATRIBUTO},
    };
    auto it = categorias.find(categoria);
    return (it != categorias.end()) ? it->second : CONSULTA;
}

void carregar_tabela(const string& caminho_casos) {
    ifstream arquivo(caminho_casos);
    if (!arquivo.is_open()) {
        cerr << "Erro ao abrir o arquivo: " << caminho_casos << endl;
        return;
    }

    string linha;
    while (getline(arquivo, linha)) {
        istringstream ss(linha);
        string categoria;
        if (!(ss >> categoria)) continue; // linha em branco
        
        int tipo = categoria_para_tipo(categoria);
        if (tipo == CONSULTA) {
            cerr << "Categoria desconhecida: " << categoria << endl;
            continue;
        }

        string palavra;
        while (ss >> palavra) {
            inserir(tipo, palavra);
        }
    }
}

void inserir_simbolo_sintatico(const string& nome, const string& categoria, const string& escopo) {
    string chave = escopo + "::" + nome;
    tabela_sintatica[chave] = {nome, categoria, escopo};
}

void imprimir_relatorio_sintatico(){
    cout << "\n=========================================\n";
    cout << "  RELATORIO DE ANALISE SINTATICA (TONTO) \n";
    cout << "=========================================\n";

    int qtd_pacotes = 0, qtd_classes = 0, qtd_relacoes = 0;

    for (const auto& par : tabela_sintatica) {
        const Simbolo& s = par.second;
        cout << "[" << s.categoria << "] " << s.nome << " (Escopo: " << s.escopo << ")\n";
        
        if (s.categoria.find("PACOTE") != string::npos) qtd_pacotes++;
        else if (s.categoria.find("CLASSE") != string::npos) qtd_classes++;
        else if (s.categoria.find("RELACAO") != string::npos) qtd_relacoes++;
        else if (s.categoria.find("ENUM") != string::npos) qtd_classes++; // Conta Enum como classe
    }

    cout << "-----------------------------------------\n";
    cout << "Resumo:\n";
    cout << "- Pacotes: " << qtd_pacotes << "\n";
    cout << "- Classes: " << qtd_classes << "\n";
    cout << "- Relacoes: " << qtd_relacoes << "\n";
    cout << "=========================================\n";
}