---
title: MedicationRequest
---

# MedicationRequest - Medication Prescriptions

The **MedicationRequest** resource represents medication prescriptions.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>

## Thesaurus Filtering

Filters on `thesaurus_code = "Prescription"` (configurable via `THESAURUS_CODE_MEDICATION`).

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | active, completed, stopped, cancelled |
| `intent` | code | ✅ Yes | proposal, plan, order, instance-order |
| `medicationCodeableConcept` | CodeableConcept | ✅ Yes | Prescribed medication (ATC) |
| `subject` | Reference | ✅ Yes | Related patient |
| `encounter` | Reference | No | Associated stay |
| `authoredOn` | dateTime | No | Prescription date |

## Create a Prescription

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/medicationrequest/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "MedicationRequest",
        "status": "active",
        "intent": "order",
        "medicationCodeableConcept": {
          "coding": [{
            "system": "http://codoc.com/fhir/codesystem/Prescription",
            "code": "C01DA02",
            "display": "Glyceryl trinitrate"
          }]
        },
        "subject": {"reference": "Patient/123"},
        "encounter": {"reference": "Encounter/789"},
        "authoredOn": "2024-01-15T10:00:00Z"
      }'
    ```

=== "Python"
    ```python
    prescription = {
        "resourceType": "MedicationRequest",
        "status": "active",
        "intent": "order",
        "medicationCodeableConcept": {
            "coding": [{
                "system": "http://codoc.com/fhir/codesystem/Prescription",
                "code": "C01DA02",
                "display": "Glyceryl trinitrate"
            }]
        },
        "subject": {"reference": "Patient/123"},
        "authoredOn": "2024-01-15T10:00:00Z"
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/medicationrequest/", json=prescription)
    ```

## Status Codes

| Code | Description |
|------|-------------|
| `active` | Active prescription |
| `on-hold` | On hold |
| `cancelled` | Cancelled |
| `completed` | Completed |
| `entered-in-error` | Data entry error |
| `stopped` | Stopped |

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Prescription" thesaurus (ATC)

<div class="quick-links">
  <a href="../procedure/">🏥 Procedure</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
