%{
#include <iostream>
#include <string>
#include "tabela.h"

using namespace std;

extern int yylex();
extern int linha;
extern int coluna;
extern char* yytext;
extern FILE* yyin;

void yyerror(const char* s);

string pacote_atual = "global";
%}

%define api.value.type {std::string}

%token ESTEREOTIPO_CLASSE ESTEREOTIPO_RELACAO PALAVRA_RESERVADA
%token TIPO_NATIVO META_ATRIBUTO TIPO_NOVO
%token CONV_CLASSE CONV_RELACAO CONV_INSTANCIA ERRO_LEXICO

%start ontologia

%%

/* 1. Raiz do Documento */
ontologia:
    /* vazio */
    | ontologia construto
    ;

/* 2. Construtos Principais */
construto:
    declaracao_pacote_ou_import
    | declaracao_classe
    | declaracao_enum
    | declaracao_genset
    | declaracao_relacao
    | error { yyerrok; yyclearin; } 
    ;

/* 3. Pacotes e Imports */
declaracao_pacote_ou_import:
    PALAVRA_RESERVADA CONV_CLASSE {
        if ($1 == "package") {
            pacote_atual = $2;
            inserir_simbolo_sintatico($2, "PACOTE", "global");
        } else if ($1 == "import") {
            inserir_simbolo_sintatico($2, "IMPORT", "global");
        }
    }
    ;

/* 4. Classes e Relatores */
declaracao_classe:
    /* Classe simples: kind Person */
    ESTEREOTIPO_CLASSE CONV_CLASSE {
        inserir_simbolo_sintatico($2, "CLASSE (" + $1 + ")", pacote_atual);
    }
    /* Classe com herança: role Employee specializes Person */
    | ESTEREOTIPO_CLASSE CONV_CLASSE CONV_RELACAO CONV_CLASSE {
        if ($3 == "specializes") {
            inserir_simbolo_sintatico($2, "CLASSE (Subclasse de " + $4 + ")", pacote_atual);
        }
    }
    /* Classe com bloco interno: kind Vacina { ... } */
    | ESTEREOTIPO_CLASSE CONV_CLASSE '{' conteudo_generico '}' {
        inserir_simbolo_sintatico($2, "CLASSE (Com Atributos)", pacote_atual);
    }
    /* Relator com bloco: relator Vacinacao { ... } */
    | CONV_RELACAO CONV_CLASSE '{' conteudo_generico '}' {
        inserir_simbolo_sintatico($2, "CLASSE (" + $1 + ")", pacote_atual);
    }
    ;

/* 5. Classes Enumeradas (enum Nome { Instancia1, Instancia2 }) */
declaracao_enum:
    CONV_RELACAO CONV_CLASSE '{' lista_instancias '}' {
        if ($1 == "enum") {
            inserir_simbolo_sintatico($2, "ENUM", pacote_atual);
        }
    }
    ;

lista_instancias:
    CONV_INSTANCIA { inserir_simbolo_sintatico($1, "INSTANCIA DO ENUM", pacote_atual); }
    | lista_instancias CONV_INSTANCIA { inserir_simbolo_sintatico($2, "INSTANCIA DO ENUM", pacote_atual); }
    | lista_instancias error { yyerrok; yyclearin; } 
    ;

/* 6. Conjuntos de Generalizações */
declaracao_genset:
    PALAVRA_RESERVADA PALAVRA_RESERVADA PALAVRA_RESERVADA CONV_CLASSE '{' conteudo_generico '}' {
        if ($1 == "disjoint" && $2 == "complete" && $3 == "genset") {
            inserir_simbolo_sintatico($4, "GENSET (Taxonomia)", pacote_atual);
        }
    }
    ;

/* 7. Declaração de Relações Externas */
declaracao_relacao:
    ESTEREOTIPO_RELACAO CONV_RELACAO CONV_CLASSE CONV_RELACAO CONV_CLASSE {
        if ($2 == "relation") {
            inserir_simbolo_sintatico($4, "RELACAO EXTERNA", pacote_atual);
        }
    }
    ;

/* Bloco Genérico: Consome qualquer coisa dentro de chaves { } sem dar erro fatal */
conteudo_generico:
    /* vazio */
    | conteudo_generico token_qualquer
    ;

token_qualquer:
    CONV_CLASSE | CONV_RELACAO | CONV_INSTANCIA 
    | PALAVRA_RESERVADA | ESTEREOTIPO_RELACAO | ESTEREOTIPO_CLASSE
    | TIPO_NATIVO | META_ATRIBUTO | TIPO_NOVO
    | error { yyerrok; yyclearin; } 
    ;

%%

void yyerror(const char* s) {
}

int main(int argc, char** argv) {
    carregar_tabela("../casos.txt");

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            cerr << "Erro ao abrir o arquivo: " << argv[1] << endl;
            return 1;
        }
    }

    yyparse();
    imprimir_relatorio_sintatico();
    return 0;
}