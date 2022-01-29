#!/bin/bash
# Script de extração de certificados e chaves do PFX"
# Criado por gabito

# Inputação de Dados
echo -n "Entre com o nome do arquivo PFX "
read -s INPUT_CERT_PFX

echo ""

echo -n "Entre com o password : "
read -s PFXPASS

echo ""
echo ""
echo -n "Certificado a ser extraido: $INPUT_CERT_PFX"
echo ""
echo ""

# Verificando se arquivo EXISTE
if [ -e "$INPUT_CERT_PFX" ]; then
    	echo " O arquivo $INPUT_CERT_PFX existe" > /dev/null
    else
	echo " O arquivo NÃO existe" >&2
fi

# Extraindo Certificado
echo "Efetuando a extração da chave privada"
openssl pkcs12 -in $INPUT_CERT_PFX -nocerts -out $INPUT_CERT_PFX.key -password pass:$PFXPASS -nodes 

echo "Extração da chave privada efetuada com sucesso"

echo ""
echo ""
echo "Extraindo o certificado do arquivo .pfx"
openssl pkcs12 -in  $INPUT_CERT_PFX -nokeys -out $INPUT_CERT_PFX.pem -password pass:$PFXPASS

for f in *pfx.pem; do
mv -- "$f" "${f%.pfx.pem}.pem"
done

echo "Certificado extraido com sucesso"
echo ""
echo ""

echo "Removendo a senha da chave gerada"
openssl rsa -in  $INPUT_CERT_PFX.key -out  $INPUT_CERT_PFX.key.nopass.key
echo "Senha Removida do Certificado"
echo ""
echo ""

echo "Renomeando arquivos"
mv  $INPUT_CERT_PFX.key.nopass.key  $INPUT_CERT_PFX.key  >&2
for f in *pfx.key; do 
mv -- "$f" "${f%.pfx.key}.key"
done


echo "FIM"
echo ""
exit 0;
