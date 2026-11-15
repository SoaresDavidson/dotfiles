alias dco='docker compose up -d --build'
dx() { docker compose exec "$1" "${2:-bash}"; }
