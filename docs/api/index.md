---
title: API Reference
---

# FHIR API Reference

Complete documentation of all FHIR resources exposed by the Codoc API.

## API Versions

⚠️ **Only version 4.3.0 is currently available in production.** Version 5.0.0 is in development and not usable yet.

| Version | Status | Base URL |
|---------|--------|----------|
| **4.3.0 (R4B)** | ✅ Production | `/v4.3.0/` |
| **5.0.0 (R5)** | ⚠️ Development (Not available) | `/v5.0.0/` |

Always use `/v4.3.0/` in your API requests.

## Overview

The API exposes **10 FHIR resources** covering the entire clinical data model:

<div class="feature-cards">
  <div class="feature-card">
    <h3>👤 Identity</h3>
    <p><a href="patient/">Patient</a> - Demographics and identifiers</p>
  </div>
  
  <div class="feature-card">
    <h3>🏥 Organization</h3>
    <p><a href="organization/">Organization</a> - Hospital structure</p>
  </div>
  
  <div class="feature-card">
    <h3>🛏️ Stays</h3>
    <p><a href="encounter/">Encounter</a> - Admissions and movements</p>
  </div>
  
  <div class="feature-card">
    <h3>📄 Documents</h3>
    <p><a href="documentreference/">DocumentReference</a> - Clinical documents</p>
  </div>
  
  <div class="feature-card">
    <h3>🔬 Observations</h3>
    <p><a href="observation/">Observation</a> - Lab results<br>
    <a href="observation-patient-data/">Observation-patient-data</a> - Patient data<br>
    <a href="observation-phenotype/">Observation-phenotype</a> - NLP phenotypes</p>
  </div>
  
  <div class="feature-card">
    <h3>💊 Prescriptions</h3>
    <p><a href="medicationrequest/">MedicationRequest</a> - Medications</p>
  </div>
  
  <div class="feature-card">
    <h3>🏥 Procedures</h3>
    <p><a href="procedure/">Procedure</a> - Medical procedures</p>
  </div>
  
  <div class="feature-card">
    <h3>📋 Diagnostics</h3>
    <p><a href="diagnosticreport/">DiagnosticReport</a> - Reports</p>
  </div>
  
  <div class="feature-card">
    <h3>📚 Terminology</h3>
    <p><a href="codesystem/">CodeSystem</a> - Medical thesauri</p>
  </div>
</div>

## Summary Table

| Resource | Endpoint | Primary Use |
|----------|----------|-------------|
| **[Patient](patient/)** | `/v4.3.0/patient/` | Patient identity and demographics |
| **[Organization](organization/)** | `/v4.3.0/organization/` | Hospital hierarchy (sites, departments, units) |
| **[Encounter](encounter/)** | `/v4.3.0/encounter/` | Stays and intra-hospital movements |
| **[DocumentReference](documentreference/)** | `/v4.3.0/documentreference/` | HTML clinical documents with metadata |
| **[Observation](observation/)** | `/v4.3.0/observation/` | Lab results and measurements |
| **[Observation-patient-data](observation-patient-data/)** | `/v4.3.0/observation/patient-data/` | Patient-specific traits (weight, height, allergies) |
| **[Observation-phenotype](observation-phenotype/)** | `/v4.3.0/observation/phenotype/` | Phenotypes extracted by NLP from documents |
| **[MedicationRequest](medicationrequest/)** | `/v4.3.0/medicationrequest/` | Medication prescriptions |
| **[Procedure](procedure/)** | `/v4.3.0/procedure/` | Medical procedures (CCAM, etc.) |
| **[DiagnosticReport](diagnosticreport/)** | `/v4.3.0/diagnosticreport/` | Diagnostic reports |
| **[CodeSystem](codesystem/)** | `/v4.3.0/codesystem/` | Medical thesauri (ICD10, ATC, CCAM, etc.) |

## Read Operations

All resources support standard read operations:

| Operation | Method | Endpoint | Description |
|-----------|--------|----------|-------------|
| **Read** | <span class="http-method get">GET</span> | `/v4.3.0/{resource}/{id}/` | Retrieve a resource by ID |
| **List (Search)** | <span class="http-method get">GET</span> | `/v4.3.0/{resource}/` | Search resources with pagination |

