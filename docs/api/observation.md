---
title: Observation
---

# Observation - Lab Results

The **Observation** resource represents biological and laboratory test results.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/observation/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/observation/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
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

## Create an Observation

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/observation/ \
      -H "Content-Type: application/json" \
      -d '{
            "resourceType": "Observation",
            "status": "final",
            "code": {
              "coding": [{"code": "GLU"}]
            },
            "subject": {"reference": "Patient/1"},
            "effectiveDateTime": "2024-01-21T07:00:00Z",
            "valueQuantity": {
              "value": 95,
              "unit": "mg/dL"
            }
          }'
    ```

=== "Python"
    ```python
    observation = {
        "resourceType": "Observation",
        "status": "final",
        "code": {
          "coding": [{"code": "GLU"}]
        },
        "subject": {"reference": "Patient/1"},
        "effectiveDateTime": "2024-01-21T07:00:00Z",
        "valueQuantity": {
          "value": 95,
          "unit": "mg/dL"
        }
    }
    
    response = requests.post("{API_URL}/v4.3.0/observation/", json=observation)
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

## Use Cases

### Complete Blood Test

```python
# Hemoglobin
obs1 = create_observation("HEMOGLOBIN", 14.5, "g/dL")

# Leukocytes
obs2 = create_observation("LEUKOCYTES", 7800, "/mm3")

# Blood glucose
obs3 = create_observation("GLUCOSE", 0.95, "g/L")

def create_observation(code, value, unit):
    return requests.post("/v4.3.0/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": code}]},
        "subject": {"reference": "Patient/123"},
        "effectiveDateTime": "2024-01-15T08:30:00Z",
        "valueQuantity": {"value": value, "unit": unit}
    }).json()
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Biologie" vocabulary

<div class="quick-links">
  <a href="../observation-patient-data/">📊 Observation-patient-data</a>
  <a href="../codesystem/">📚 CodeSystem</a>
</div>
