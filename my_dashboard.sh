#!/bin/bash

# --- My Terminal Dashboard ---
# Seu painel diário personalizado no terminal.
# Versão: 1.0 - Completa!

# --- Cores para o terminal ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m' # Nova cor para erros/avisos
NC='\033[0m' # No Color

# --- 1. Saudação ---
echo -e "${GREEN}--- Olá, $(whoami)! Bem-vindo(a) ao seu Dashboard Diário ---${NC}"

# --- 2. Data e Hora Atuais ---
echo -e "${BLUE}\n[ ⏰ Data e Hora ]${NC}"
echo "$(date +'%A, %d de %B de %Y - %H:%M:%S')"

# --- 3. Previsão do Tempo (Wttr.in) ---
echo -e "${BLUE}\n[ ☁️ Previsão do Tempo ]${NC}"
# Você pode mudar "Rio+de+Janeiro" para sua cidade, ou "auto" para detectar automaticamente
# A URL "?0" mostra a previsão de hoje em uma linha
# A URL "wttr.in/SuaCidade?lang=pt" mostra em português e inclui amanhã. Experimente!
if command -v curl &> /dev/null
then
    curl -s wttr.in/Rio+de+Janeiro?0 --user-agent "curl"
elif command -v wget &> /dev/null
then
    wget -qO- wttr.in/Rio+de+Janeiro?0
else
    echo -e "${RED}Erro: 'curl' ou 'wget' não encontrado. Não foi possível buscar o clima.${NC}"
fi

# --- 4. Resumo de Notícias ---
echo -e "${BLUE}\n[ 📰 Manchetes do Dia ]${NC}"

NEWS_FEED_URL="https://news.google.com/rss?hl=pt-BR&gl=BR&ceid=BR:pt-419"

if command -v curl &> /dev/null && command -v grep &> /dev/null && command -v sed &> /dev/null && command -v awk &> /dev/null
then
    # Baixa o RSS e extrai os títulos dos itens (tags <title>)
    # Pega as primeiras 5 manchetes, removendo tags e ajustando o texto
    curl -s "$NEWS_FEED_URL" --user-agent "curl" | \
    grep -oP '<title>\K[^<]+' | \
    grep -v 'Google Notícias' | \
    head -n 5 | \
    sed 's/&apos;/'"'"'/g; s/&quot;/"/g; s/&amp;/&/g; s/&lt;/</g; s/&gt;/>/g' | \
    awk '{printf "- %s\n", $0}'
elif command -v wget &> /dev/null && command -v grep &> /dev/null && command -v sed &> /dev/null && command -v awk &> /dev/null
then
    wget -qO- "$NEWS_FEED_URL" | \
    grep -oP '<title>\K[^<]+' | \
    grep -v 'Google Notícias' | \
    head -n 5 | \
    sed 's/&apos;/'"'"'/g; s/&quot;/"/g; s/&amp;/&/g; s/&lt;/</g; s/&gt;/>/g' | \
    awk '{printf "- %s\n", $0}'
else
    echo -e "${RED}Erro: 'curl' ou 'wget' e/ou ferramentas de processamento de texto não encontrados. Não foi possível buscar as notícias.${NC}"
fi

# --- 5. Tarefas do Dia ---
echo -e "${BLUE}\n[ ✅ Suas Tarefas Hoje ]${NC}"

TAREFAS_FILE="TODO.txt"

if [[ -f "$TAREFAS_FILE" ]]; then # Verifica se o arquivo TODO.txt existe
    if [[ -s "$TAREFAS_FILE" ]]; then # Verifica se o arquivo NÃO está vazio
        cat "$TAREFAS_FILE" # Lê e imprime o conteúdo do arquivo de tarefas
    else
        echo "  Nenhuma tarefa pendente por enquanto! ✨"
    fi
else
    echo "  Crie o arquivo '$TAREFAS_FILE' na pasta do projeto para adicionar suas tarefas."
fi

# --- 6. Citação do Dia ---
echo -e "${BLUE}\n[ 💡 Citação do Dia ]${NC}"

QUOTE_API_URL="https://api.quotable.io/random"

# Verifica se curl e jq estão instalados
if command -v curl &> /dev/null && command -v jq &> /dev/null
then
    QUOTE_DATA=$(curl -s "$QUOTE_API_URL" --user-agent "curl")
    QUOTE_CONTENT=$(echo "$QUOTE_DATA" | jq -r '.content')
    QUOTE_AUTHOR=$(echo "$QUOTE_DATA" | jq -r '.author')

    if [[ -n "$QUOTE_CONTENT" ]]; then # Verifica se a citação não está vazia
        echo "  \"${QUOTE_CONTENT}\""
        echo "  - ${QUOTE_AUTHOR}"
    else
        echo -e "${RED}  Não foi possível carregar a citação do dia.${NC}"
    fi
else
    echo -e "${RED}Erro: 'curl' e/ou 'jq' não encontrado(s). Não foi possível buscar a citação.${NC}"
fi

# --- Linha de separação ---
echo -e "${GREEN}-------------------------------------------${NC}"

echo ""
echo "Dashboard carregado com sucesso!"