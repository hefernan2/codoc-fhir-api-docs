---
title: CodeSystem
---

# CodeSystem - Medical Vocabularies

The **CodeSystem** resource represents medical thesauruses (ICD10, ATC, CCAM, custom vocabularies).

## Endpoints

### Thesaurus

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/codesystem/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/</span>
</div>

### Concepts

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/{concept_code}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/{concept_code}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/{concept_code}/</span>
</div>

## Field Structure

### CodeSystem (Thesaurus)

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `url` | uri | ✅ Yes | Unique thesaurus URL |
| `identifier[]` | Identifier | ✅ Yes | Unique code (e.g., ICD10) |
| `version` | string | No | Thesaurus version |
| `name` | string | ✅ Yes | Technical name |
| `title` | string | No | Full title |
| `status` | code | ✅ Yes | draft, active, retired |
| `content` | code | ✅ Yes | complete, example, fragment |
| `count` | integer | Auto | Number of concepts |
| `concept[]` | BackboneElement[] | No | List of concepts |

### Concept

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | code | ✅ Yes | Unique code in thesaurus |
| `display` | string | ✅ Yes | Concept label |

## Create a Thesaurus

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/codesystem/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "CodeSystem",
        "url": "http://codoc.com/fhir/codesystem/Allergies",
        "identifier": [{
          "system": "http://codoc.com/fhir/codesystem",
          "value": "ALLERGIES"
        }],
        "name": "Allergies",
        "title": "Allergy Thesaurus",
        "status": "active",
        "content": "complete"
      }'
    ```

=== "Python"
    ```python
    thesaurus = {
        "resourceType": "CodeSystem",
        "url": "http://codoc.com/fhir/codesystem/Allergies",
        "identifier": [{"value": "ALLERGIES"}],
        "name": "Allergies",
        "status": "active",
        "content": "complete"
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/codesystem/", json=thesaurus)
    ```

## Add Concepts

=== "curl (single concept)"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/codesystem/ALLERGIES/concept/ \
      -H "Content-Type: application/json" \
      -d '{
        "concept": {
          "code": "PENICILLIN",
          "display": "Penicillin allergy"
        }
      }'
    ```

=== "curl (multiple concepts)"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/codesystem/ALLERGIES/concept/ \
      -H "Content-Type: application/json" \
      -d '{
        "concept": [
          {"code": "PENICILLIN", "display": "Penicillin allergy"},
          {"code": "PEANUT", "display": "Peanut allergy"},
          {"code": "LATEX", "display": "Latex allergy"}
        ]
      }'
    ```

=== "Python"
    ```python
    # Add multiple concepts at once
    concepts = [
        {"code": "PENICILLIN", "display": "Penicillin allergy"},
        {"code": "PEANUT", "display": "Peanut allergy"},
        {"code": "LATEX", "display": "Latex allergy"}
    ]
    
    response = requests.post(
        "http://localhost:8000/v4.3.0/codesystem/ALLERGIES/concept/",
        json={"concept": concepts}
    )
    ```

## Retrieve a Thesaurus with Concepts

=== "curl"
    ```bash
    curl http://localhost:8000/v4.3.0/codesystem/ALLERGIES/
    ```

**Response:**
```json
{
  "resourceType": "CodeSystem",
  "url": "http://codoc.com/fhir/codesystem/Allergies",
  "identifier": [{"value": "ALLERGIES"}],
  "name": "Allergies",
  "status": "active",
  "content": "complete",
  "count": 3,
  "concept": [
    {"code": "PENICILLIN", "display": "Penicillin allergy"},
    {"code": "PEANUT", "display": "Peanut allergy"},
    {"code": "LATEX", "display": "Latex allergy"}
  ]
}
```

## Update a Concept

=== "curl"
    ```bash
    curl -X PUT http://localhost:8000/v4.3.0/codesystem/ALLERGIES/concept/PENICILLIN/ \
      -H "Content-Type: application/json" \
      -d '{
        "concept": {
          "code": "PENICILLIN",
          "display": "Penicillin and derivatives allergy"
        }
      }'
    ```

## Delete a Concept

=== "curl"
    ```bash
    curl -X DELETE http://localhost:8000/v4.3.0/codesystem/ALLERGIES/concept/LATEX/
    ```

## Pre-configured Standard Thesauruses

| Code | Name | Usage |
|------|------|-------|
| `CIM10` | International Classification of Diseases | Diagnoses |
| `ATC13` | Anatomical Therapeutic Chemical | Medications |
| `CCAM` | Common Classification of Medical Acts | Acts |
| `Biologie` | Biological examinations | Observations |
| `Phenotypes` | NLP Phenotypes | Semantic enrichment |

## Use Cases

### Create a Custom Thesaurus

```python
# 1. Create the thesaurus
thesaurus = requests.post("/v4.3.0/codesystem/", json={
    "resourceType": "CodeSystem",
    "identifier": [{"value": "COVID_SYMPTOMS"}],
    "name": "COVID-19 Symptoms",
    "status": "active",
    "content": "complete"
}).json()

# 2. Add concepts
concepts = [
    {"code": "FEVER", "display": "Fever"},
    {"code": "COUGH", "display": "Dry cough"},
    {"code": "FATIGUE", "display": "Intense fatigue"},
    {"code": "ANOSMIA", "display": "Loss of smell"},
    {"code": "AGEUSIA", "display": "Loss of taste"}
]

requests.post(
    "/v4.3.0/codesystem/COVID_SYMPTOMS/concept/",
    json={"concept": concepts}
)
```

### Use in an Observation

```python
observation = {
    "resourceType": "Observation",
    "status": "final",
    "code": {
        "coding": [{
            "system": "http://codoc.com/fhir/codesystem/COVID_SYMPTOMS",
            "code": "FEVER",
            "display": "Fever"
        }]
    },
    "subject": {"reference": "Patient/123"},
    "effectiveDateTime": "2024-01-15T10:00:00Z"
}
```

## Related Resources

All thesauruses are used by:

- [Observation](observation.md) - "Biologie" thesaurus
- [Observation-phenotype](observation-phenotype.md) - "Phenotypes" thesaurus
- [Procedure](procedure.md) - "Acte" thesaurus
- [MedicationRequest](medicationrequest.md) - "Prescription" thesaurus
- [DiagnosticReport](diagnosticreport.md) - "Diagnostic" thesaurus

<div class="quick-links">
  <a href="../../guides/custom-thesaurus/">📖 Guide: Create a Custom Thesaurus</a>
  <a href="../../troubleshooting/">🔧 Troubleshooting</a>
</div>
