# Playbook Ansible - Extração de Certificados PFX

Este playbook automatiza a extração de certificados e chaves privadas a partir de arquivos **PFX (.pfx)** utilizando o `openssl`.  
Ele foi baseado em um script Bash original e atualizado para seguir boas práticas de automação com Ansible.

---

## Funcionalidades
- Verifica se o **openssl** está instalado.
- Valida se o arquivo PFX existe antes de iniciar a extração.
- Extrai:
  - **Chave privada** (sem senha).
  - **Certificado** principal.
  - **Cadeia de certificados (CA)**.
- Garante **idempotência**: não sobrescreve arquivos já existentes.
- Permite configurar caminhos de saída via variáveis.

---

## Variáveis
As variáveis podem ser definidas diretamente no playbook ou em um arquivo de inventário:

```yaml
vars:
  input_cert_pfx: "/caminho/para/arquivo.pfx"
  pfx_password: "SENHA_AQUI"
  cert_out: "/caminho/certificado.crt"
  key_out: "/caminho/chave.key"
  chain_out: "/caminho/ca-chain.pem"
