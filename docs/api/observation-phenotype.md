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

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | final (always) |
| `code` | CodeableConcept | ✅ Yes | Extracted concept (from "Phenotypes" thesaurus) |
| `subject` | Reference | ✅ Yes | Related patient |
| `focus[]` | Reference[] | ✅ Yes | Source document (Codoc Text) |
| `derivedFrom[]` | Reference[] | ✅ Yes | Parent DocumentReference |
| `effectiveDateTime` | dateTime | ✅ Yes | Document date |
| `extension[lexical_variant]` | string | ✅ Yes | Exact form found in text |
| `extension[span_start]` | integer | ✅ Yes | Start position in text |
| `extension[span_end]` | integer | ✅ Yes | End position in text |
| `extension[span_type]` | string | ✅ Yes | Span type (phenotype, condition, etc.) |
| `extension[date_patient]` | date | No | Date relative to patient |
| `extension[age_patient]` | integer | No | Patient age during extraction |
| `extension[negation]` | boolean | No | Negated concept? |
| `extension[hypothesis]` | boolean | No | Hypothetical concept? |
| `extension[family]` | boolean | No | Family history? |

## Create a Phenotype

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/observation/phenotype/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Observation",
        "status": "final",
        "code": {
          "coding": [{
            "system": "http://codoc.com/fhir/codesystem/Phenotypes",
            "code": "HYPERTENSION",
            "display": "Hypertension"
          }]
        },
        "subject": {"reference": "Patient/123"},
        "focus": [{"reference": "Text/456"}],
        "derivedFrom": [{"reference": "DocumentReference/789"}],
        "effectiveDateTime": "2024-01-15T14:30:00Z",
        "extension": [
          {
            "url": "http://codoc.com/fhir/extension/lexical_variant",
            "valueString": "hypertension"
          },
          {
            "url": "http://codoc.com/fhir/extension/span_start",
            "valueInteger": 42
          },
          {
            "url": "http://codoc.com/fhir/extension/span_end",
            "valueInteger": 67
          },
          {
            "url": "http://codoc.com/fhir/extension/span_type",
            "valueString": "phenotype"
          },
          {
            "url": "http://codoc.com/fhir/extension/age_patient",
            "valueInteger": 65
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
                "system": "http://codoc.com/fhir/codesystem/Phenotypes",
                "code": "HYPERTENSION",
                "display": "Hypertension"
            }]
        },
        "subject": {"reference": "Patient/123"},
        "focus": [{"reference": "Text/456"}],
        "derivedFrom": [{"reference": "DocumentReference/789"}],
        "effectiveDateTime": "2024-01-15T14:30:00Z",
        "extension": [
            {"url": "http://codoc.com/fhir/extension/lexical_variant", "valueString": "hypertension"},
            {"url": "http://codoc.com/fhir/extension/span_start", "valueInteger": 42},
            {"url": "http://codoc.com/fhir/extension/span_end", "valueInteger": 67},
            {"url": "http://codoc.com/fhir/extension/span_type", "valueString": "phenotype"},
            {"url": "http://codoc.com/fhir/extension/age_patient", "valueInteger": 65}
        ]
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/observation/phenotype/", json=phenotype)
    ```

## Important Extensions

### Location in Text

```json
{
  "extension": [
    {"url": ".../lexical_variant", "valueString": "chest pain"},
    {"url": ".../span_start", "valueInteger": 123},
    {"url": ".../span_end", "valueInteger": 144}
  ]
}
```

### Medical Context

```json
{
  "extension": [
    {"url": ".../negation", "valueBoolean": true},
    {"url": ".../hypothesis", "valueBoolean": false},
    {"url": ".../family", "valueBoolean": false}
  ]
}
```

**Examples:**
- **Negation:** "No diabetes" → `negation: true`
- **Hypothesis:** "Suspected heart attack" → `hypothesis: true`
- **Family:** "Family history of cancer" → `family: true`

## Use Cases

### Complete Document Extraction

```python
# Document: "The patient has hypertension and chest pain."
document_id = 789
text_id = 456
patient_id = 123

phenotypes = [
    {
        "code": "HYPERTENSION",
        "lexical_variant": "hypertension",
        "span_start": 19,
        "span_end": 31
    },
    {
        "code": "CHEST_PAIN",
        "lexical_variant": "chest pain",
        "span_start": 36,
        "span_end": 46
    }
]

for p in phenotypes:
    requests.post("/v4.3.0/observation/phenotype/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": p["code"]}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "focus": [{"reference": f"Text/{text_id}"}],
        "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
        "effectiveDateTime": "2024-01-15T14:30:00Z",
        "extension": [
            {"url": ".../lexical_variant", "valueString": p["lexical_variant"]},
            {"url": ".../span_start", "valueInteger": p["span_start"]},
            {"url": ".../span_end", "valueInteger": p["span_end"]},
            {"url": ".../span_type", "valueString": "phenotype"}
        ]
    })
```

### Negated Phenotype

```json
{
  "code": {"coding": [{"code": "DIABETES", "display": "Diabetes"}]},
  "extension": [
    {"url": ".../lexical_variant", "valueString": "no diabetes"},
    {"url": ".../negation", "valueBoolean": true}
  ]
}
```

## Automatic Age Calculation

The `age_patient` extension is calculated automatically:

```python
age_patient = (document_date - patient_birth_date).years
```

If the patient is 65 years old when the document is created, `age_patient = 65`.

## Related Resources

- [Patient](patient.md) - Via `subject`
- [DocumentReference](documentreference.md) - Via `derivedFrom`
- [CodeSystem](codesystem.md) - "Phenotypes" thesaurus

<div class="quick-links">
  <a href="../documentreference/">📄 DocumentReference</a>
  <a href="../codesystem/">📚 CodeSystem</a>
  <a href="../../guides/semantic-enrichment/">📖 Guide: Semantic Enrichment</a>
</div>
