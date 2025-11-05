---
title: Installation
---

# Installation

This guide walks you through the installation and initial configuration of the Codoc FHIR API.

## Prerequisites

Before you begin, verify that you have:

=== "Docker (Recommended)"
    ```bash
    # Verify Docker and Docker Compose
    docker --version      # >= 20.10
    docker compose version # >= 2.0
    ```

=== "Manual installation"
    ```bash
    # Verify Python
    python3 --version  # >= 3.8
    
    # Verify PostgreSQL
    psql --version     # >= 12
    
    # Verify pip
    pip3 --version     # >= 21.0
    ```

## Installation with Docker (Recommended)

Docker simplifies installation by managing all dependencies.

### 1. Clone the repository

```bash
git clone https://github.com/votre-org/codoc-fhir.git
cd codoc-fhir
```

### 2. Configure environment variables

Create a `.env` file in the root:

```bash
# Database
DB_NAME=codoc_fhir
DB_USER=django
DB_PASSWORD=your_secure_password
DB_HOST=db
DB_PORT=5432

# Django
SECRET_KEY=your_generated_secret_key
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1,your-domain.com

# FHIR (⚠️ Use 4.3.0 - 5.0.0 not yet available in production)
DEFAULT_FHIR_VERSION=4.3.0
```

!!! tip "Generate a secret key"
    ```bash
    python3 -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
    ```

### 3. Start the services

```bash
# Start PostgreSQL + Redis + Django API
docker compose up --build

# In detached mode (background)
docker compose up -d --build
```

### 4. Apply migrations

```bash
# In a new terminal
docker compose exec web python3 manage.py migrate
```

### 5. Create a superuser (optional)

```bash
docker compose exec web python3 manage.py createsuperuser
```

### 6. Verify the installation

```bash
# Test the health endpoint
curl http://localhost:8000/v4.3.0/metadata/

# Expected response: FHIR CapabilityStatement
```

!!! success "Success"
    If you receive a FHIR JSON with `"resourceType": "CapabilityStatement"`, installation succeeded! 🎉

## Manual Installation

For more control or in environments without Docker.

### 1. Clone the repository

```bash
git clone https://github.com/votre-org/codoc-fhir.git
cd codoc-fhir
```

### 2. Create a virtual environment

```bash
# Create the environment
python3 -m venv venv

# Activate the environment
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate     # Windows
```

### 3. Install dependencies

```bash
# Install production dependencies
pip install -r requirements.txt

# For development (tests, linting)
pip install -r requirements_dev.txt
```

### 4. Configure PostgreSQL

```bash
# Connect to PostgreSQL
psql -U postgres

# Create the database
CREATE DATABASE codoc_fhir;
CREATE USER django WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE codoc_fhir TO django;

# Exit psql
\q
```

### 5. Configure environment variables

Create a `.env` file in the root:

```bash
DB_NAME=codoc_fhir
DB_USER=django
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432

SECRET_KEY=your_secret_key
DEBUG=False
ALLOWED_HOSTS=localhost,127.0.0.1

DEFAULT_FHIR_VERSION=4.3.0
```

### 6. Apply migrations

```bash
python3 manage.py migrate
```

### 7. Create a superuser

```bash
python3 manage.py createsuperuser
```

### 8. Start the server

```bash
# Development mode
python3 manage.py runserver

# Production mode (with Gunicorn)
gunicorn test_project.wsgi:application --bind 0.0.0.0:8000
```

### 9. Verify the installation

```bash
curl http://localhost:8000/v4.3.0/metadata/
```

## Common Problems

### Error: "port 5432 already in use"

PostgreSQL is already running on your machine.

**Solution with Docker:**
```bash
# Stop local PostgreSQL
sudo service postgresql stop  # Linux
brew services stop postgresql # Mac

# Restart Docker Compose
docker compose up
```

**Manual solution:**
```bash
# Change the port in .env
DB_PORT=5433

# Or stop local PostgreSQL and use Docker's
docker compose up db
```

### Error: "relation does not exist"

Migrations have not been applied.

**Solution:**
```bash
# Docker
docker compose exec web python3 manage.py migrate

# Manual
python3 manage.py migrate
```

### Error: "ALLOWED_HOSTS"

The access address is not in `ALLOWED_HOSTS`.

**Solution:**
```bash
# Add your domain/IP in .env
ALLOWED_HOSTS=localhost,127.0.0.1,192.168.1.100,your-domain.com
```

## Installation Verification

### 1. Metadata endpoint

```bash
curl http://localhost:8000/v4.3.0/metadata/
```

**Expected response:**
```json
{
  "resourceType": "CapabilityStatement",
  "status": "active",
  "fhirVersion": "4.3.0",
  "format": ["application/fhir+json", "application/json"],
  "rest": [...]
}
```

### 2. Create a test organization

```bash
curl -X POST http://localhost:8000/v4.3.0/Organization/ \
  -H "Content-Type: application/json" \
  -d '{
    "resourceType": "Organization",
    "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "TEST001"}],
    "name": "Test Hospital",
    "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "site"}]}]
  }'
```

**Expected response:**
```json
{
  "resourceType": "Organization",
  "id": "1",
  "identifier": [...],
  "name": "Test Hospital",
  ...
}
```

### 3. Retrieve the organization

```bash
curl http://localhost:8000/v4.3.0/Organization/1/
```

!!! success "Installation successful"
    If all these tests work, your Codoc FHIR API is operational! 🚀

## Next Step

Now that the API is installed, try your first API call:

[Quick Start →](quickstart.md){ .md-button .md-button--primary }
