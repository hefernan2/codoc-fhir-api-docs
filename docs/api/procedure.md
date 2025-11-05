---
title: Procedure
---

# Procedure - Medical Acts

The **Procedure** resource represents medical acts (surgery, interventions, technical examinations).

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/procedure/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/procedure/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/procedure/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/procedure/{id}/</span>
</div>

## Thesaurus Filtering

This resource filters on `thesaurus_code = "Acte"` (configurable via `THESAURUS_CODE_PROCEDURE`).

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | preparation, in-progress, completed, stopped |
| `code` | CodeableConcept | ✅ Yes | Act type (CCAM, etc.) |
| `subject` | Reference | ✅ Yes | Related patient |
| `encounter` | Reference | No | Associated stay |
| `performedDateTime` | dateTime | No | Date/time performed |
| `performedPeriod` | Period | No | Performance period |

## Create a Medical Act

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/procedure/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Procedure",
        "status": "completed",
        "code": {
          "coding": [{
            "system": "http://codoc.com/fhir/codesystem/Acte",
            "code": "EBQH001",
            "display": "Laparoscopic appendectomy"
          }]
        },
        "subject": {"reference": "Patient/123"},
        "encounter": {"reference": "Encounter/789"},
        "performedDateTime": "2024-01-15T14:00:00Z"
      }'
    ```

=== "Python"
    ```python
    procedure = {
        "resourceType": "Procedure",
        "status": "completed",
        "code": {
            "coding": [{
                "system": "http://codoc.com/fhir/codesystem/Acte",
                "code": "EBQH001",
                "display": "Laparoscopic appendectomy"
            }]
        },
        "subject": {"reference": "Patient/123"},
        "encounter": {"reference": "Encounter/789"},
        "performedDateTime": "2024-01-15T14:00:00Z"
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/procedure/", json=procedure)
    ```

## Status Codes

| Code | Description |
|------|-------------|
| `preparation` | In preparation |
| `in-progress` | In progress |
| `not-done` | Not performed |
| `on-hold` | On hold |
| `stopped` | Stopped |
| `completed` | Completed |
| `entered-in-error` | Data entry error |

## Use Cases

### Surgical Act

```json
{
  "status": "completed",
  "code": {"coding": [{"code": "HBQK004", "display": "Coronary angiography"}]},
  "subject": {"reference": "Patient/123"},
  "performedDateTime": "2024-01-15T09:00:00Z"
}
```

### Act Over a Period

```json
{
  "status": "completed",
  "code": {"coding": [{"code": "YYYY123", "display": "Radiotherapy"}]},
  "subject": {"reference": "Patient/123"},
  "performedPeriod": {
    "start": "2024-01-10T00:00:00Z",
    "end": "2024-02-15T00:00:00Z"
  }
}
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Acte" thesaurus (CCAM)

<div class="quick-links">
  <a href="../medicationrequest/">💊 MedicationRequest</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
