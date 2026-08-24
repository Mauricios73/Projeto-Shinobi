# Projeto Shinobi 🗡️

<p align="center">
  <img src="https://img.shields.io/github/repo-size/Mauricios73/Projeto-Shinobi?style=for-the-badge" alt="Repo Size" />
  <img src="https://img.shields.io/github/last-commit/Mauricios73/Projeto-Shinobi?style=for-the-badge" alt="Last Commit" />
  <img src="https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow?style=for-the-badge" alt="Status" />
  <img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" alt="License" />
</p>

<p align="center">
**Projeto Shinobi** é um jogo de ação e plataforma desenvolvido em **GameMaker Studio 2**, criado como um projeto de estudo e desenvolvimento de sistemas de gameplay, combate, habilidades e arquitetura de objetos.



</p>

## 🎮 Sobre o projeto

A proposta do Shinobi é explorar a construção de um jogo de ação 2D com foco em:

- combate em tempo real;
- habilidades especiais;
- sistema de dano e invencibilidade;
- inimigos e entidades reutilizáveis;
- colisões e hitboxes;
- progressão baseada em experiência;
- câmera e ambiente dinâmicos;
- configurações persistentes;
- efeitos visuais e sonoros.

O projeto utiliza a estrutura nativa de recursos do GameMaker, mantendo objetos, scripts, salas, sprites, sons, shaders, fontes e tilesets organizados separadamente. fileciteturn41file0L2-L2

## ⚔️ Sistemas principais

### Combate

O sistema de combate está organizado em componentes especializados para separar entidades, dano, habilidades e detecção de colisões.

Entre os principais componentes estão:

- `obj_entidade` — base para entidades do jogo;
- `obj_entidade_player` — entidade controlada pelo jogador;
- `obj_entidade_inimigo` — base para inimigos;
- `obj_dano` — processamento centralizado de dano;
- `obj_dano_num` — representação/controle de valores de dano;
- `obj_hitbox` — detecção e suporte às áreas de ataque;
- `obj_skill_controller` — gerenciamento de habilidades.

O repositório também possui objetos dedicados a aliados, câmera, ambiente, blocos e controle global do jogo. fileciteturn43file0L2-L2

### Habilidades

O projeto possui uma camada específica para gerenciamento de skills, permitindo concentrar a lógica das habilidades e reduzir a dependência direta entre o jogador e cada ataque.

Exemplos presentes na implementação incluem habilidades como **Fire Breath** e **Chidori**.

### Dano e progressão

O sistema de dano foi projetado para centralizar regras como:

- aplicação de dano;
- controle de invencibilidade;
- processamento por ticks;
- experiência/XP.

Essa separação facilita a evolução futura do sistema de combate sem concentrar toda a lógica no objeto do jogador.

## 🌧️ Ambiente

Além dos sistemas de gameplay, o projeto possui componentes para criar uma ambientação dinâmica, incluindo elementos como:

- chuva;
- neblina;
- ambiente;
- efeitos atmosféricos;
- sons ambientais.

A estrutura do projeto também inclui recursos dedicados para `sounds`, `sprites`, `tilesets`, `shaders` e `fonts`. fileciteturn41file0L2-L2

## ⚙️ Configurações

O jogo possui um sistema de configurações para:

- áudio;
- vídeo;
- controles.

As alterações são persistidas localmente por meio de `settings.ini`, permitindo que as preferências sejam mantidas entre execuções. fileciteturn44file0L2-L2

## 🧩 Estrutura do projeto

```text
Projeto-Shinobi/
│
├── objects/        # Objetos e entidades do jogo
├── scripts/        # Scripts reutilizáveis e sistemas
├── rooms/          # Fases e ambientes
├── sprites/        # Sprites e animações
├── sounds/         # Música e efeitos sonoros
├── shaders/        # Efeitos gráficos
├── tilesets/       # Tiles utilizados nas fases
├── fonts/          # Fontes do jogo
├── options/        # Configurações do GameMaker
├── datafiles/      # Dados auxiliares
├── notes/          # Anotações do projeto
│
├── Ultimo Uchiha.yyp
└── Ultimo Uchiha.resource_order
```

A estrutura acima acompanha a organização atual do projeto GameMaker. fileciteturn41file0L2-L2

## 🛠️ Como executar

### Requisitos

- **GameMaker Studio 2**
- Windows ou plataforma compatível com a versão do GameMaker utilizada no projeto

### Abrindo o projeto

1. Clone o repositório:

```bash
git clone https://github.com/Mauricios73/Projeto-Shinobi.git
```

2. Abra o arquivo:

```text
Ultimo Uchiha.yyp
```

3. No GameMaker Studio 2, execute o projeto com **Run**.

## 🧠 Objetivo de desenvolvimento

O Shinobi não é apenas um jogo experimental: ele também funciona como um laboratório para estudar arquitetura de gameplay em **GML**, incluindo separação de responsabilidades, sistemas reutilizáveis, controle de entidades, combate e evolução incremental de mecânicas.

A prioridade do desenvolvimento é manter os sistemas suficientemente desacoplados para que novas mecânicas possam ser adicionadas sem transformar os objetos principais em grandes blocos de código monolítico.

## 🚧 Status

**Em desenvolvimento ativo.**

O projeto continua sendo utilizado para experimentar e aprimorar:

- arquitetura de gameplay;
- combate;
- IA de inimigos;
- habilidades;
- hitboxes;
- progressão;
- efeitos visuais;
- ambiente;
- organização e refatoração de código GML.

## 📌 Roadmap

- [ ] Evoluir IA dos inimigos
- [ ] Refinar sistema de combate
- [ ] Melhorar balanceamento das habilidades
- [ ] Expandir sistema de progressão
- [ ] Refinar hitboxes e colisões
- [ ] Melhorar organização dos sistemas de gameplay
- [ ] Expandir fases e conteúdo
- [ ] Otimizar performance
- [ ] Documentar sistemas internos

## 📄 Licença

Nenhuma licença open-source foi definida atualmente para este repositório. Até que uma licença seja adicionada, os direitos sobre o código e os demais recursos permanecem reservados ao autor.

---

**Mauricio Portela — Projeto Shinobi**
