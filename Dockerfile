# Stage 1: Builder
FROM python:3.13-slim AS builder

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock README.md ./

# Install dependencies
RUN uv sync --no-dev --frozen

# Stage 2: Runtime
FROM python:3.13-slim

# Install uv in runtime as well to use 'uv run'
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application code
COPY . .

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV FREEBUFF_TOKEN=""
ENV FREEBUFF_API_KEY=""
ENV FREEBUFF_AD_PROVIDERS="gravity,zeroclick"
ENV FREEBUFF_PROXY_ENABLED="false"
ENV FREEBUFF_PROXY_URL=""
ENV FREEBUFF_DEBUG="false"
ENV FREEBUFF_LOG_LEVEL="INFO"
ENV FREEBUFF_LOG_BODY_CHARS="2000"
ENV FREEBUFF_LOG_COLOR="true"
ENV FREEBUFF_HOST="0.0.0.0"
ENV FREEBUFF_PORT="8000"

# Expose port
EXPOSE 8000

# Run the application
CMD ["uv", "run", "freebuff2api"]
