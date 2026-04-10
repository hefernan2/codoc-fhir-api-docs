---
title: Semantic Enrichment with Phenotypes
---

# Semantic Enrichment with Phenotypes

This guide explains how to query phenotypes extracted from clinical documents.

## Concept

**Phenotypes** are medical concepts (symptoms, diagnoses, treatments) automatically extracted from document text using NLP (natural language processing).

**Example:**
> "The patient has **arterial hypertension** and **chest pain**."

→ 2 phenotypes extracted: `HYPERTENSION`, `CHEST_PAIN`

## Step 1: List Phenotype Observations

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    HEADERS = {"Authorization": "Api-Key {API_KEY}"}
    
    # List all phenotypes with pagination
    response = requests.get(f"{BASE_URL}/v4.3.0/observation/phenotype/?_count=50", headers=HEADERS)
    bundle = response.json()
    
    print(f"Total phenotypes: {bundle['total']}")
    for entry in bundle.get('entry', []):
        pheno = entry['resource']
        print(f"\n📋 Phenotype ID: {pheno['id']}")
        print(f"   Code: {pheno['code']['coding'][0]['code']}")
        print(f"   Display: {pheno['code']['coding'][0]['display']}")
        print(f"   Value: {pheno['valueString']}")
        
        # Display components (semantic type, relevance score, etc.)
        for component in pheno.get('component', []):
            comp_code = component['code'].get('text', component['code'].get('coding', [{}])[0].get('code', ''))
            comp_value = component.get('valueString', component.get('valueDecimal', component.get('valueInteger')))
            print(f"   {comp_code}: {comp_value}")
    ```

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/observation/phenotype/?_count=50"
    ```

## Step 2: Retrieve a Specific Phenotype

=== "Python"
    ```python
    phenotype_id = 42
    pheno = requests.get(f"{BASE_URL}/v4.3.0/observation/phenotype/{phenotype_id}/", headers=HEADERS).json()
    
    print(f"Concept: {pheno['code']['coding'][0]['display']}")
    print(f"Text found: {pheno['valueString']}")
    print(f"Date: {pheno['effectiveDateTime']}")
    print(f"Patient: {pheno['subject']['reference']}")
    print(f"Source document: {pheno['derivedFrom'][0]['reference']}")
    ```

## Step 3: Retrieve the Source Document

Each phenotype is linked to a `DocumentReference` via `derivedFrom`:

=== "Python"
    ```python
    import base64
    
    # From the phenotype, get the source document
    doc_ref = pheno["derivedFrom"][0]["reference"]
    doc_id = doc_ref.split("/")[-1]
    
    doc = requests.get(f"{BASE_URL}/v4.3.0/documentreference/{doc_id}/", headers=HEADERS).json()
    
    # Decode the document content
    encoded = doc["content"][0]["attachment"]["data"]
    content = base64.b64decode(encoded).decode()
    
    print(f"\nSource document: {doc['content'][0]['attachment'].get('title', 'N/A')}")
    print(f"Date: {doc['date']}")
    print(f"Content preview: {content[:500]}...")
    ```

## Managing Medical Contexts

Phenotype context is captured in `valueString` and `component[]`:

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

## Key Points

!!! tip "Component Structure"
    Use the `component[]` array for phenotype metadata (semantic_type, tfidf, counts)

!!! warning "Mandatory Fields"
    `derivedFrom` pointing to the DocumentReference is **REQUIRED** — always present in valid phenotype records

!!! info "Value Field"
    `valueString` contains the exact text fragment found in the document

## Next Steps

- [Query Medical Vocabularies](custom-thesaurus.md)
- [Query a Patient Record](patient-record.md)
