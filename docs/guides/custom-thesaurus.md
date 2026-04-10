---
title: Query Medical Vocabularies
---

# Query Medical Vocabularies

This guide explains how to explore medical thesauruses (CodeSystem) and their concepts.

## What is a Thesaurus?

A **thesaurus** (or CodeSystem in FHIR) is a controlled vocabulary that contains medical **concepts**.

**Examples of thesauri:**
- `Biology`: codes for lab tests (Hemoglobin, Blood Glucose, etc.)
- `Procedure`: CCAM codes for medical procedures
- `Diagnosis`: ICD-10 codes for diagnoses
- `Phenotypes`: NLP concepts extracted from texts

## List All Thesauruses

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/codesystem/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    HEADERS = {"Authorization": "Api-Key {API_KEY}"}
    
    response = requests.get(
        f"{BASE_URL}/v4.3.0/codesystem/",
        params={"_count": 20},
        headers=HEADERS
    )
    bundle = response.json()
    
    print(f"Total thesauruses: {bundle['total']}")
    for entry in bundle.get("entry", []):
        cs = entry["resource"]
        print(f"  {cs['name']}: {cs.get('title', 'N/A')} (status: {cs['status']})")
    ```

## Retrieve a Complete Thesaurus

=== "Python"
    ```python
    # Retrieve the thesaurus with all its concepts
    thesaurus = requests.get(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/", headers=HEADERS).json()
    
    print(f"\n📚 Thesaurus: {thesaurus['name']}")
    print(f"   Title: {thesaurus.get('title', 'N/A')}")
    print(f"   Status: {thesaurus['status']}")
    print(f"   Number of concepts: {len(thesaurus.get('concept', []))}")
    
    # Display all concepts
    for concept in thesaurus.get('concept', []):
        print(f"   - {concept['code']}: {concept['display']}")
    ```

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/codesystem/ALLERGIES/
    ```

## Retrieve a Single Concept

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/PENICILLIN/
    ```

=== "Python"
    ```python
    concept = requests.get(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/concept/PENICILLIN/", headers=HEADERS).json()
    print(f"Code: {concept['code']}")
    print(f"Display: {concept['display']}")
    ```

## Filter Observations by Thesaurus

Once you know which thesaurus codes observations use, you can filter on the client side:

```python
import requests

BASE_URL = "{API_URL}"
HEADERS = {"Authorization": "Api-Key {API_KEY}"}

# List observations with pagination
response = requests.get(f"{BASE_URL}/v4.3.0/observation/?_count=50", headers=HEADERS)
bundle = response.json()

# Filter observations by COVID thesaurus
covid_observations = []
for entry in bundle.get('entry', []):
    obs = entry['resource']
    
    # Check if the code belongs to the COVID thesaurus
    system = obs['code']['coding'][0].get('system', '')
    if 'COVID_SYMPTOMES' in system:
        covid_observations.append(obs)

print(f"✅ {len(covid_observations)} COVID observations found")
```

## Complete Exploration Script

```python
import requests

BASE_URL = "{API_URL}"
HEADERS = {"Authorization": "Api-Key {API_KEY}"}

# 1. List all thesauruses
print("📚 Available thesauruses:")
bundle = requests.get(f"{BASE_URL}/v4.3.0/codesystem/?_count=20", headers=HEADERS).json()
for entry in bundle.get("entry", []):
    cs = entry["resource"]
    print(f"  - {cs['name']}: {cs.get('title', 'N/A')}")

# 2. Retrieve a specific thesaurus
thesaurus_code = "COVID_SYMPTOMES"
thesaurus = requests.get(f"{BASE_URL}/v4.3.0/codesystem/{thesaurus_code}/", headers=HEADERS).json()

print(f"\n📋 Concept list for '{thesaurus['name']}':")
for concept in thesaurus.get('concept', []):
    print(f"   {concept['code']:15} → {concept['display']}")
```

## Key Points

!!! tip "Naming Conventions"
    Thesaurus codes use **UPPER_SNAKE_CASE** (e.g., `CIM10_FR`, `COVID_SYMPTOMES`)

!!! info "Concept Codes"
    Concept codes are unique within a thesaurus and used to code clinical observations

## Next Steps

- [Semantic Enrichment](semantic-enrichment.md)
- [Query a Patient Record](patient-record.md)
