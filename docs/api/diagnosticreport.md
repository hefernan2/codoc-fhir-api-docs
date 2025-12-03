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
| `status` | code | ✅ Yes | ⚠️ **Always "Unknown" - not customizable** |
| `code` | CodeableConcept | ✅ Yes | Examination type from "Diagnostic" thesaurus |
| `subject` | Reference | ✅ Yes | Related patient |
| `effectiveDateTime` | dateTime | ✅ Yes| Examination date |
| `encounter` | Reference | ❌ No | Associated stay |
| `issued` | instant | ❌ No | Report publication date |
| `conclusion` | string | ❌ No | Diagnostic findings/conclusion text |
| `performer` | Reference[] | ❌ No | Department (Organization/department-{id}) |

## Create a Diagnostic Report

=== "curl"
    ```bash
    curl -u username:password -X POST {API_URL}/v4.3.0/diagnosticreport/ \
      -H "Content-Type: application/json" \
      -d '{
            "resourceType": "DiagnosticReport",
            "status": "final",
            "code": {
              "coding": [{
                "code": "MRI-BRAIN",
                "display": "Brain MRI"
              }]
            },
            "subject": {"reference": "Patient/1"},
            "encounter": {"reference": "Encounter/2"},
            "effectiveDateTime": "2024-01-19T10:00:00Z",
            "issued": "2024-01-19T15:30:00Z",
            "conclusion": "No acute intracranial abnormality. Normal brain structure.",
            "performer": [
              {"reference": "Organization/department-2"}
            ]
      }'
    ```

=== "Python"
    ```python
    report = {
            "resourceType": "DiagnosticReport",
            "status": "final",
            "code": {
              "coding": [{
                "code": "MRI-BRAIN",
                "display": "Brain MRI"
              }]
            },
            "subject": {"reference": "Patient/1"},
            "encounter": {"reference": "Encounter/2"},
            "effectiveDateTime": "2024-01-19T10:00:00Z",
            "issued": "2024-01-19T15:30:00Z",
            "conclusion": "No acute intracranial abnormality. Normal brain structure.",
            "performer": [
              {"reference": "Organization/department-2"}
            ]
    }
    
    response = requests.post("{API_URL}/v4.3.0/diagnosticreport/", json=report)
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Diagnostic" thesaurus

<div class="quick-links">
  <a href="../codesystem/">📚 CodeSystem</a>
  <a href="../../guides/">📖 Practical Guides</a>
</div>
