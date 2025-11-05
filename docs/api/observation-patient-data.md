---
title: Observation (patient-data)
---

# Observation - Patient Data

This sub-resource represents **patient-specific traits** (weight, height, allergies, etc.).

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/{id}/</span>
</div>

## Difference from Standard Observation

| Aspect | Observation | Observation-patient-data |
|--------|-------------|--------------------------|  
| **Endpoint** | `/observation/` | `/observation/patient-data/` |
| **Model** | `Enrsem` (biology) | `PatientData` (patient traits) |
| **Usage** | Laboratory results | Patient characteristics |
| **Thesaurus** | "Biologie" | No filter |## Create a Patient Data Item

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/observation/patient-data/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Observation",
        "status": "final",
        "code": {
          "coding": [{
            "system": "http://loinc.org",
            "code": "29463-7",
            "display": "Body Weight"
          }]
        },
        "subject": {"reference": "Patient/123"},
        "effectiveDateTime": "2024-01-15T10:00:00Z",
        "valueQuantity": {
          "value": 75.5,
          "unit": "kg",
          "code": "kg"
        }
      }'
    ```

=== "Python"
    ```python
    weight = {
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": "29463-7", "display": "Body Weight"}]},
        "subject": {"reference": "Patient/123"},
        "effectiveDateTime": "2024-01-15T10:00:00Z",
        "valueQuantity": {"value": 75.5, "unit": "kg"}
    }
    
    response = requests.post(
        "http://localhost:8000/v4.3.0/observation/patient-data/",
        json=weight
    )
    ```

## Common Use Cases

### Patient Weight

```json
{
  "code": {"coding": [{"code": "29463-7", "display": "Body Weight"}]},
  "valueQuantity": {"value": 75.5, "unit": "kg"}
}
```

### Patient Height

```json
{
  "code": {"coding": [{"code": "8302-2", "display": "Body Height"}]},
  "valueQuantity": {"value": 178, "unit": "cm"}
}
```

### Blood Group

```json
{
  "code": {"coding": [{"code": "883-9", "display": "ABO group"}]},
  "valueCodeableConcept": {
    "coding": [{"code": "A+", "display": "A positive"}]
  }
}
```

### Allergy

```json
{
  "code": {"coding": [{"code": "ALLERGIE", "display": "Allergy"}]},
  "valueString": "Penicillin"
}
```

## Complete Patient Profile

```python
patient_id = "123"

# Weight
requests.post("/v4.3.0/observation/patient-data/", json={
    "resourceType": "Observation",
    "status": "final",
    "code": {"coding": [{"code": "29463-7"}]},
    "subject": {"reference": f"Patient/{patient_id}"},
    "effectiveDateTime": "2024-01-15T10:00:00Z",
    "valueQuantity": {"value": 75.5, "unit": "kg"}
})

# Height
requests.post("/v4.3.0/observation/patient-data/", json={
    "resourceType": "Observation",
    "status": "final",
    "code": {"coding": [{"code": "8302-2"}]},
    "subject": {"reference": f"Patient/{patient_id}"},
    "effectiveDateTime": "2024-01-15T10:00:00Z",
    "valueQuantity": {"value": 178, "unit": "cm"}
})

# Blood group
requests.post("/v4.3.0/observation/patient-data/", json={
    "resourceType": "Observation",
    "status": "final",
    "code": {"coding": [{"code": "883-9"}]},
    "subject": {"reference": f"Patient/{patient_id}"},
    "effectiveDateTime": "2024-01-15T10:00:00Z",
    "valueCodeableConcept": {"coding": [{"code": "A+"}]}
})
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Observation](observation.md) - Sister resource for biology

<div class="quick-links">
  <a href="../observation/">🔬 Observation (biology)</a>
  <a href="../observation-phenotype/">🧬 Observation-phenotype</a>
</div>
