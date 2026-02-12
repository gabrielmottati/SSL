#!/bin/bash
# Script atualizado para extração de certificados e chaves de arquivos PFX
# Autor original: gabito | Revisão: 2026

set -euo pipefail

# Função de ajuda
usage() {
    echo "Uso: $0 -f arquivo.pfx -p senha [-c cert.pem] [-k chave.key] [-a cadeia.pem]"
    exit 1
}

# Verifica dependência
command -v openssl >/dev/null 2>&1 || { echo "Erro: openssl não está instalado."; exit 1; }

# Parâmetros
INPUT_CERT_PFX=""
PFXPASS=""
CERT_OUT=""
KEY_OUT=""
CHAIN_OUT=""

while getopts "f:p:c:k:a:" opt; do
  case $opt in
    f) INPUT_CERT_PFX="$OPTARG" ;;
    p) PFXPASS="$OPTARG" ;;
    c) CERT_OUT="$OPTARG" ;;
    k) KEY_OUT="$OPTARG" ;;
    a) CHAIN_OUT="$OPTARG" ;;
    *) usage ;;
  esac
done

# Valida entrada
[ -z "$INPUT_CERT_PFX" ] && usage
[ -z "$PFXPASS" ] && usage

[ ! -f "$INPUT_CERT_PFX" ] && { echo "Erro: arquivo '$INPUT_CERT_PFX' não encontrado."; exit 1; }

# Define nomes padrão se não informados
CERT_OUT=${CERT_OUT:-"${INPUT_CERT_PFX%.pfx}.crt"}
KEY_OUT=${KEY_OUT:-"${INPUT_CERT_PFX%.pfx}.key"}
CHAIN_OUT=${CHAIN_OUT:-"${INPUT_CERT_PFX%.pfx}-ca.pem"}

echo "Extraindo de: $INPUT_CERT_PFX"
echo "Certificado: $CERT_OUT"
echo "Chave: $KEY_OUT"
echo "Cadeia: $CHAIN_OUT"

# Extraindo chave privada
openssl pkcs12 -in "$INPUT_CERT_PFX" -nocerts -out "$KEY_OUT" -password pass:"$PFXPASS" -nodes
openssl rsa -in "$KEY_OUT" -out "$KEY_OUT"  # remove senha

# Extraindo certificado
openssl pkcs12 -in "$INPUT_CERT_PFX" -nokeys -clcerts -out "$CERT_OUT" -password pass:"$PFXPASS"

# Extraindo cadeia de certificados (CA)
openssl pkcs12 -in "$INPUT_CERT_PFX" -nokeys -cacerts -out "$CHAIN_OUT" -password pass:"$PFXPASS"

echo "Extração concluída com sucesso!"
