cmake_minimum_required(VERSION 3.5.0)
project(tonto_compiler)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)

find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# 1. O Bison compila a gramática e gera o .cpp e o .h (parser.tab.h)
BISON_TARGET(Parser src/parser.y ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.cpp)

# 2. O Flex compila as expressões regulares
FLEX_TARGET(Lexer tonto.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cpp)

# Garante que o Bison rode antes do Flex (já que o Flex precisa do parser.tab.h)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

# Inclui a pasta include e a pasta de build (onde o parser.tab.h vai nascer)
include_directories(${CMAKE_CURRENT_BINARY_DIR} include)

# Compila todos os ficheiros num único executável
add_executable(tonto 
    ${BISON_Parser_OUTPUTS} 
    ${FLEX_Lexer_OUTPUTS} 
    src/tabela.cpp
)