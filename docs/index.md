---
title: Home
---

# Welcome to the Codoc FHIR API

<div class="feature-cards">
  <div class="feature-card">
    <h3>🚀 Quick Start</h3>
    <p>Launch your first API request in less than 5 minutes</p>
    <a href="getting-started/quickstart/">Get Started →</a>
  </div>
  
  <div class="feature-card">
    <h3>📚 API Reference</h3>
    <p>Complete documentation of all FHIR resources</p>
    <a href="api/">Explore the API →</a>
  </div>
  
  <div class="feature-card">
    <h3>💡 Guides</h3>
    <p>Real-world use cases and best practices</p>
    <a href="guides/">View Guides →</a>
  </div>
</div>

## What is the Codoc FHIR API?

The **Codoc FHIR API** is a complete implementation of the **FHIR R4B** standard for managing hospital clinical data. It exposes the entire Codoc data model through standardized and interoperable FHIR resources.

## Available Resources

The API exposes **10 main FHIR resources**:

| Resource | Description | Use Case |
|----------|-------------|----------|
| [Patient](api/patient/) | Patient identity and demographics | Patient records, IPP identifiers |
| [Organization](api/organization/) | Hospital structure (sites, departments, units) | Organizational hierarchy |
| [Encounter](api/encounter/) | Hospital stays and intra-hospital movements | Patient pathway, admissions |
| [DocumentReference](api/documentreference/) | Clinical documents | Reports, medical notes |
| [Observation](api/observation/) | Laboratory results and patient data | Lab analyses |
| [Procedure](api/procedure/) | Medical procedures | Interventions, examinations |
| [MedicationRequest](api/medicationrequest/) | Medication prescriptions | Prescriptions, treatments |
| [DiagnosticReport](api/diagnosticreport/) | Diagnostic reports | Imaging, EFR, ECG |
| [CodeSystem](api/codesystem/) | Medical vocabularies (thesaurus) | ICD-10, ATC, local codes |
| [Phenotype](api/observation-phenotype/) | NLP semantic enrichment | Medical concept extraction |

## Standards and Compliance

<div class="feature-cards">
  <div class="feature-card">
    <h3>✅ FHIR R4B (Production)</h3>
    <p>HL7 FHIR standard version 4.3.0 (v5.0.0 coming soon)</p>
  </div>
  
  <div class="feature-card">
    <h3>🔒 Secure</h3>
    <p>JWT, rate limiting, CORS, GDPR compliant</p>
  </div>
  
  <div class="feature-card">
    <h3>🔄 RESTful</h3>
    <p>Complete CRUD, automatic validation</p>
  </div>
</div>

## Quick Start

### 1. Check server status

⚠️ **Use version 4.3.0 only** - Version 5.0.0 is not yet available in production.

```bash
curl http://localhost:8000/v4.3.0/metadata
```

### 2. Create a patient

=== "curl"

    ```bash
    curl -X POST http://localhost:8000/v4.3.0/patient/ \
      -H 'Content-Type: application/json' \
      -d '{
      "resourceType": "Patient",
      "identifier": [{"use": "usual", "value": "IPP123456"}],
      "birthDate": "1980-05-15",
      "gender": "male"
    }'
    ```

=== "Python"

    ```python
    import requests

    response = requests.post(
        'http://localhost:8000/v4.3.0/patient/',
        json={
            'resourceType': 'Patient',
            'identifier': [{'use': 'usual', 'value': 'IPP123456'}],
            'birthDate': '1980-05-15',
            'gender': 'male'
        }
    )
    
    patient = response.json()
    print(f"Patient created with ID: {patient['id']}")
    ```

=== "JavaScript"

    ```javascript
    const response = await fetch('http://localhost:8000/v4.3.0/patient/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        resourceType: 'Patient',
        identifier: [{ use: 'usual', value: 'IPP123456' }],
        birthDate: '1980-05-15',
        gender: 'male'
      })
    });
    
    const patient = await response.json();
    console.log(`Patient created with ID: ${patient.id}`);
    ```

### 3. Retrieve the patient

```bash
curl http://localhost:8000/v4.3.0/patient/123/
```

!!! success "Ready to explore?"
    Check out the [Quick Start](getting-started/quickstart/) for a complete step-by-step guide.

## Key Features

### Multi-IPP

Native management of multiple identifiers per patient (master, history).

```json
{
  "identifier": [
    {"use": "official", "value": "123"},
    {"use": "usual", "value": "IPP123456"}
  ]
}
```

### Organizational Hierarchy

Three levels of hospital structure: Instance → Site → Department → Unit.

```json
{
  "resourceType": "Organization",
  "type": [{"coding": [{"code": "department"}]}],
  "partOf": {"reference": "Organization/site-1"}
}
```

### Semantic Enrichment

Automatic extraction of medical concepts from clinical documents.

```json
{
  "resourceType": "Observation",
  "code": {"coding": [{"code": "E11", "display": "Type 2 Diabetes"}]},
  "derivedFrom": [{"reference": "DocumentReference/456"}],
  "valueString": "type 2 diabetes"
}
```

## Important Limitation

!!! warning "LIST operations not supported"
    `GET` requests without ID (e.g., `GET /patient/`) return **HTTP 405 Method Not Allowed**. Always use targeted requests with the resource ID (e.g., `GET /patient/123/`).

## Rate Limiting

!!! info "API rate limiting"
    To protect API stability, rate limiting is enforced:
    
    - **Anonymous users**: 100 requests/hour
    - **Authenticated users**: 1,000 requests/hour
    
    When the limit is reached, the API returns **HTTP 429 (Too Many Requests)**. Rate limits reset hourly.

## FHIR Versions

| Version | URL | Status | Notes |
|---------|-----|--------|-------|
| **R4B (4.3.0)** | `/v4.3.0/` | ✅ Production | Recommended version |
| **R5 (5.0.0)** | `/v5.0.0/` | ⚠️ Development | Not available yet |

## Next Steps

<div class="quick-links">
  <a href="getting-started/quickstart/" class="quick-link">🚀 Quick Start</a>
  <a href="api/" class="quick-link">📖 API Reference</a>
  <a href="guides/" class="quick-link">💡 Practical Guides</a>
</div>

---

**Last update**: November 5, 2025  
**API Version**: 1.0.0  
**FHIR Version**: R4B (4.3.0) / R5 (5.0.0)
