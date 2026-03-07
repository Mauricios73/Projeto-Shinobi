# Projeto Shinobi 🗡️

Jogo de ação/plataforma feito no **GameMaker Studio 2**.

## Rodando o projeto
1. Abra `Ultimo Uchiha.yyp` no GameMaker Studio 2
2. Clique em **Run**
3. Ajustes são salvos em `settings.ini` na pasta local do jogo (quando você mudar algo no menu)

## Controles e Configurações
- O menu permite mudar **áudio**, **vídeo** e **controles**
- As configurações persistem via `settings.ini`

## Estrutura (alto nível)
- `obj_game_controller`: inicialização + settings + política de áudio (menu/gameplay)
- `obj_ambiente`: sons ambientes (birds/crows/wind)
- `obj_skill_controller`: skills (fire breath, chidori)
- `obj_dano`: engine única de dano (ticks, invencível, XP)
- `obj_hitbox`: detector/âncora de skill (retângulo/círculo)

## Git
Este repositório ignora builds e caches do GameMaker via `.gitignore`.
