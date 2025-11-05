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
    
    BASE_URL = "{API_URL}"
    
    # Create the thesaurus
    thesaurus = requests.post(f"{BASE_URL}/v4.3.0/codesystem/", json={
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:PHENOTYPES",
        "identifier": [
          {"use": "official", "value": "1"},
          {"use": "usual", "value": "PHENOTYPES"}
        ],
        "name": "Phenotypes",
        "title": "Phenotypes Thesaurus",
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
        f"{BASE_URL}/v4.3.0/codesystem/PHENOTYPES/concept/",
        json={"concept": concepts}
    )
    
    print("✅ Phenotype thesaurus created with 5 concepts")
    ```

## Step 2: Create the Patient and Document

=== "Python"
    ```python
    import base64
    
    # Patient
    patient = requests.post(f"{BASE_URL}/v4.3.0/patient/", json={
        "resourceType": "Patient",
        "identifier": [{"value": "IPP555"}],
        "name": [{"family": "Smith", "given": ["Peter"]}],
        "gender": "male",
        "birthDate": "1960-05-15"
    }).json()
    patient_id = patient["id"]
    
    # Stay
    stay = requests.post(f"{BASE_URL}/v4.3.0/encounter/", json={
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
    
    document = requests.post(f"{BASE_URL}/v4.3.0/documentreference/", json={
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

Now let's create the phenotypes found in the text using the new component-based structure:

=== "Python"
    ```python
    # Define found phenotypes with their components
    found_phenotypes = [
        {
            "code": "HYPERTENSION",
            "display": "Arterial hypertension",
            "phenotype": "arterial hypertension",
            "semantic_type": "DISEASE_OR_SYNDROME",
            "tfidf_code_document": 0.85,
            "count_concept": 1,
            "count_concept_str_found": 1
        },
        {
            "code": "DIABETE",
            "display": "Diabetes",
            "phenotype": "type 2 diabetes",
            "semantic_type": "DISEASE_OR_SYNDROME",
            "tfidf_code_document": 0.78,
            "count_concept": 2,
            "count_concept_str_found": 2
        },
        {
            "code": "DOULEUR_THORACIQUE",
            "display": "Chest pain",
            "phenotype": "chest pain",
            "semantic_type": "SIGN_OR_SYMPTOM",
            "tfidf_code_document": 0.92,
            "count_concept": 1,
            "count_concept_str_found": 1
        },
        {
            "code": "DYSPNEE",
            "display": "Dyspnea",
            "phenotype": "dyspnea",
            "semantic_type": "SIGN_OR_SYMPTOM",
            "tfidf_code_document": 0.88,
            "count_concept": 1,
            "count_concept_str_found": 1
        }
    ]
    
    # Create phenotype observations
    for pheno in found_phenotypes:
        observation = requests.post(f"{BASE_URL}/v4.3.0/observation/phenotype/", json={
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
            "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
            "effectiveDateTime": "2024-11-05T10:00:00Z",
            "valueString": pheno["phenotype"],
            "component": [
                {
                    "code": {"text": "phenotype"},
                    "valueString": pheno["phenotype"]
                },
                {
                    "code": {"text": "semantic_type"},
                    "valueString": pheno["semantic_type"]
                },
                {
                    "code": {"text": "tfidf_code_document"},
                    "valueDecimal": pheno["tfidf_code_document"]
                },
                {
                    "code": {"text": "count_concept"},
                    "valueInteger": pheno["count_concept"]
                },
                {
                    "code": {"text": "count_concept_str_found"},
                    "valueInteger": pheno["count_concept_str_found"]
                }
            ]
        }).json()
        
        print(f"✅ Phenotype created: {pheno['display']}")
    ```

## Step 4: Retrieve All Patient Phenotypes

=== "Python"
    ```python
    # Note: The API does not support LIST, so you will need to retrieve
    # phenotypes individually via their IDs
    # In a real case, you would store the IDs during creation
    
    # Example of retrieving a phenotype
    phenotype_id = 1  # ID obtained during creation
    pheno = requests.get(f"{BASE_URL}/v4.3.0/observation/phenotype/{phenotype_id}/").json()
    
    print(f"\n📋 Retrieved phenotype:")
    print(f"   Code: {pheno['code']['coding'][0]['code']}")
    print(f"   Display: {pheno['code']['coding'][0]['display']}")
    print(f"   Value: {pheno['valueString']}")
    
    # Retrieve components
    for component in pheno.get('component', []):
        comp_code = component['code'].get('text', component['code'].get('coding', [{}])[0].get('code', ''))
        print(f"   {comp_code}: {component.get('valueString', component.get('valueDecimal', component.get('valueInteger')))}")
    ```

## Managing Medical Contexts

With the component-based approach, medical contexts are captured in the phenotype value and components:

### Negation

When a concept is **negated** in the text:

> "**No known diabetes**"

```python
{
    "valueString": "no diabetes",
    "code": {"coding": [{"code": "DIABETE"}]},
    "component": [
        {"code": {"text": "phenotype"}, "valueString": "no diabetes"},
        {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"},
        # ... other components
    ]
}
```

### Hypothesis

When it's a **suspicion**:

> "**Suspected unstable angina**"

```python
{
    "valueString": "suspected unstable angina",
    "code": {"coding": [{"code": "ANGOR"}]},
    "component": [
        {"code": {"text": "phenotype"}, "valueString": "suspected unstable angina"},
        {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"},
        # ... other components
    ]
}
```

### Family History

When it's a family history:

> "**Family history** of coronary disease"

```python
{
    "valueString": "family history of coronary disease",
    "code": {"coding": [{"code": "MALADIE_CORONARIENNE"}]},
    "component": [
        {"code": {"text": "phenotype"}, "valueString": "family history of coronary disease"},
        {"code": {"text": "semantic_type"}, "valueString": "DISEASE_OR_SYNDROME"},
        # ... other components
    ]
}
```

## Complete Enrichment Script

```python
import requests
import base64

BASE_URL = "{API_URL}"

def create_phenotype(patient_id, document_id, code, display, phenotype_value,
                     semantic_type, tfidf, count, count_found):
    """Create a phenotype with component structure."""
    return requests.post(f"{BASE_URL}/v4.3.0/observation/phenotype/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": code, "display": display}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "derivedFrom": [{"reference": f"DocumentReference/{document_id}"}],
        "effectiveDateTime": "2024-11-05T10:00:00Z",
        "valueString": phenotype_value,
        "component": [
            {"code": {"text": "phenotype"}, "valueString": phenotype_value},
            {"code": {"text": "semantic_type"}, "valueString": semantic_type},
            {"code": {"text": "tfidf_code_document"}, "valueDecimal": tfidf},
            {"code": {"text": "count_concept"}, "valueInteger": count},
            {"code": {"text": "count_concept_str_found"}, "valueInteger": count_found}
        ]
    }).json()

# Example usage
pheno1 = create_phenotype(
    patient_id=123,
    document_id=456,
    code="HYPERTENSION",
    display="Arterial hypertension",
    phenotype_value="arterial hypertension",
    semantic_type="DISEASE_OR_SYNDROME",
    tfidf=0.85,
    count=1,
    count_found=1
)

print(f"✅ Phenotype created: ID {pheno1['id']}")
```

## Key Points

!!! tip "Component Structure"
    Use the component[] array for phenotype metadata (semantic_type, tfidf, counts) instead of extensions

!!! warning "Mandatory Fields"
    `derivedFrom` pointing to the DocumentReference is **REQUIRED**

!!! info "Value Field"
    Use `valueString` for the phenotype text value (e.g., "arterial hypertension")

## Next Steps

- [Create a Custom Thesaurus](custom-thesaurus.md)
- [Create a Patient Record](patient-record.md)
