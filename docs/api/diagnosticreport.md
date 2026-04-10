---
title: DiagnosticReport
---

# DiagnosticReport - Diagnostic Reports

The **DiagnosticReport** resource represents diagnostic examination reports.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/diagnosticreport/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `encounter` | integer | Filter by stay ID | `?encounter=789` |
| `date` | date | Examination date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Diagnostic Reports

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/diagnosticreport/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/diagnosticreport/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} reports")
    for entry in bundle.get("entry", []):
        report = entry["resource"]
        code = report["code"]["coding"][0].get("display", report["code"]["coding"][0]["code"])
        print(f"  ID {report['id']}: {code} - {report['effectiveDateTime']}")
    ```

## Retrieve a Diagnostic Report

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/diagnosticreport/1/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/diagnosticreport/1/", headers=headers)
    report = response.json()
    
    print(f"Examination: {report['code']['coding'][0].get('display', 'N/A')}")
    print(f"Date: {report['effectiveDateTime']}")
    if 'conclusion' in report:
        print(f"Conclusion: {report['conclusion']}")
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Diagnostic" thesaurus

<div class="quick-links">
  <a href="../codesystem/">📚 CodeSystem</a>
  <a href="../../guides/">📖 Practical Guides</a>
</div>
