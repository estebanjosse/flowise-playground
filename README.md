# Flowise Playground

Flowise Playground provides a ready-to-use Docker Compose environment for [FlowiseAI](https://flowiseai.com/), including optional dependencies and fully documented example flows. It’s designed for rapid prototyping, local experimentation, and sharing reproducible LLM pipelines.

## ✨ Features

- 🐳 **One-command setup** — Get FlowiseAI running in seconds
- 🔌 **Optional dependencies** — Includes Qdrant vector database for RAG workflows
- 📚 **Fully documented** — Clear guides and architecture documentation

## 🚀 Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) 
- [Docker Compose](https://docs.docker.com/compose/install/)

### 1. Clone and Configure

```bash
git clone https://github.com/estebanjosse/flowise-playground.git
cd flowise-playground
cp .env.example .env
```

### 2. Start Flowise

```bash
docker compose up -d
```

By default, the provided `.env.example` enables the `flowise`, `qdrant`, and `ollama` profiles through `COMPOSE_PROFILES`, so this command starts the full local stack.

### 3. Open the UI

Navigate to [http://localhost:3000](http://localhost:3000) in your browser.

**That's it!** You're ready to build LLM workflows. 🎉

## 🗄️ Adding Qdrant (Vector Database)

For RAG (Retrieval-Augmented Generation) workflows:

```bash
docker compose up -d
```

Qdrant will be available at `localhost:6333`. When configuring Qdrant in Flowise, use:
- **Host:** `qdrant`
- **Port:** `6333`

If you want to customize which services start by default, edit `COMPOSE_PROFILES` in your `.env` file.

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [Usage Guide](docs/usage.md) | Detailed instructions for using the environment |
| [Architecture](docs/architecture.md) | Overview of components and how they interact |
| [Sample Flows](docs/sample-flows.md) | Example workflows to get you started |
| [Local Models and Comparison](docs/local-models.md) | How Ollama-based local models are started and how test results compare |

## 📁 Project Structure

```
flowise-playground/
├── docker-compose.yml    # Main Docker Compose configuration
├── .env.example          # Environment variables template
├── docs/
│   ├── architecture.md   # System architecture overview
│   ├── local-models.md   # Local Ollama usage and model comparison notes
│   ├── usage.md          # Detailed usage instructions
│   └── sample-flows.md   # Example workflow descriptions
└── README.md             # This file
```

## 🛠️ Common Commands

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Start all services enabled by `COMPOSE_PROFILES` |
| Edit `COMPOSE_PROFILES` in `.env` | Change which services start by default |
| `docker compose --profile flowise --profile qdrant up -d` | Start with explicit profiles when needed |
| `docker compose --profile flowise --profile ollama up -d` | Start Flowise + Ollama explicitly |
| `docker compose down` | Stop all services |
| `docker compose logs -f` | View logs |
| `docker compose pull` | Update to latest images |

## 🤖 Local Models

See [Local Models and Comparison](docs/local-models.md) for:

- how the Ollama service starts in this project
- how to auto-pull local models
- how to connect Flowise to Ollama
- the current MCP tool-calling comparison notes

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [FlowiseAI Documentation](https://docs.flowiseai.com/)
- [FlowiseAI GitHub](https://github.com/FlowiseAI/Flowise)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
