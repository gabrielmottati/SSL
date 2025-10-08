#!/bin/bash
# Script de extração de certificados e chaves do PFX
# Criado por gabito

# Inputação de Dados
read -p "Entre com o nome do arquivo PFX: " INPUT_CERT_PFX
echo ""
read -s -p "Entre com o password: " PFXPASS
echo ""

echo ""
echo "Certificado a ser extraído: $INPUT_CERT_PFX"
echo ""

# Verificando se arquivo EXISTE
if [ ! -f "$INPUT_CERT_PFX" ]; then
    echo "O arquivo '$INPUT_CERT_PFX' NÃO existe." >&2
    exit 1
else
    echo "O arquivo '$INPUT_CERT_PFX' existe."
fi

# Extraindo chave privada
echo "Extraindo a chave privada..."
openssl pkcs12 -in "$INPUT_CERT_PFX" -nocerts -out "${INPUT_CERT_PFX%.pfx}.key" -password pass:"$PFXPASS" -nodes
echo "Chave privada extraída com sucesso."

# Extraindo certificado
echo ""
echo "Extraindo o certificado..."
openssl pkcs12 -in "$INPUT_CERT_PFX" -nokeys -out "${INPUT_CERT_PFX%.pfx}.pem" -password pass:"$PFXPASS"
echo "Certificado extraído com sucesso."

# Removendo senha da chave
echo ""
echo "Removendo a senha da chave..."
openssl rsa -in "${INPUT_CERT_PFX%.pfx}.key" -out "${INPUT_CERT_PFX%.pfx}.key.nopass"
mv "${INPUT_CERT_PFX%.pfx}.key.nopass" "${INPUT_CERT_PFX%.pfx}.key"
echo "Senha removida da chave."

echo ""
echo "FIM"
exit 0
