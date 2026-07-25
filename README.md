# terraria-server

tModLoader-сервер в Docker + деплой модов через GitHub Actions и Git LFS.

## Как закинуть мод

1. Кладёшь `.tmod` в папку `Postavka/`
2. `git add Postavka/МодНейм.tmod && git commit && git push`
3. Пайплайн **Deploy mods**:
   - сверяет LFS-хеш с `Mods/` — если такая версия уже стоит, файл просто убирается из `Postavka/` (не свежак)
   - если мод новый/обновлённый — переносит его в `Mods/` и дописывает в `enabled.json`
   - джоба **deploy** ждёт manual approval (environment `production`), после подтверждения по SSH делает `git pull` + `docker compose down && up -d`

## Изменения инфры

Правки `Dockerfile`, `docker-compose.yml`, `entrypoint.sh` идут через пайплайн
**Deploy infra** — тоже с manual approval. Он дополнительно пересобирает образ
(`docker compose build --pull`). Можно запустить руками через *Run workflow*.

## Настройка (один раз)

### Secrets (Settings → Secrets and variables → Actions)

| Secret | Что это |
|---|---|
| `SSH_HOST` | IP/хост сервера |
| `SSH_USER` | пользователь SSH |
| `SSH_KEY` | приватный ключ (OpenSSH) |
| `SSH_PORT` | порт SSH (опционально, по умолчанию 22) |
| `DEPLOY_PATH` | путь к клону репо на сервере, напр. `/opt/terraria-server` |

### Environment `production` (Settings → Environments)

Создать environment `production` и включить **Required reviewers** (добавить себя) —
это и есть мануальный шаг подтверждения деплоя.

### На сервере

```bash
apt-get install -y git-lfs   # нужен для git lfs pull
git clone https://github.com/f3rym/terraria-server.git /opt/terraria-server
cd /opt/terraria-server && git lfs pull
docker compose up -d
```

## Про LFS

`.tmod` хранятся в Git LFS (`.gitattributes`: `Mods/*.tmod` и `Postavka/*.tmod`).
Локально git-lfs ставить **не обязательно**: если мод залит сырым бинарником,
пайплайн сам прогонит его через LFS при переносе в `Mods/` (`git add --renormalize`).

⚠️ Ограничение: GitHub отклоняет push с файлом >100 МБ, если он не в LFS.
Такие крупные моды залить без локального git-lfs не выйдет — для них всё же
понадобится `git lfs install` на своей машине.
