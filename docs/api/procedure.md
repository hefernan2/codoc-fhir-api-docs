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

| FHIR Field | Type | Required | Codoc Mapping | Source |
|------------|------|----------|---------------|--------|
| `id` | string | ✅ Yes | Data.pk | Auto-generated |
| `identifier[]` | Identifier[] | ✅ Yes | Data.pk (official), Data.id_source (usual) | Auto-generated |
| `status` | code | ✅ Yes | Fixed to "unknown" | Hardcoded |
| `code` | CodeableConcept | ✅ Yes | ThesaurusData (concept_code + concept_str) | Required in request |
| `subject` | Reference | ✅ Yes | Patient/{id} | Required in request |
| `encounter` | Reference | ❌ No | Encounter/{stay.id} | Optional in request |
| `performer[]` | ProcedurePerformer[] | ❌ No | Organization/{type}-{id} | Optional in request |
| `performer[].actor` | Reference | ❌ No | Department or Unit | Via performer |
| `performer[].function` | CodeableConcept | ❌ No | "department" or "unit" | Auto-determined |
| `performedDateTime` | dateTime | ✅ Yes | Data.start_date | Required in request |

## Create a Medical Act

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/procedure/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Procedure",
        "status": "completed",
        "code": {
          "coding": [{
            "code": "COLO001",
            "display": "Colonoscopy"
          }]
        },
        "subject": {"reference": "Patient/1"},
        "encounter": {"reference": "Encounter/1"},
        "performedDateTime": "2024-01-15T14:00:00Z",
        "performer": [
          {
            "actor": {"reference": "Organization/department-1"}
          }
        ]
      }'
    ```

=== "Python"
    ```python
    procedure = {
        "resourceType": "Procedure",
        "status": "completed",
        "code": {
          "coding": [{
            "code": "COLO001",
            "display": "Colonoscopy"
          }]
        },
        "subject": {"reference": "Patient/1"},
        "encounter": {"reference": "Encounter/1"},
        "performedDateTime": "2024-01-15T14:00:00Z",
        "performer": [
          {
            "actor": {"reference": "Organization/department-1"}
          }
        ]
    }
    
    response = requests.post("{API_URL}/v4.3.0/procedure/", json=procedure)
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Acte" thesaurus (CCAM)

<div class="quick-links">
  <a href="../medicationrequest/">💊 MedicationRequest</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
