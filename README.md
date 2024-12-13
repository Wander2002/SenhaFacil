# Requisitos do Projeto

## Requisitos Funcionais
1. **Listagem de redes Wi-Fi disponíveis**  
   - O sistema deve listar as redes Wi-Fi detectadas pelo dispositivo.  

2. **Conexão às redes Wi-Fi**  
   - O sistema deve permitir que o usuário conecte-se a uma rede Wi-Fi com ou sem senha, usando as informações armazenadas no Firestore.  

3. **Cadastro de redes Wi-Fi**  
   - O sistema deve permitir que o usuário cadastre uma rede Wi-Fi no Firestore, informando o nome da rede e sua senha.  

4. **Validação de redes Wi-Fi cadastradas**  
   - O sistema deve verificar se a rede Wi-Fi selecionada já está cadastrada no Firestore antes de permitir o cadastro.  

5. **Autenticação de usuários**  
   - O sistema deve permitir que o usuário deslogue da aplicação por meio de uma opção no menu lateral.  

6. **Conexão segura a redes Wi-Fi**  
   - O sistema deve validar se a conexão foi bem-sucedida e informar o status ao usuário.  

## Requisitos Não Funcionais
1. **Usabilidade**  
   - A interface deve ser intuitiva e facilitar a navegação do usuário, incluindo mensagens claras de feedback.  

2. **Desempenho**  
   - O sistema deve listar as redes Wi-Fi disponíveis em até 5 segundos após a inicialização.  

3. **Compatibilidade**  
   - O sistema deve ser compatível com dispositivos Android e iOS.  

4. **Confiabilidade**  
   - O sistema deve garantir a persistência dos dados de redes Wi-Fi cadastradas no Firestore, mesmo em casos de falha de conexão.  

5. **Segurança**  
   - As senhas das redes Wi-Fi devem ser armazenadas de forma segura no Firestore, utilizando técnicas de criptografia.  

6. **Escalabilidade**  
   - O sistema deve ser capaz de gerenciar um número elevado de redes Wi-Fi cadastradas sem comprometer o desempenho.  

7. **Portabilidade**  
   - O código deve ser desenvolvido em Flutter, garantindo que a aplicação possa ser executada em múltiplas plataformas.  

8. **Resiliência**  
   - O sistema deve lidar com falhas de conexão Wi-Fi ou Firestore, apresentando mensagens de erro claras e garantindo que o usuário consiga continuar utilizando a aplicação.

