# Development Setup with Auto-Reload

This guide explains how to run Dify in development mode with automatic hot-reload, so your code changes are reflected in real-time in Docker containers.

## Quick Start

```bash
cd docker
./dev-start.sh
```

This will:
- Create `.env` file if it doesn't exist
- Stop any existing containers
- Start all services with hot-reload enabled
- Watch for file changes and auto-reload

## How It Works

The development setup uses:

1. **Volume Mounts**: Your local source code is mounted into the containers, so changes are immediately visible
2. **Hot Reload**:
   - **API**: Flask's `--reload` flag automatically restarts the server on Python file changes
   - **Web**: Next.js dev server with Turbopack provides instant hot-reload for React components
   - **Worker**: Celery worker with `--reload` flag restarts on code changes
3. **Docker Compose Watch** (optional): If you have Docker Compose v2.22+, file changes are automatically synced

## Manual Start

If you prefer to start manually:

```bash
cd docker

# Start with watch mode (Docker Compose v2.22+)
docker compose -f docker-compose.yaml -f docker-compose.dev.yaml up --watch

# Or without watch mode (still has hot-reload via volume mounts)
docker compose -f docker-compose.yaml -f docker-compose.dev.yaml up
```

## What Gets Hot-Reloaded

### API (Python/Flask)
- ✅ Python files (`.py`)
- ✅ Configuration files
- ⚠️ Requires restart: Database migrations, new dependencies

### Web (Next.js/React)
- ✅ React components
- ✅ TypeScript files
- ✅ CSS/styling
- ✅ API routes
- ⚠️ Requires restart: `package.json` changes, new dependencies

### Worker (Celery)
- ✅ Task definitions
- ✅ Python code
- ⚠️ Requires restart: New Celery tasks, configuration changes

## Stopping the Environment

Press `Ctrl+C` to stop, or in another terminal:

```bash
cd docker
docker compose -f docker-compose.yaml -f docker-compose.dev.yaml down
```

## Troubleshooting

### Changes not reflecting?

1. **Check volume mounts**: Ensure your code is actually mounted
   ```bash
   docker compose -f docker-compose.yaml -f docker-compose.dev.yaml exec api ls -la /app/api
   ```

2. **Check logs**: Look for reload messages
   ```bash
   docker compose -f docker-compose.yaml -f docker-compose.dev.yaml logs -f api
   ```

3. **Force restart**: Sometimes a manual restart helps
   ```bash
   docker compose -f docker-compose.yaml -f docker-compose.dev.yaml restart api
   ```

### Port conflicts?

If ports 3000 or 5001 are already in use, you can modify the ports in `docker-compose.dev.yaml`:

```yaml
web:
  ports:
    - "3001:3000"  # Change host port
```

### Performance issues?

- Use `:cached` flag on volume mounts (already configured)
- Exclude large directories like `node_modules` and `.venv` (already configured)
- Consider running services locally instead of in Docker for faster iteration

## Development vs Production

| Feature | Development | Production |
|---------|------------|------------|
| Source Code | Mounted from host | Copied into image |
| Hot Reload | ✅ Enabled | ❌ Disabled |
| Debug Mode | ✅ Enabled | ❌ Disabled |
| Optimizations | ❌ Disabled | ✅ Enabled |
| Logging | Verbose | Production level |

## Next Steps

- Make changes to your code
- Watch the logs to see reloads happen automatically
- Access the app at http://localhost/install (or http://localhost:3000 for web directly)

For more information, see the main [README.md](./README.md).

