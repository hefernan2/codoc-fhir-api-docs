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
    <p><a href="../patient/">Patient</a> - Demographics and identifiers</p>
  </div>
  
  <div class="feature-card">
    <h3>🏥 Organization</h3>
    <p><a href="../organization/">Organization</a> - Hospital structure</p>
  </div>
  
  <div class="feature-card">
    <h3>🛏️ Stays</h3>
    <p><a href="../encounter/">Encounter</a> - Admissions and movements</p>
  </div>
  
  <div class="feature-card">
    <h3>📄 Documents</h3>
    <p><a href="../documentreference/">DocumentReference</a> - Clinical documents</p>
  </div>
  
  <div class="feature-card">
    <h3>🔬 Observations</h3>
    <p><a href="../observation/">Observation</a> - Lab results<br>
    <a href="../observation-patient-data/">Observation-patient-data</a> - Patient data<br>
    <a href="../observation-phenotype/">Observation-phenotype</a> - NLP phenotypes</p>
  </div>
  
  <div class="feature-card">
    <h3>💊 Prescriptions</h3>
    <p><a href="../medicationrequest/">MedicationRequest</a> - Medications</p>
  </div>
  
  <div class="feature-card">
    <h3>🏥 Procedures</h3>
    <p><a href="../procedure/">Procedure</a> - Medical procedures</p>
  </div>
  
  <div class="feature-card">
    <h3>📋 Diagnostics</h3>
    <p><a href="../diagnosticreport/">DiagnosticReport</a> - Reports</p>
  </div>
  
  <div class="feature-card">
    <h3>📚 Terminology</h3>
    <p><a href="../codesystem/">CodeSystem</a> - Medical thesauri</p>
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

## Common CRUD Operations

All resources support standard CRUD operations:

| Operation | Method | Endpoint | Description |
|-----------|--------|----------|-------------|
| **Create** | <span class="http-method post">POST</span> | `/v4.3.0/{resource}/` | Create a new resource |
| **Read** | <span class="http-method get">GET</span> | `/v4.3.0/{resource}/{id}/` | Retrieve a resource by ID |
| **Update (complete)** | <span class="http-method put">PUT</span> | `/v4.3.0/{resource}/{id}/` | Replace completely |
| **Update (partial)** | <span class="http-method patch">PATCH</span> | `/v4.3.0/{resource}/{id}/` | Modify specific fields |
| **Delete** | <span class="http-method delete">DELETE</span> | `/v4.3.0/{resource}/{id}/` | Delete permanently |

!!! warning "LIST Limitation"
    **LIST** operations are not supported. Requests without an ID return **HTTP 405**:
    
    ❌ `GET /v4.3.0/patient/` → Error 405  
    ✅ `GET /v4.3.0/patient/123/` → OK

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

### Authentication (if enabled)

```http
Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...
```

### Request Body

All creation/modification requests use FHIR JSON format:

```json
{
  "resourceType": "Patient",
  "identifier": [{"value": "IPP123"}],
  "name": [{"family": "Smith", "given": ["John"]}],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

## HTTP Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| **200** | OK - Request successful | Successful GET, PATCH |
| **201** | Created - Resource created | Successful POST |
| **204** | No Content - Deletion successful | Successful DELETE |
| **400** | Bad Request - Invalid data | Malformed JSON, missing required field |
| **404** | Not Found - Resource not found | Non-existent ID |
| **405** | Method Not Allowed - Operation not supported | GET without ID (LIST) |
| **409** | Conflict - Constraint violated | Duplicate identifier |
| **500** | Internal Server Error | Application bug |

## Response Format

### Success (200/201)

```json
{
  "resourceType": "Patient",
  "id": "123",
  "identifier": [{"value": "IPP123"}],
  "name": [{"family": "Smith", "given": ["John"]}],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

### Error (400/404/409)

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "Patient with NIP IPP123 does not exist"
  }]
}
```

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
- HTTP method (GET, POST, PUT, PATCH, DELETE)
- Full URL
- Headers (Content-Type, Accept, User-Agent)
- HTTP status (200, 201, 400, 404, etc.)
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

[Practical Guides →](../../guides/){ .md-button .md-button--primary }
