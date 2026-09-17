cmake_minimum_required(VERSION 3.5.0)
project(tonto_compiler)

# Configuração do C++
set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)

# Configuração do Flex
find_package(FLEX)
FLEX_TARGET(Lexer tonto.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.cpp)

# Avisa ao compilador para procurar os .h na pasta include/
include_directories(${CMAKE_CURRENT_BINARY_DIR} include)

# Executável depende da saída do Flex e da tabela
add_executable(tonto ${FLEX_Lexer_OUTPUTS} src/tabela.cpp)