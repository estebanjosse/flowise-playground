# Usage Guide

This guide covers how to use the FlowiseAI Docker environment for building and running LLM workflows.

## Prerequisites

Before you begin, ensure you have:

- [Docker](https://docs.docker.com/get-docker/) (version 20.10 or later)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0 or later)
- At least 4GB of available RAM
- Internet connection (for pulling Docker images)

## Starting the Environment

### Basic Setup

1. **Copy the environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Start the full stack:**
   ```bash
   docker compose up -d
   ```

   By default, `.env.example` sets `COMPOSE_PROFILES=flowise,qdrant,ollama`, so this command starts the full stack. To start fewer services, edit `COMPOSE_PROFILES` in your `.env` file.

3. **Access Flowise UI:**
   Open your browser and navigate to [http://localhost:3000](http://localhost:3000)

### Included by Default

With the default `.env` configuration, `docker compose up -d` starts:

- **Flowise** on `http://localhost:3000`
- **Qdrant** on `localhost:6333`
- **Ollama** on `http://localhost:11434`

### Customizing the Default Startup Set

Use `COMPOSE_PROFILES` in your `.env` file to control the default startup set.

Example values:

```env
COMPOSE_PROFILES=flowise
COMPOSE_PROFILES=flowise,qdrant
COMPOSE_PROFILES=flowise,ollama
COMPOSE_PROFILES=flowise,qdrant,ollama
```

After updating `.env`, run:

```bash
docker compose up -d
```

If you need explicit profile-based startup for a one-off run, you can still use `docker compose --profile ... up -d`, but the default workflow in this repository is to manage startup through `COMPOSE_PROFILES`.

## Stopping the Environment

### Stop all services:
```bash
docker compose down
```

### Stop and remove volumes (⚠️ deletes all data):
```bash
docker compose down -v
```

## Viewing Logs

### All services:
```bash
docker compose logs -f
```

### Specific service:
```bash
docker compose logs -f flowise
docker compose logs -f qdrant
docker compose logs -f ollama
```

## Configuration

### Changing Ports

If the default ports conflict with other services, modify your `.env` file:

```env
FLOWISE_PORT=8080
QDRANT_PORT=6335
QDRANT_GRPC_PORT=6336
```

## Working with Flowise

### Creating Your First Flow

1. Open Flowise UI at [http://localhost:3000](http://localhost:3000)
2. Click **"Add New"** to create a new chatflow
3. Drag nodes from the left sidebar to the canvas
4. Connect nodes by dragging from output to input handles
5. Configure each node by clicking on it
6. Click **"Save"** to save your flow
7. Use the **"Chat"** button to test your flow

### Connecting to Qdrant

When creating a RAG workflow with Qdrant:

1. Add a **Qdrant** vector store node to your flow
2. Configure the connection:
   - **Host:** `qdrant`
   - **Port:** `6333`
   - **Collection Name:** Choose a name for your vector collection
3. Connect your embedding model and document loaders

### Using the API

Flowise provides a REST API for each flow. After saving a flow:

1. Click on the flow to open it
2. Click the **"API"** button in the toolbar
3. Copy the API endpoint and use it in your applications:

```bash
curl -X POST http://localhost:3000/api/v1/prediction/{flow-id} \
  -H "Content-Type: application/json" \
  -d '{"question": "Your question here"}'
```

## Common Tasks

### Updating Services

Pull the latest images and restart:

```bash
docker compose pull
docker compose up -d
```

### Checking Service Health

```bash
docker compose ps
```

Healthy services show `(healthy)` in the STATUS column.

With the default full stack, you should typically see `flowise`, `qdrant`, and `ollama`.

### Debugging Issues

1. **Check logs for errors:**
   ```bash
   docker compose logs flowise --tail 100
   ```

2. **Enable debug logging:**
   Edit `.env`:
   ```env
   LOG_LEVEL=debug
   ```
   Then restart:
   ```bash
   docker compose restart flowise
   ```

3. **Access container shell:**
   ```bash
   docker compose exec flowise sh
   ```

## Backing Up Your Work

### Export Flows

1. In Flowise UI, open a flow
2. Click the **"Settings"** (gear) icon
3. Select **"Export"** to download the flow as JSON

### Backup Volumes

See the [Architecture documentation](architecture.md#volume-management) for volume backup commands.

## Troubleshooting

### Port Already in Use

If you see "port is already allocated":

1. Find what's using the port:
   ```bash
   lsof -i :3000
   ```

2. Either stop the conflicting service or change the port in `.env`

### Container Won't Start

Check the logs for errors:
```bash
docker compose logs flowise
```

Common issues:
- Insufficient memory
- Volume permission issues
- Network conflicts

### Qdrant Connection Failed

Ensure Qdrant is running and use the correct hostname:
- **Inside Docker:** Use `qdrant` as the host
- **Outside Docker:** Use `localhost` with the mapped port

### Ollama Not Available

If Flowise cannot reach Ollama:

1. Confirm the service is running:
   ```bash
   docker compose ps
   ```

2. Check the Ollama logs:
   ```bash
   docker compose logs ollama --tail 100
   ```

3. Verify that `ollama` is included in `COMPOSE_PROFILES` inside your `.env` file

4. In Flowise, use `http://ollama:11434` as the Ollama base URL

## Next Steps

- Read [Sample Flows](sample-flows.md) for pre-built workflow examples
- Review [Architecture](architecture.md) for a deeper understanding of the setup
