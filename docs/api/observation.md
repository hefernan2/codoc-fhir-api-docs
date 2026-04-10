---
title: Observation
---

# Observation - Lab Results

The **Observation** resource represents biological and laboratory test results.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/{id}/</span>
</div>

## Thesaurus Filtering

This resource automatically filters on `thesaurus_code = "Biologie"` (code configurable via `THESAURUS_CODE_OBSERVATION`).

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | registered, preliminary, final, amended |
| `code` | CodeableConcept | ✅ Yes | Test type (from thesaurus) |
| `subject` | Reference | ✅ Yes | Related patient |
| `encounter` | Reference | No | Associated stay |
| `effectiveDateTime` | dateTime | ✅ Yes | Date/time of observation |
| `valueQuantity` | Quantity | No | Numeric value with unit |
| `valueString` | string | No | Text value |
| `valueCodeableConcept` | CodeableConcept | No | Coded value |

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `encounter` | integer | Filter by stay ID | `?encounter=789` |
| `date` | date | Observation date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Observations

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/observation/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/observation/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} observations")
    for entry in bundle.get("entry", []):
        obs = entry["resource"]
        code = obs["code"]["coding"][0].get("display", obs["code"]["coding"][0]["code"])
        value = obs.get("valueQuantity", {})
        print(f"  {code}: {value.get('value', 'N/A')} {value.get('unit', '')}")
    ```

## Retrieve an Observation

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/observation/456/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/observation/456/", headers=headers)
    obs = response.json()
    
    print(f"Code: {obs['code']['coding'][0]['display']}")
    print(f"Status: {obs['status']}")
    print(f"Date: {obs['effectiveDateTime']}")
    if 'valueQuantity' in obs:
        print(f"Value: {obs['valueQuantity']['value']} {obs['valueQuantity']['unit']}")
    ```

## Status Codes

| Code | Description |
|------|-------------|
| `registered` | Registered, no result yet |
| `preliminary` | Preliminary result |
| `final` | Validated result |
| `amended` | Modified result |
| `cancelled` | Cancelled |

## Value Types

### Numeric Value (valueQuantity)

```json
{
  "valueQuantity": {
    "value": 120,
    "unit": "mmHg",
    "system": "http://unitsofmeasure.org",
    "code": "mm[Hg]"
  }
}
```

### Text Value (valueString)

```json
{
  "valueString": "Positive"
}
```

### Coded Value (valueCodeableConcept)

```json
{
  "valueCodeableConcept": {
    "coding": [{
      "system": "http://snomed.info/sct",
      "code": "10828004",
      "display": "Positive"
    }]
  }
}
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Biologie" vocabulary

<div class="quick-links">
  <a href="../observation-patient-data/">📊 Observation-patient-data</a>
  <a href="../codesystem/">📚 CodeSystem</a>
</div>
