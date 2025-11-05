---
title: Semantic Enrichment with Phenotypes
---

# Semantic Enrichment with Phenotypes

This guide explains how to use phenotypes to semantically enrich your clinical documents.

## Concept

**Phenotypes** are medical concepts (symptoms, diagnoses, treatments) automatically extracted from document text using NLP (natural language processing).

**Example:**
> "The patient has **arterial hypertension** and **chest pain**."

→ 2 phenotypes extracted: `HYPERTENSION`, `CHEST_PAIN`

## Prerequisites

Before creating phenotypes, you must have:

1. A **phenotype thesaurus** (CodeSystem)
2. A **document** (DocumentReference) with its text
3. A **patient** and a **stay**

## Step 1: Create the Phenotype Thesaurus

=== "Python"
    ```python
    import requests
    
    BASE_URL = "http://localhost:8000/v4.3.0"
    
    # Create the thesaurus
    thesaurus = requests.post(f"{BASE_URL}/codesystem/", json={
        "resourceType": "CodeSystem",
        "identifier": [{"value": "PHENOTYPES"}],
        "name": "Phenotypes",
        "status": "active",
        "content": "complete"
    }).json()
    
    # Add concepts
    concepts = [
        {"code": "HYPERTENSION", "display": "Arterial hypertension"},
        {"code": "DIABETE", "display": "Diabetes"},
        {"code": "DOULEUR_THORACIQUE", "display": "Chest pain"},
        {"code": "DYSPNEE", "display": "Dyspnea"},
        {"code": "OBESITE", "display": "Obesity"}
    ]
    
    requests.post(
        f"{BASE_URL}/codesystem/PHENOTYPES/concept/",
        json={"concept": concepts}
    )
    
    print("✅ Phenotype thesaurus created with 5 concepts")
    ```

## Step 2: Create the Patient and Document

=== "Python"
    ```python
    import base64
    
    # Patient
    patient = requests.post(f"{BASE_URL}/patient/", json={
        "resourceType": "Patient",
        "identifier": [{"value": "IPP555"}],
        "name": [{"family": "Smith", "given": ["Peter"]}],
        "gender": "male",
        "birthDate": "1960-05-15"
    }).json()
    patient_id = patient["id"]
    
    # Stay
    stay = requests.post(f"{BASE_URL}/encounter/", json={
        "resourceType": "Encounter",
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "period": {"start": "2024-11-05T08:00:00Z"}
    }).json()
    stay_id = stay["id"]
    
    # Document with clinical text
    clinical_text = """
    <h1>Cardiology Consultation</h1>
    <h2>Medical History</h2>
    <p>Patient has arterial hypertension for 10 years,
    as well as type 2 diabetes diagnosed 5 years ago.
    Family history of coronary disease (father died of heart attack).</p>
    
    <h2>Reason for Consultation</h2>
    <p>Chest pain on exertion for 3 weeks,
    accompanied by dyspnea.</p>
    
    <h2>Clinical Examination</h2>
    <p>Overweight patient (BMI 29). BP 150/95 mmHg.
    Normal cardiac auscultation. No lower limb edema.</p>
    
    <h2>Conclusion</h2>
    <p>Suspected stable angina. ECG and stress echo to be scheduled.</p>
    """
    
    encoded_content = base64.b64encode(clinical_text.encode()).decode()
    
    document = requests.post(f"{BASE_URL}/documentreference/", json={
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": f"Patient/{patient_id}"},
        "context": {"encounter": [{"reference": f"Encounter/{stay_id}"}]},
        "date": "2024-11-05T10:00:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": encoded_content,
                "title": "Cardiology Consultation"
            }
        }]
    }).json()
    document_id = document["id"]
    
    print(f"✅ Patient, stay, and document created")
    print(f"   Document ID: {document_id}")
    ```

!!! info "Codoc Text"
    When creating the DocumentReference, a Codoc `Text` object is automatically created with the decoded content.

## Step 3: Extract Phenotypes

Now let's create the phenotypes found in the text:

=== "Python"
    ```python
    # Retrieve the Text ID (required for focus)
    # Note: In a real scenario, you would get this ID from your database
    # For this example, let's assume text_id = 1
    text_id = 1
    
    # Define found phenotypes with their positions in the text
    found_phenotypes = [
        {
            "code": "HYPERTENSION",
            "display": "Arterial hypertension",
            "lexical_variant": "arterial hypertension",
            "span_start": 145,
            "span_end": 169,
            "negation": False,
            "hypothesis": False,
            "family": False
        },
        {
            "code": "DIABETE",
            "display": "Diabetes",
            "lexical_variant": "type 2 diabetes",
            "span_start": 198,
            "span_end": 216,
            "negation": False,
            "hypothesis": False,
            "family": False
        },
        {
            "code": "DOULEUR_THORACIQUE",
            "display": "Chest pain",
            "lexical_variant": "Chest pain",
            "span_start": 385,
            "span_end": 405,
            "negation": False,
            "hypothesis": False,
            "family": False
        },
        {
            "code": "DYSPNEE",
            "display": "Dyspnea",
            "lexical_variant": "dyspnea",
            "span_start": 445,
            "span_end": 452,
            "negation": False,
            "hypothesis": False,
            "family": False
        }
    ]
    
    # Create phenotype observations
    for pheno in found_phenotypes:
        observation = requests.post(f"{BASE_URL}/observation/phenotype/", json={
            "resourceType": "Observation",
            "status": "final",
            "code": {
                "coding": [{
                    "system": "http://codoc.com/fhir/codesystem/PHENOTYPES",
                    "code": pheno["code"],
                    "display": pheno["display"]
                }]
            },
            "subject": {"reference": f"Patient/{patient_id}"},
            "focus": [{"reference": f"Text/{text_id}"}],
            "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
            "effectiveDateTime": "2024-11-05T10:00:00Z",
            "extension": [
                {
                    "url": "http://codoc.com/fhir/extension/lexical_variant",
                    "valueString": pheno["lexical_variant"]
                },
                {
                    "url": "http://codoc.com/fhir/extension/span_start",
                    "valueInteger": pheno["span_start"]
                },
                {
                    "url": "http://codoc.com/fhir/extension/span_end",
                    "valueInteger": pheno["span_end"]
                },
                {
                    "url": "http://codoc.com/fhir/extension/span_type",
                    "valueString": "phenotype"
                },
                {
                    "url": "http://codoc.com/fhir/extension/negation",
                    "valueBoolean": pheno["negation"]
                },
                {
                    "url": "http://codoc.com/fhir/extension/hypothesis",
                    "valueBoolean": pheno["hypothesis"]
                },
                {
                    "url": "http://codoc.com/fhir/extension/family",
                    "valueBoolean": pheno["family"]
                }
            ]
        }).json()
        
        print(f"✅ Phenotype created: {pheno['display']} (span {pheno['span_start']}-{pheno['span_end']})")
    ```

