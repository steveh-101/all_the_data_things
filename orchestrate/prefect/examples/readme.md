# Prefect Examples

Prefect workflow orchestration examples.

## Setup

This project uses [uv](https://docs.astral.sh/uv/) for Python package management.

```bash
# Install uv if you haven't already
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create virtual environment and install dependencies
uv sync

# Install with dev dependencies
uv sync --extra dev
```

## Running Flows

```bash
# Run a flow locally
uv run python examples/flows/rain_flow.py
```

## Examples

### rain_flow.py

A weather notification flow that:
- Pulls 5-day forecast from OpenWeatherMap API
- Checks if rain is expected
- Sends a Slack notification with the forecast

**Required Prefect Blocks:**
- `Secret` named `openweathermap-api-key` - Your OpenWeatherMap API key
- `SlackCredentials` named `allthedatathings` - Slack credentials for notifications

Originally based on [this demo](https://github.com/kmoonwright/prefect-demos/blob/main/sales/rain_flow.py), updated for Prefect 3.x.
