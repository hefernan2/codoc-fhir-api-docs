---
title: DiagnosticReport
---

# DiagnosticReport - Diagnostic Reports

The **DiagnosticReport** resource represents diagnostic examination reports.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/diagnosticreport/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/diagnosticreport/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/diagnosticreport/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/diagnosticreport/{id}/</span>
</div>

## Thesaurus Filtering

Filters on `thesaurus_code = "Diagnostic"` (configurable via `THESAURUS_CODE_DIAGNOSTIC`).

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | registered, partial, preliminary, final |
| `code` | CodeableConcept | ✅ Yes | Examination type (from thesaurus) |
| `subject` | Reference | ✅ Yes | Related patient |
| `encounter` | Reference | No | Associated stay |
| `effectiveDateTime` | dateTime | No | Examination date |
| `issued` | instant | No | Report publication date |

## Create a Diagnostic Report

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/diagnosticreport/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "DiagnosticReport",
        "status": "final",
        "code": {
          "coding": [{
            "system": "http://codoc.com/fhir/codesystem/Diagnostic",
            "code": "ECG",
            "display": "Electrocardiogram"
          }]
        },
        "subject": {"reference": "Patient/123"},
        "encounter": {"reference": "Encounter/789"},
        "effectiveDateTime": "2024-01-15T10:00:00Z",
        "issued": "2024-01-15T14:30:00Z"
      }'
    ```

=== "Python"
    ```python
    report = {
        "resourceType": "DiagnosticReport",
        "status": "final",
        "code": {
            "coding": [{
                "system": "http://codoc.com/fhir/codesystem/Diagnostic",
                "code": "ECG",
                "display": "Electrocardiogram"
            }]
        },
        "subject": {"reference": "Patient/123"},
        "effectiveDateTime": "2024-01-15T10:00:00Z"
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/diagnosticreport/", json=report)
    ```

## Status Codes

| Code | Description |
|------|-------------|
| `registered` | Registered |
| `partial` | Partial results |
| `preliminary` | Preliminary |
| `final` | Final |
| `amended` | Amended |
| `corrected` | Corrected |
| `cancelled` | Cancelled |

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Diagnostic" thesaurus

<div class="quick-links">
  <a href="../codesystem/">📚 CodeSystem</a>
  <a href="../../guides/">📖 Practical Guides</a>
</div>
