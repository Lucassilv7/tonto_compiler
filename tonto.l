%{

#include <iostream>
#include <string>
#include <unordered_map>
#include "tokens.h"
#include "tabela.h"

using namespace std;

// Variáveis para rastrear a posição exata de cada token no código-fonte
int linha = 1;
int coluna = 1;

// Contadores para a Tabela de Síntese
int cont_classes = 0;
int cont_relacoes = 0;
int cont_keywords = 0;
int cont_individuos = 0;
int cont_reservados = 0;
int cont_meta = 0;

#define YY_USER_ACTION coluna += yyleng;

const char* nome_categoria(int t);
void processar_palavra(const string& s, int col_inicio);

%}

%option noyywrap

/* Definições Regulares  */

delim [ \t]
brancos {delim}+
letra_mai [A-Z]
letra_min [a-z]
letras {letra_mai}|{letra_min}
digito [0-9]

palavra {letras}({letras}|_)*{digito}*
simbolo "{"|"}"|"("|")"|"["|"]"|".."|"<>--"|"--<>"|"*"|"@"|":"

%%

{brancos} { /* ignora espaços/tabs, não conta como token */ }
\n { linha++; coluna = 1; }
"//"[^\n]* { /* ignora comentários de linha */ }

{palavra} {processar_palavra(yytext, coluna);}

{simbolo} {
    cout << "<SIMBOLO, " << yytext << "> linha " << linha
     << ", coluna " << (coluna - yyleng) << endl;
     }

. {
    cerr << "Erro lexico na linha " << linha << ", coluna " << (coluna - yyleng)
         << ": caractere nao reconhecido '" << yytext << "'" << endl;
}

%%

// 1) Tenta a tabela de palavras fixas (carregada de casos.txt).
// 2) Se não achar (buscar retorna CONSULTA), classifica por convenção de escrita.
int classificar(const string& s){
    int t = buscar(s);
    if (t != CONSULTA) return t;

    const string sufixo = "DataType";
    if (s.size() > sufixo.size() && 
        s.compare(s.size() - sufixo.size(), sufixo.size(), sufixo) == 0) {
        bool valido = true;
        for (char c : s) 
            if (isdigit((unsigned char)c) || c == '_') valido = false;
        if (valido) return TIPO_NOVO;
    }

    if (isdigit((unsigned char)s.back())) return CONV_INSTANCIA;
    if (isupper((unsigned char)s.front())) return CONV_CLASSE;
    if (islower((unsigned char)s.front())) return CONV_RELACAO;

    return ERRO_LEXICO;
}

const char* nome_categoria(int t) {
    switch (t){
        case ESTEREOTIPO_CLASSE: return "ESTEREOTIPO_CLASSE";
        case ESTEREOTIPO_RELACAO: return "ESTEREOTIPO_RELACAO";
        case PALAVRA_RESERVADA: return "PALAVRA_RESERVADA";
        case TIPO_NATIVO:         return "TIPO_NATIVO";
        case META_ATRIBUTO:       return "META_ATRIBUTO";
        case TIPO_NOVO:           return "TIPO_NOVO";
        case CONV_CLASSE:         return "CONV_CLASSE";
        case CONV_RELACAO:        return "CONV_RELACAO";
        case CONV_INSTANCIA:      return "CONV_INSTANCIA";
        default:                  return "ERRO_LEXICO";
    }
}

void processar_palavra(const string& s, int col_inicio){
    int t = classificar(s);
    switch (t){
        case ESTEREOTIPO_CLASSE:
        case ESTEREOTIPO_RELACAO: cont_keywords++;   break;
        case PALAVRA_RESERVADA:   cont_reservados++; break;
        case META_ATRIBUTO:       cont_meta++;       break;
        case CONV_CLASSE:
        case TIPO_NOVO:           cont_classes++;    break;
        case CONV_RELACAO:        cont_relacoes++;   break;
        case CONV_INSTANCIA:      cont_individuos++; break;
        case ERRO_LEXICO:
            cerr << "Erro lexico na linha " << linha << ", coluna " << col_inicio
                 << ": token invalido \"" << s << "\". Verifique a convencao de nomes." << endl;
            return;
    }
    cout << "<" << nome_categoria(t) << ", " << s << "> "
         << "linha " << linha << ", coluna " << col_inicio << endl;
}

int main(int argc, char** argv){
    
    carregar_tabela("../casos.txt");

    if (argc > 1) {
        extern FILE *yyin; 
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            cerr << "Erro ao abrir o arquivo de teste: " << argv[1] << endl;
            return 1;
        }
    } else {
        cout << "Uso: ./tonto <caminho_do_arquivo.tonto>" << endl;
        return 1;
    }

    yylex(); // Inicia o processo de análise léxica

    cout << "\n--- Tabela de Síntese ---" << endl;
    cout << "Classes:               " << cont_classes    << "\n";
    cout << "Relações:              " << cont_relacoes   << "\n";
    cout << "Palavras-chave:        " << cont_keywords   << "\n";
    cout << "Indivíduos:            " << cont_individuos << "\n";
    cout << "Palavras reservadas:   " << cont_reservados << "\n";
    cout << "Meta-atributos:        " << cont_meta       << "\n";

    return 0;
}