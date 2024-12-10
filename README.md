# Requisitos do Projeto

## Requisitos Funcionais

### Cadastro de Redes Wi-Fi
- Permitir que usuários cadastrem redes Wi-Fi informando:
  - Nome da rede (SSID)
  - Senha da rede
  - Tipo da rede (pública, privada com autorização para compartilhamento)
- Garantir que o proprietário da rede autorize o compartilhamento.

### Conexão Automática
- Identificar redes Wi-Fi disponíveis no local onde o usuário está.
- Verificar se alguma dessas redes está cadastrada no banco de dados.
- Conectar automaticamente à rede correspondente, se o usuário permitir.

### Gerenciamento de Redes Cadastradas
- Exibir uma lista de redes cadastradas pelo usuário.
- Permitir que o usuário remova ou edite redes que ele cadastrou.

### Criptografia e Segurança
- Criptografar todas as senhas armazenadas no banco de dados local e remoto.
- Garantir que as senhas não sejam exibidas diretamente para os usuários (mostrar apenas o status de conexão).

### Compartilhamento com Controle
- Oferecer a opção para o proprietário da rede definir restrições, como horários em que o Wi-Fi pode ser utilizado.

## Requisitos Não Funcionais

### Segurança
- Usar criptografia forte para armazenar e transmitir senhas (ex.: AES-256).
- Implementar autenticação do usuário para acesso ao aplicativo (ex.: login por e-mail ou rede social).

### Compatibilidade
- Disponibilizar o aplicativo para Android e iOS.
- Considerar limitações específicas de cada plataforma para acesso ao Wi-Fi.

### Desempenho
- Garantir que a identificação e conexão com redes Wi-Fi seja rápida e eficiente.
- Minimizar o uso de bateria e dados do dispositivo.

### Escalabilidade
- Projetar a infraestrutura para suportar um grande número de redes cadastradas e usuários simultâneos.