## Step 4: Retrieve All Patient Phenotypes

=== "Python"
    ```python
    # Note: The API does not support LIST, so you will need to retrieve
    # phenotypes individually via their IDs
    # In a real case, you would store the IDs during creation
    
    # Example of retrieving a phenotype
    phenotype_id = 1  # ID obtained during creation
    pheno = requests.get(f"{BASE_URL}/observation/phenotype/{phenotype_id}/").json()
    
    print(f"\n📋 Retrieved phenotype:")
    print(f"   Code: {pheno['code']['coding'][0]['code']}")
    print(f"   Display: {pheno['code']['coding'][0]['display']}")
    
    # Retrieve lexical_variant from extensions
    for ext in pheno.get('extension', []):
        if 'lexical_variant' in ext['url']:
            print(f"   Exact form: '{ext['valueString']}'")
    ```

## Managing Medical Contexts

### Negation

When a concept is **negated** in the text:

> "**No known diabetes**"

```python
{
    "code": {"coding": [{"code": "DIABETE"}]},
    "extension": [
        {"url": ".../negation", "valueBoolean": True}
    ]
}
```

### Hypothesis

When it's a **suspicion**:

> "**Suspected unstable angina**"

```python
{
    "code": {"coding": [{"code": "ANGOR"}]},
    "extension": [
        {"url": ".../hypothesis", "valueBoolean": True}
    ]
}
```

### Family History

When it's a family history:

> "**Family history** of coronary disease"

```python
{
    "code": {"coding": [{"code": "MALADIE_CORONARIENNE"}]},
    "extension": [
        {"url": ".../family", "valueBoolean": True}
    ]
}
```

## Automatic Age Calculation

The `age_patient` extension is calculated automatically:

```python
# If patient born on 1960-05-15 and document dated 2024-11-05
# age_patient = 64 years
```

This age is useful for epidemiological analyses.

## Complete Enrichment Script

```python
import requests
import base64

BASE_URL = "http://localhost:8000/v4.3.0"

def create_phenotype(patient_id, document_id, text_id, code, display, 
                     lexical_variant, span_start, span_end,
                     negation=False, hypothesis=False, family=False):
    """Create a phenotype with all its attributes."""
    return requests.post(f"{BASE_URL}/observation/phenotype/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": code, "display": display}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "focus": [{"reference": f"Text/{text_id}"}],
        "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
        "effectiveDateTime": "2024-11-05T10:00:00Z",
        "extension": [
            {"url": "http://codoc.com/fhir/extension/lexical_variant", "valueString": lexical_variant},
            {"url": "http://codoc.com/fhir/extension/span_start", "valueInteger": span_start},
            {"url": "http://codoc.com/fhir/extension/span_end", "valueInteger": span_end},
            {"url": "http://codoc.com/fhir/extension/span_type", "valueString": "phenotype"},
            {"url": "http://codoc.com/fhir/extension/negation", "valueBoolean": negation},
            {"url": "http://codoc.com/fhir/extension/hypothesis", "valueBoolean": hypothesis},
            {"url": "http://codoc.com/fhir/extension/family", "valueBoolean": family}
        ]
    }).json()

# Example usage
pheno1 = create_phenotype(
    patient_id=123,
    document_id=456,
    text_id=789,
    code="HYPERTENSION",
    display="Arterial hypertension",
    lexical_variant="arterial hypertension",
    span_start=145,
    span_end=169,
    negation=False,
    hypothesis=False,
    family=False
)

print(f"✅ Phenotype created: ID {pheno1['id']}")
```

## Key Points

!!! tip "Mandatory Extensions"
    The extensions `lexical_variant`, `span_start`, `span_end`, and `span_type` are **mandatory**

!!! warning "Text Reference"
    The `focus` field must point to the Codoc `Text` ID, not the `DocumentReference`

!!! info "Automatic Calculation"
    The patient age (`age_patient`) is calculated automatically by the API

## Next Steps

- [Create a Custom Thesaurus](custom-thesaurus.md)
- [Create a Patient Record](patient-record.md)
