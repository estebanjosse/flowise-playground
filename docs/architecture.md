# Architecture Overview

This document describes the architecture of the FlowiseAI Docker environment, including all components, optional services, and how they interact.

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Docker Compose Network                       │
│                      (flowise-network)                          │
│                                                                 │
│  ┌─────────────────────┐      ┌─────────────────────────────┐  │
│  │      Flowise        │      │   Qdrant (Optional)         │  │
│  │   (Port: 3000)      │◄────►│   (Ports: 6333, 6334)       │  │
│  │                     │      │                             │  │
│  │  - Web UI           │      │  - Vector Database          │  │
│  │  - API Server       │      │  - REST API                 │  │
│  │  - Flow Engine      │      │  - gRPC API                 │  │
│  └─────────────────────┘      └─────────────────────────────┘  │
│           │                              │                      │
└───────────┼──────────────────────────────┼──────────────────────┘
            │                              │
            ▼                              ▼
    ┌───────────────┐              ┌───────────────┐
    │ flowise_data  │              │  qdrant_data  │
    │   (Volume)    │              │   (Volume)    │
    └───────────────┘              └───────────────┘
```

## Core Components

### Flowise

**Container:** `flowise`  
**Image:** `flowiseai/flowise:latest`  
**Port:** 3000 (configurable via `FLOWISE_PORT`)

Flowise is the main application that provides:

- **Web UI**: A visual drag-and-drop interface for building LLM workflows
- **API Server**: REST API for programmatic access to flows
- **Flow Engine**: Executes the configured LLM pipelines

**Data Persistence:**
- All Flowise data (flows, credentials, API keys) is stored in the `flowise_data` volume at `/root/.flowise`

**Configuration Options:**
| Variable | Description | Default |
|----------|-------------|---------|
| `FLOWISE_PORT` | External port for Flowise UI | `3000` |
| `FLOWISE_USERNAME` | Username for authentication | _(empty)_ |
| `FLOWISE_PASSWORD` | Password for authentication | _(empty)_ |
| `LOG_LEVEL` | Logging verbosity | `info` |

## Optional Components

### Qdrant Vector Database

**Container:** `qdrant`  
**Image:** `qdrant/qdrant:latest`  
**Ports:** 6333 (REST), 6334 (gRPC)  
**Profile:** `qdrant`

Qdrant is a high-performance vector database that enables:

- **Vector Storage**: Store and index high-dimensional vectors
- **Similarity Search**: Fast nearest neighbor search for RAG workflows
- **Filtering**: Combine vector search with payload filtering

**When to use Qdrant:**
- Building RAG (Retrieval-Augmented Generation) applications
- Document Q&A systems
- Semantic search functionality
- Any workflow requiring vector embeddings storage

**Data Persistence:**
- Vector data is stored in the `qdrant_data` volume at `/qdrant/storage`

**Connecting Flowise to Qdrant:**
When configuring a Qdrant node in Flowise, use:
- **Host:** `qdrant` (the container name)
- **Port:** `6333`

## Network Architecture

All services communicate over a dedicated Docker bridge network called `flowise-network`. This provides:

- **Service Discovery**: Containers can reference each other by name
- **Isolation**: Services are isolated from other Docker networks
- **Security**: No external access except through exposed ports

## Volume Management

| Volume | Purpose | Mount Point |
|--------|---------|-------------|
| `flowise_data` | Flowise configuration, flows, and credentials | `/root/.flowise` |
| `qdrant_data` | Qdrant vector storage | `/qdrant/storage` |

**Backup Recommendation:**
Regularly backup these volumes to prevent data loss:

```bash
# Backup Flowise data
docker run --rm -v flowise-playground_flowise_data:/data -v $(pwd):/backup alpine tar czf /backup/flowise_backup.tar.gz -C /data .

# Backup Qdrant data
docker run --rm -v flowise-playground_qdrant_data:/data -v $(pwd):/backup alpine tar czf /backup/qdrant_backup.tar.gz -C /data .
```

## Health Checks

All services include health checks to ensure reliability:

| Service | Health Check | Interval |
|---------|--------------|----------|
| Flowise | HTTP GET on port 3000 | 30s |
| Qdrant | HTTP GET on `/readyz` | 30s |

## Extending the Setup

### Adding New Services

To add additional services (e.g., Redis, PostgreSQL), add them to `docker-compose.yml`:

```yaml
services:
  # ... existing services ...

  redis:
    image: redis:alpine
    container_name: redis
    profiles:
      - redis
    ports:
      - "6379:6379"
    networks:
      - flowise-network
```

Then start with the profile:
```bash
docker compose --profile redis up -d
```

### Using External Services

To connect to external services (e.g., cloud databases), configure the appropriate environment variables or connection strings in your Flowise flow configurations.