## List / Search

The List action retrieves a collection of resources with pagination support.

**Endpoint:** `GET /v4.3.0/{resource}/`

### Pagination Parameters

| Parameter | Default | Max | Description |
|-----------|---------|-----|-------------|
| `_count` | 20 | 100 | Number of resources per page |
| `page` | 1 | - | Page number for navigation |

### Response Structure

The response is a FHIR Bundle of type `searchset`:

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 45,
  "link": [
    {"relation": "self", "url": "{API_URL}/v4.3.0/patient/?_count=10"},
    {"relation": "next", "url": "{API_URL}/v4.3.0/patient/?_count=10&page=2"}
  ],
  "entry": [
    {"resource": {"resourceType": "Patient", "id": "1", ...}},
    {"resource": {"resourceType": "Patient", "id": "2", ...}}
  ]
}
```

### Example

```bash
# List patients with 5 per page
curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/patient/?_count=5"

# Get page 2
curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/patient/?_count=5&page=2"
```

## FHIR Date Prefixes

Date filters (`date`, `birthdate`, `death-date`, `_lastUpdated`) support FHIR comparison prefixes:

| Prefix | Operator | Example |
|--------|----------|---------|
| `ge` | ≥ (greater than or equal) | `?date=ge2024-01-01` |
| `le` | ≤ (less than or equal) | `?date=le2024-12-31` |
| `gt` | > (strictly greater than) | `?date=gt2024-01-01` |
| `lt` | < (strictly less than) | `?date=lt2024-12-31` |
| `ne` | ≠ (not equal) | `?date=ne2024-06-15` |

Prefixes can be combined: `?date=ge2024-01-01&date=le2024-12-31` retrieves all records from 2024.

## Request Format

### HTTP Headers

```http
Content-Type: application/json
Accept: application/json
```

FHIR alternative:
```http
Content-Type: application/fhir+json
Accept: application/fhir+json
```

### Authentication

```http
Authorization: Api-Key {API_KEY}
```

API keys start with `fhir_`. Pass this header with every request.

#### Key Permissions

Each API key is created with permissions scoped to specific FHIR resources. A key may grant access to one resource (e.g., `Patient` only), a subset, or all resources (`*`).

Contact your administrator to obtain a key or to adjust which resources it can access.

## HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| **200** | OK - Request successful | Successful GET |
| **401** | Unauthorized - Authentication required | Missing or invalid credentials |
| **403** | Forbidden - Insufficient permissions | Valid credentials but no read access |
| **404** | Not Found - Resource not found | Non-existent ID |
| **429** | Too Many Requests - Rate limit reached | Rate limit exceeded (limits not yet finalized) |
| **500** | Internal Server Error | Application bug |


## FHIR Versioning

The API supports two FHIR versions via the URL:

| Version | URL | Status |
|---------|-----|--------|
| **R4B** | `/v4.3.0/` | ✅ Recommended |
| **R5** | `/v5.0.0/` | ⚠️ Development (Not available) |

!!! warning "Use version 4.3.0 in production"
    Only version 4.3.0 is currently available in production. Version 5.0.0 is in development and not usable yet.

## Automatic Logging

All FHIR requests are automatically logged via the `FHIRAccessLogMiddleware` middleware:

**Recorded data:**
- User (ID or "anonymous")
- IP address
- HTTP method
- Full URL
- Headers (Content-Type, Accept, User-Agent)
- HTTP status
- Timestamps (start, end)
- Processing duration

!!! info "Confidentiality"
    Request bodies are **never** logged to protect health data.

## Next Steps

Explore detailed documentation for each resource:

<div class="quick-links">
  <a href="patient/">👤 Patient</a>
  <a href="organization/">🏥 Organization</a>
  <a href="encounter/">🛏️ Encounter</a>
  <a href="observation/">🔬 Observation</a>
</div>

Or check out the practical guides:

[Practical Guides →](../guides/){ .md-button .md-button--primary }
