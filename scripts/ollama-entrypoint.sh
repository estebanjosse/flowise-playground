#!/bin/sh
set -e

/bin/ollama serve &
server_pid=$!

cleanup() {
  kill "$server_pid" >/dev/null 2>&1 || true
}
trap cleanup INT TERM

# Wait until the daemon can answer CLI requests before pulling models.
until /bin/ollama list >/dev/null 2>&1; do
  sleep 1
done

models=${OLLAMA_AUTO_PULL_MODELS:-gemma3:1b}
models=$(printf '%s' "$models" | tr ',' ' ')

for model in $models; do
  echo "[ollama-entrypoint] checking model '$model'"
  if /bin/ollama show "$model" >/dev/null 2>&1; then
    echo "[ollama-entrypoint] model '$model' already present"
  else
    echo "[ollama-entrypoint] pulling model '$model'"
    /bin/ollama pull "$model"
  fi
done

/bin/ollama list

wait "$server_pid"
