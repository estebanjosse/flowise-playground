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

### 3. Open the UI

Navigate to [http://localhost:3000](http://localhost:3000) in your browser.

**That's it!** You're ready to build LLM workflows. 🎉

## 🗄️ Adding Qdrant (Vector Database)

For RAG (Retrieval-Augmented Generation) workflows:

```bash
docker compose --profile qdrant up -d
```

Qdrant will be available at `localhost:6333`. When configuring Qdrant in Flowise, use:
- **Host:** `qdrant`
- **Port:** `6333`

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [Usage Guide](docs/usage.md) | Detailed instructions for using the environment |
| [Architecture](docs/architecture.md) | Overview of components and how they interact |
| [Sample Flows](docs/sample-flows.md) | Example workflows to get you started |

## 📁 Project Structure

```
flowise-playground/
├── docker-compose.yml    # Main Docker Compose configuration
├── .env.example          # Environment variables template
├── docs/
│   ├── architecture.md   # System architecture overview
│   ├── usage.md          # Detailed usage instructions
│   └── sample-flows.md   # Example workflow descriptions
└── README.md             # This file
```

## 🛠️ Common Commands

| Command | Description |
|---------|-------------|
| `docker compose up -d` | Start Flowise |
| `docker compose --profile qdrant up -d` | Start Flowise + Qdrant |
| `docker compose down` | Stop all services |
| `docker compose logs -f` | View logs |
| `docker compose pull` | Update to latest images |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [FlowiseAI Documentation](https://docs.flowiseai.com/)
- [FlowiseAI GitHub](https://github.com/FlowiseAI/Flowise)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
