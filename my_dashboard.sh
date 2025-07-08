#!/bin/bash

# --- My Terminal Dashboard ---
# Seu painel diário personalizado no terminal.
# Versão: 0.2 (com previsão do tempo!)

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

# IMPORTANTE: Para isso funcionar, seu sistema precisa ter o comando 'curl' ou 'wget'.
# No WSL/Git Bash ele já vem. No PowerShell nativo, talvez precise instalar.
if command -v curl &> /dev/null
then
    curl -s wttr.in/Rio+de+Janeiro?0 --user-agent "curl" # -s = silent (não mostra progresso), --user-agent para alguns servidores.
elif command -v wget &> /dev/null
then
    wget -qO- wttr.in/Rio+de+Janeiro?0 # -qO- = silent (não mostra progresso), O- para stdout
else
    echo -e "${RED}Erro: 'curl' ou 'wget' não encontrado. Não foi possível buscar o clima.${NC}"
fi

# --- Linha de separação ---
echo -e "${GREEN}-------------------------------------------${NC}"

# No futuro, adicionaremos mais funcionalidades aqui!

echo ""
echo "Dashboard carregado com sucesso!"