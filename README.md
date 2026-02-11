# Shinobi Project 🗡️ 

![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-orange)
![GameMaker](https://img.shields.io/badge/Engine-GameMaker%20Studio%202-blueviolet)

Um jogo de ação em plataforma focado em combate fluido, ambientação atmosférica e evolução de habilidades através do treinamento. No papel de um shinobi, o jogador deve dominar técnicas ancestrais e enfrentar hordas de inimigos em um mundo dinâmico.



---

## 🚀 Funcionalidades Principais

### 🧠 Máquina de Estados Avançada (FSM)
O player e os inimigos utilizam uma lógica de estados robusta que permite transições fluidas entre corrida, pulo, ataques combinados (combos), dash e dano.
- **Sistema de Combate:** Combos de 3 ataques com multiplicadores de dano.
- **Dash Dinâmico:** Movimentação rápida com frames de invencibilidade.

### 🔊 Atmosfera e Áudio Dinâmico
- **Soundscape:** Sistema de sons ambientes (vento, pássaros, corvos) com algoritmos de aleatoriedade e *crossfade*.
- **Playlist Aleatória:** Sistema de música que gerencia trilhas sonoras sem repetições consecutivas e com transições suaves de volume.

### ⚙️ Sistema de Menu e Persistência
- **Menu via DS Grids:** Menu totalmente customizável, com suporte a sliders de volume, troca de resolução e remapeamento de teclas.
- **Persistência (.ini):** Configurações de áudio e vídeo são salvas automaticamente em arquivos locais.

### 🌄 Visual e Performance
- **Parallax via Código:** Camadas de fundo que se movem em profundidade, sincronizadas com a velocidade global (`global.vel_mult`).
- **Bullet Time:** Efeito de câmera lenta ativado em momentos críticos como o Game Over.

---

## 📈 Sistema de Progressão (Dojo System)

Diferente de sistemas de XP comuns, no **Shinobi Project** você evolui o que você usa:
1. **Treinamento:** Ataque bonecos de treino para ganhar XP em técnicas específicas.
2. **Geração de Dados:** Cada golpe tem uma probabilidade baseada em sorte para gerar evolução.
3. **Evolução de Skill:** Habilidades como o *Dash Attack* aumentam de nível, ganhando novos atributos e efeitos visuais.



---

## 🛠️ Tecnologias Utilizadas

- **Linguagem:** GML (GameMaker Language)
- **Estruturas de Dados:** `ds_grids` para menus e `arrays` para sistemas de som.
- **Arquivos:** `.ini` para persistência de dados.

---

## 📂 Como Rodar o Projeto

1. Certifique-se de ter o **GameMaker Studio 2** (versão 2023+) instalado.
2. Clone o repositório:
   ```bash
   git clone [https://github.com/seu-usuario/projeto-shinobi.git](https://github.com/seu-usuario/projeto-shinobi.git)
3. Abra o arquivo .yyp no GameMaker.
4. Pressione F5 para compilar e rodar.

Desenvolvido com GameMaker por Mauricios73
