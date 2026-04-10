---
title: Procedure
---

# Procedure - Medical Acts

The **Procedure** resource represents medical acts (surgery, interventions, technical examinations).

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/procedure/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `encounter` | integer | Filter by stay ID | `?encounter=789` |
| `date` | date | Procedure date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Procedures

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/procedure/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/procedure/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} procedures")
    for entry in bundle.get("entry", []):
        proc = entry["resource"]
        code = proc["code"]["coding"][0].get("display", proc["code"]["coding"][0]["code"])
        print(f"  ID {proc['id']}: {code} - {proc['performedDateTime']}")
    ```

## Retrieve a Procedure

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/procedure/1/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/procedure/1/", headers=headers)
    proc = response.json()
    
    print(f"Code: {proc['code']['coding'][0]['display']}")
    print(f"Date: {proc['performedDateTime']}")
    print(f"Patient: {proc['subject']['reference']}")
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Acte" thesaurus (CCAM)

<div class="quick-links">
  <a href="../medicationrequest/">💊 MedicationRequest</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
