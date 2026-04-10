---
title: Observation (patient-data)
---

# Observation - Patient Data

This sub-resource represents **patient-specific traits** (weight, height, allergies, etc.).

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/patient-data/{id}/</span>
</div>

## Difference from Standard Observation

| Aspect | Observation | Observation-patient-data |
|--------|-------------|--------------------------|  
| **Endpoint** | `/observation/` | `/observation/patient-data/` |
| **Model** | `Enrsem` (biology) | `PatientData` (patient traits) |
| **Usage** | Laboratory results | Patient characteristics |
| **Thesaurus** | "Biologie" | No filter |

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |

## List Patient Data

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/observation/patient-data/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/observation/patient-data/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} patient data items")
    for entry in bundle.get("entry", []):
        obs = entry["resource"]
        code = obs["code"]["coding"][0].get("display", obs["code"]["coding"][0]["code"])
        value = obs.get("valueQuantity", {})
        print(f"  {code}: {value.get('value', 'N/A')} {value.get('unit', '')}")
    ```

## Retrieve a Patient Data Item

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/observation/patient-data/1/
    ```

## Common Data Types

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

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Observation](observation.md) - Sister resource for biology

<div class="quick-links">
  <a href="../observation/">🔬 Observation (biology)</a>
  <a href="../observation-phenotype/">🧬 Observation-phenotype</a>
</div>
