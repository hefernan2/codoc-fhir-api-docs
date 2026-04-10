---
title: Observation (phenotype)
---

# Observation - NLP Phenotypes

This sub-resource represents **phenotypes automatically extracted** from clinical documents by NLP (natural language processing).

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/observation/phenotype/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

No filter parameters are available. Use `_count` and `page` for pagination.

!!! info "Public endpoint"
    This endpoint does not require authentication.

## List Phenotypes

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/observation/phenotype/?_count=50"
    ```

=== "Python"
    ```python
    import requests
    
    # List all phenotypes with pagination
    response = requests.get(f"{API_URL}/v4.3.0/observation/phenotype/?_count=50")
    bundle = response.json()
    
    print(f"Total phenotypes: {bundle['total']}")
    for entry in bundle.get('entry', []):
        pheno = entry['resource']
        print(f"\n📋 Phenotype ID: {pheno['id']}")
        print(f"   Code: {pheno['code']['coding'][0]['code']}")
        print(f"   Display: {pheno['code']['coding'][0]['display']}")
        print(f"   Value: {pheno['valueString']}")
        
        # Retrieve components
        for component in pheno.get('component', []):
            comp_code = component['code'].get('text', component['code'].get('coding', [{}])[0].get('code', ''))
            print(f"   {comp_code}: {component.get('valueString', component.get('valueDecimal', component.get('valueInteger')))}")
    ```

## Retrieve a Phenotype

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/observation/phenotype/1/
    ```

## Medical Context Fields

Phenotype observations capture medical context through their `component[]` array and `valueString`:

### Negation

> "**No known diabetes**"

```json
{
  "valueString": "no diabetes",
  "component": [
    {"code": {"text": "phenotype"}, "valueString": "no diabetes"},
    {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"}
  ]
}
```

### Hypothesis

> "**Suspected unstable angina**"

```json
{
  "valueString": "suspected unstable angina",
  "component": [
    {"code": {"text": "phenotype"}, "valueString": "suspected unstable angina"},
    {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"}
  ]
}
```

### Family History

> "**Family history** of coronary disease"

```json
{
  "valueString": "family history of coronary disease",
  "component": [
    {"code": {"text": "phenotype"}, "valueString": "family history of coronary disease"},
    {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"}
  ]
}
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
