# Two

Aplicativo Flutter para casais, focado em fortalecer o relacionamento, criar memórias, planejar eventos, propor desafios e promover conexão real.

## Sumário

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Tecnologias e Dependências](#tecnologias-e-dependências)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Configuração do Ambiente](#configuração-do-ambiente)
- [Comandos Principais](#comandos-principais)
- [Variáveis de Ambiente](#variáveis-de-ambiente)
- [Build e Publicação](#build-e-publicação)
- [Observações](#observações)

---

## Visão Geral

O app Two é um aplicativo Android desenvolvido em Flutter, que permite a casais:

- Registrar memórias (fotos, descrições)
- Planejar eventos e compromissos juntos
- Realizar desafios e atividades para fortalecer a relação
- Acompanhar o progresso do casal (ranking, presença, uso)
- Gerenciar perfis, conexões e preferências

O app se conecta a um backend Node.js/Express (ver pasta `../Backend-Two`).

## Funcionalidades

- **Autenticação**: E-mail/senha, Google Sign-In, verificação de e-mail
- **Memórias**: Upload de fotos, descrição, histórico visual
- **Planner**: Calendário compartilhado, categorias personalizadas
- **Desafios e Atividades**: Perguntas, desafios em casa/fora, gamificação
- **Presença**: Modo de presença real, registro de tempo juntos
- **Ranking**: Pontuação e gamificação entre casais
- **Notificações**: Preferências e lembretes (em desenvolvimento)
- **Perfil**: Edição de dados, foto, segurança, exclusão de conta
- **Ajuda e Onboarding**: Telas de tutorial e suporte

## Tecnologias e Dependências

Principais pacotes utilizados:

- **Flutter**: Framework principal
- **Provider**: Gerenciamento de estado
- **http**: Requisições REST
- **flutter_svg**: SVGs no app
- **cached_network_image**: Imagens de rede com cache
- **image_picker**: Seleção de imagens da galeria/câmera
- **photo_view**: Visualização de fotos com zoom
- **permission_handler**: Permissões de sistema
- **firebase_core, firebase_auth**: Integração com Firebase (Google Sign-In)
- **flutter_dotenv**: Variáveis de ambiente
- **intl**: Datas e internacionalização
- **table_calendar**: Calendário customizado
- **confetti**: Efeitos de celebração
- **flutter_secure_storage**: Armazenamento seguro de dados sensíveis
- **flutter_background_service**: Serviços em segundo plano (presença)
- **flip_card**: Cartas animadas para desafios/atividades

Veja todas as dependências em `pubspec.yaml`.

## Estrutura de Pastas

```
Two/
│
├── lib/
│   ├── core/           # Temas, utilitários, constantes
│   ├── presentation/   # Telas, widgets, UI
│   ├── providers/      # Providers (estado)
│   ├── services/       # Serviços (API, autenticação, etc)
│   ├── assets/         # Imagens, SVGs, JSONs de atividades
│   └── main.dart       # Entry point
│
├── android/            # Projeto Android nativo
├── pubspec.yaml
└── README.md
```

## Configuração do Ambiente

1. **Clone o repositório**
2. Instale o Flutter SDK (https://docs.flutter.dev/get-started/install)
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Configure o arquivo `.env` na raiz do projeto (veja abaixo)
5. Configure o Firebase para Google Sign-In (Android/iOS/Web)

## Comandos Principais

- `flutter pub get` — Instala as dependências
- `flutter run` — Executa o app no dispositivo/emulador
- `flutter build apk` — Gera APK para Android
- `flutter build ios` — Gera build para iOS
- `flutter build web` — Gera build para Web

## Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto com, por exemplo:

```
API_URL=https://seu-backend.com/api
GOOGLE_CLIENT_ID=xxxx.apps.googleusercontent.com
```

> **Atenção:** Nunca suba seu `.env` para repositórios públicos.

## Build e Publicação

- **Android**: Configure o arquivo `android/app/google-services.json` para Firebase/Google Sign-In.

## Observações

- O app depende do backend rodando e acessível via internet/local.
- Para Google Sign-In, configure o Firebase e os client IDs corretamente.
- Permissões de galeria/câmera são necessárias para upload de memórias.
- O app utiliza Provider para gerenciamento de estado.
- O design é responsivo e adaptado para diferentes tamanhos de tela.

---

**Equipe Two**  
