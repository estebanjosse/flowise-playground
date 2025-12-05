#!/bin/sh
set -e

/bin/ollama serve &
server_pid=$!

cleanup() {
  kill "$server_pid" >/dev/null 2>&1 || true
}
trap cleanup INT TERM

until /bin/ollama list >/dev/null 2>&1; do
  sleep 1
done

for model in ${OLLAMA_AUTO_PULL_MODELS}; do
  if ! /bin/ollama show "$model" >/dev/null 2>&1; then
    /bin/ollama pull "$model"
  fi
done

/bin/ollama list

wait "$server_pid"
