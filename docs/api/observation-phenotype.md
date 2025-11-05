---
title: Observation (phenotype)
---

# Observation - NLP Phenotypes

This sub-resource represents **phenotypes automatically extracted** from clinical documents by NLP (natural language processing).

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/observation/phenotype/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/phenotype/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/observation/phenotype/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/observation/phenotype/{id}/</span>
</div>

## Concept

**Phenotypes** are medical concepts (symptoms, diagnoses, procedures) detected in the text of clinical documents.

**Example:**
> "The patient has **hypertension** and **chest pain**."

→ 2 phenotypes extracted: "hypertension", "chest pain"

## Field Structure

| FHIR Field | Type | Required | Source | Description |
|------------|------|----------|--------|-------------|
| `status` | code | ✅ Yes | Fixed | Always "final" |
| `code` | CodeableConcept | ✅ Yes | Required | Phenotype concept from "Phenotypes" thesaurus |
| `subject` | Reference | ✅ Yes | Required | Patient reference (e.g., Patient/24) |
| `derivedFrom[]` | Reference[] | ✅ Yes | Required | DocumentReference (REQUIRED, not optional) |
| `valueString` | string | ✅ Yes | Required | Exact text fragment found (concept_str_found) |
| `effectiveDateTime` | dateTime | ✅ Yes | Auto | Extracted from Document.document_date |
| `component[code="phenotype"]` | integer | ❌ No | Optional | Phenotype flag (0 or 1) |
| `component[code="semantic_type"]` | string | ❌ No | Optional | e.g., "Disease", "Symptom" |
| `component[code="tfidf_code_document"]` | Quantity | ❌ No | Optional | TF-IDF relevance score (float) |
| `component[code="count_concept"]` | integer | ❌ No | Optional | Concept occurrence count |
| `component[code="count_concept_str_found"]` | integer | ❌ No | Optional | String fragment occurrence count |

## Create a Phenotype

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/observation/phenotype/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Observation",
        "status": "final",
        "code": {
          "coding": [{
            "code": "I10",
            "display": "Essential hypertension"
          }]
        },
        "subject": {"reference": "Patient/1"},
        "derivedFrom": [{"reference": "DocumentReference/10"}],
        "valueString": "essential hypertension",
        "component": [
          {
            "code": {"coding": [{"code": "phenotype"}]},
            "valueInteger": 1
          },
          {
            "code": {"coding": [{"code": "semantic_type"}]},
            "valueString": "Disease"
          },
          {
            "code": {"coding": [{"code": "tfidf_code_document"}]},
            "valueQuantity": {"value": 0.85}
          },
          {
            "code": {"coding": [{"code": "count_concept"}]},
            "valueInteger": 2
          },
          {
            "code": {"coding": [{"code": "count_concept_str_found"}]},
            "valueInteger": 1
          }
        ]
        }'
    ```

=== "Python"
    ```python
    phenotype = {
        "resourceType": "Observation",
        "status": "final",
        "code": {
          "coding": [{
            "code": "I10",
            "display": "Essential hypertension"
          }]
        },
        "subject": {"reference": "Patient/1"},
        "derivedFrom": [{"reference": "DocumentReference/10"}],
    "valueString": "hypertension",
    "component": [
        {
            "code": {"coding": [{"code": "phenotype"}]},
            "valueInteger": 1
        },
        {
            "code": {"coding": [{"code": "semantic_type"}]},
            "valueString": "Disease"
        },
        {
            "code": {"coding": [{"code": "tfidf_code_document"}]},
            "valueQuantity": {"value": 0.85}
        },
        {
            "code": {"coding": [{"code": "count_concept"}]},
            "valueInteger": 2
        },
        {
            "code": {"coding": [{"code": "count_concept_str_found"}]},
            "valueInteger": 1
        }
    ]
}    response = requests.post("{API_URL}/v4.3.0/observation/phenotype/", json=phenotype)
    ```


**Examples:**
- **Negation:** "No diabetes" → `negation: true`
- **Hypothesis:** "Suspected heart attack" → `hypothesis: true`
- **Family:** "Family history of cancer" → `family: true`

## Use Cases

### Complete Document Extraction

```python
# Document: "The patient has hypertension and chest pain."
document_id = 10
patient_id = 24

phenotypes = [
    {
        "code": "I10",
        "display": "Essential hypertension",
        "valueString": "hypertension",
        "semantic_type": "Disease",
        "tfidf": 0.85,
        "count": 2,
        "count_str_found": 1
    },
    {
        "code": "R07.9",
        "display": "Chest pain, unspecified",
        "valueString": "chest pain",
        "semantic_type": "Symptom",
        "tfidf": 0.92,
        "count": 1,
        "count_str_found": 1
    }
]

for p in phenotypes:
    requests.post("{API_URL}/v4.3.0/observation/phenotype/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": p["code"], "display": p["display"]}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
        "valueString": p["valueString"],
        "component": [
            {
                "code": {"coding": [{"code": "phenotype"}]},
                "valueInteger": 1
            },
            {
                "code": {"coding": [{"code": "semantic_type"}]},
                "valueString": p["semantic_type"]
            },
            {
                "code": {"coding": [{"code": "tfidf_code_document"}]},
                "valueQuantity": {"value": p["tfidf"]}
            },
            {
                "code": {"coding": [{"code": "count_concept"}]},
                "valueInteger": p["count"]
            },
            {
                "code": {"coding": [{"code": "count_concept_str_found"}]},
                "valueInteger": p["count_str_found"]
            }
        ]
    })
```

### Phenotype with Semantic Type and Relevance

```python
# Create a phenotype with TF-IDF score indicating relevance
phenotype = {
    "resourceType": "Observation",
    "status": "final",
    "code": {
        "coding": [{
            "code": "J06.9",
            "display": "Acute upper respiratory infection, unspecified"
        }]
    },
    "subject": {"reference": "Patient/24"},
    "derivedFrom": [{"reference": "DocumentReference/15"}],
    "valueString": "upper respiratory infection",
    "component": [
        {
            "code": {"coding": [{"code": "semantic_type"}]},
            "valueString": "Disease"
        },
        {
            "code": {"coding": [{"code": "tfidf_code_document"}]},
            "valueQuantity": {"value": 0.78}
        },
        {
            "code": {"coding": [{"code": "count_concept"}]},
            "valueInteger": 1
        }
    ]
}

response = requests.post("{API_URL}/v4.3.0/observation/phenotype/", json=phenotype)
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [DocumentReference](documentreference.md) - Via `derivedFrom`
- [CodeSystem](codesystem.md) - "Phenotypes" thesaurus

<div class="quick-links">
  <a href="../documentreference/">📄 DocumentReference</a>
  <a href="../codesystem/">📚 CodeSystem</a>
  <a href="../../guides/semantic-enrichment/">📖 Guide: Semantic Enrichment</a>
</div>
