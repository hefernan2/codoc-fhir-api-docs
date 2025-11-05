---
title: Getting Started
---

# Getting Started with the Codoc FHIR API

This section guides you through your first API calls with the Codoc FHIR API.

## Overview

The Codoc FHIR API is a RESTful API that implements the FHIR R4B standard. It requires:

- ✅ An accessible Codoc FHIR server (HTTP/HTTPS)
- ✅ A PostgreSQL database with the Codoc data model
- ✅ An HTTP client (curl, Postman, or HTTP library)

## Quick Access

<div class="feature-cards">
  <div class="feature-card">
    <h3>🚀 Quick Start</h3>
    <p>Your first API call in 5 minutes</p>
    <a href="quickstart/">Get Started →</a>
  </div>
</div>

## What You'll Need

### Technical Environment

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **Python** | 3.8+ | 3.11+ |
| **PostgreSQL** | 12+ | 14+ |

### Development Tools

- **HTTP Client**: curl, Postman, Insomnia, or HTTPie
- **JSON Editor**: jq, python -m json.tool
- **Terminal**: bash, zsh, PowerShell

### Recommended Knowledge

- HTTP/REST API basics
- JSON format
- Command line (bash/zsh)
- FHIR concepts (optional but helpful)

## Key Concepts

### FHIR Resources

A **resource** is a business entity (Patient, Organization, Encounter, etc.). Each resource has:

- A `resourceType` (e.g., "Patient")
- A unique `id`
- Required and optional fields
- Relationships to other resources

### Endpoints

The API exposes RESTful endpoints for each resource:

```
GET    /v4.3.0/patient/123/    # Read
POST   /v4.3.0/patient/        # Create
PUT    /v4.3.0/patient/123/    # Update (complete)
PATCH  /v4.3.0/patient/123/    # Update (partial)
DELETE /v4.3.0/patient/123/    # Delete
```

### Versioning

The API supports versioning in the URL:

- `/v4.3.0/` - FHIR R4B (version 4.3.0) ✅ **Recommended**
- `/v5.0.0/` - FHIR R5 (version 5.0.0) ⚠️ **Development (not available yet)**

### Data Format

All exchanges use JSON:

```http
Content-Type: application/json
Accept: application/json
```

FHIR alternative:
```http
Content-Type: application/fhir+json
Accept: application/fhir+json
```

## Known Limitations

!!! warning "LIST operations not supported"
    `GET` requests without a specific ID return **HTTP 405**:
    
    ❌ `GET /v4.3.0/patient/` → Error 405  
    ✅ `GET /v4.3.0/patient/123/` → OK

!!! info "SEARCH operations coming soon"
    FHIR search parameters (`?name=Smith`) are not yet implemented.

## Next Step

Ready to get started? Follow the quick start guide:

[Quick Start →](quickstart.md){ .md-button .md-button--primary }
