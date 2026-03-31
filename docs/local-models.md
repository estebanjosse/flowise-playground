# Local Models and Model Comparison

This document explains how local model execution works in this project with Ollama, how to connect Flowise to it, and how to interpret the first model comparison results.

## Overview

The Docker Compose stack includes an optional `ollama` service. When enabled, it:

- starts an Ollama server on port `11434`
- persists downloaded models in the `ollama-data` volume
- can automatically pull one or more models on startup
- makes the Ollama API reachable from Flowise through the Docker network

This setup is useful for testing small local models without depending on a cloud provider.

## How Local Model Startup Works

### Docker Compose Profile

The `ollama` service belongs to the `ollama` Docker Compose profile:

```bash
docker compose --profile ollama up -d
```

In this repository, `.env.example` enables `flowise`, `qdrant`, and `ollama` by default through `COMPOSE_PROFILES`. After copying `.env.example` to `.env`, a plain `docker compose up -d` will therefore start Ollama as part of the default stack unless you change `COMPOSE_PROFILES`.

If you want to run only a subset of the stack, you can either edit `COMPOSE_PROFILES` in `.env` or use explicit profile-based commands.

To run Flowise and Ollama together explicitly:

```bash
docker compose --profile flowise --profile ollama up -d
```

To run Flowise, Ollama, and Qdrant together explicitly:

```bash
docker compose --profile flowise --profile ollama --profile qdrant up -d
```

### Service Behavior

The `ollama` container uses the script [scripts/ollama-entrypoint.sh](../scripts/ollama-entrypoint.sh). On startup, it:

1. starts `ollama serve`
2. waits for the API to become available
3. reads `OLLAMA_AUTO_PULL_MODELS`
4. checks whether each configured model already exists locally
5. pulls missing models automatically

This means the first startup can take time depending on the selected models and network speed, while later restarts are usually much faster.

### Auto-Pulled Models

The model list is controlled by the `OLLAMA_AUTO_PULL_MODELS` environment variable.

Example:

```env
OLLAMA_AUTO_PULL_MODELS=qwen2.5:0.5b,qwen2.5:1.5b,llama3.2:1b
```

The entrypoint converts commas to spaces, then pulls each model one by one.

## Common Commands

### Start the default full stack

```bash
docker compose up -d
```

### Start Flowise with Ollama explicitly

```bash
docker compose --profile flowise --profile ollama up -d
```

### Check logs

```bash
docker compose logs -f ollama
```

### List installed models inside the container

```bash
docker compose exec ollama ollama list
```

### Pull an additional model manually

```bash
docker compose exec ollama ollama pull gemma3:1b
```

## Connecting Flowise to Ollama

When Flowise runs in the same Docker Compose network, use these settings in the Flowise Ollama node:

- **Base URL:** `http://ollama:11434`
- **Model:** the exact Ollama model tag, for example `qwen2.5:0.5b`

If you call Ollama from outside Docker, use:

- **Base URL:** `http://localhost:11434`

## Resource Notes

Small models are easier to run locally but usually show weaker tool use, reasoning, and formatting consistency.

Observed memory usage from the initial tests:

| Model | Approx. memory usage |
|-------|----------------------|
| `qwen2.5:0.5b` | `0.8 GB` |
| `qwen2.5:1.5b` | `1.3 GB` |
| `qwen3:0.6b` | `1.8 GB` |
| `qwen2.5-coder:0.5b` | `0.8 GB` |
| `llama3.2:1b` | `1.5 GB` |

These numbers should be treated as indicative, not absolute. Actual consumption depends on the host OS, concurrent containers, and whether models are already loaded.

## Model Comparison

### Test Scope

The first comparison focused on MCP tool calling behavior with these prompts:

- `Use the MCP tool to add two numbers`
- `And what is 5 + 7?`
- `Display the environment variables`
- `call getTinyImage function and display the result like this : ![Tiny Image](data:image/png;base64,XXX)`

The goal was not general benchmark quality, but practical behavior in a tool-calling setup.

### Results Summary

| Model | MCP tool calling | Notes | Approx. memory usage |
|-------|------------------|-------|----------------------|
| `qwen2.5:0.5b` | `3/4` | Best compromise so far. Calls mostly work, output quality is uneven, tiny image output was almost correct but truncated. Fast. | `0.8 GB` |
| `qwen2.5:1.5b` | `3/4` | Often fast, but sometimes invents numbers and timed out on the last test. | `1.3 GB` |
| `qwen3:0.6b` | `1/4` | Hesitates on simple tool tasks, responds slowly, and may call tools more than once. Tiny image not fully tested. | `1.8 GB` |
| `qwen2.5-coder:0.5b` | `0/4` | Produces the function-call JSON but does not actually execute the tool. | `0.8 GB` |
| `llama3.2:1b` | `0/4` | Shows function parameters but does not perform the call. | `1.5 GB` |
| `deepseek-r1:1.5b` | not supported | No tool support observed in this setup. | not measured |
| `gemma3:1b` | not supported | No tool support observed in this setup. | not measured |
| `gemma3:270m` | not evaluated | Entry kept for future testing. | not measured |

### Practical Reading of These Results

- For lightweight local MCP experiments, `qwen2.5:0.5b` currently looks like the most usable option.
- A bigger parameter count does not automatically improve tool reliability.
- Some models can describe a tool call correctly while still failing to execute it.
- Formatting robustness matters in practice, especially for structured outputs such as base64 payloads.

## Recommended Testing Workflow

When adding a new local model, use this process:

1. add the model to `OLLAMA_AUTO_PULL_MODELS`
2. start the `ollama` profile
3. verify the model is present with `ollama list`
4. configure an Ollama node in Flowise with `http://ollama:11434`
5. rerun the same MCP prompt set
6. record tool success rate, latency, formatting quality, and memory usage

Using a stable prompt set makes future comparisons more useful than informal one-off impressions.

## Limits of the Current Comparison

The current notes are exploratory. They do not yet provide:

- repeated runs for statistical stability
- standardized latency measurements
- exact hardware context
- evaluation of answer quality outside MCP tool use
- complete measurements for all listed models

For stronger conclusions, keep the prompt set fixed and add a simple scorecard per model.