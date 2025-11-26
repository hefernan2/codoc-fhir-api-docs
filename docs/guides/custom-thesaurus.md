---
title: Create a Custom Thesaurus
---

# Create a Custom Thesaurus

This guide explains how to create and manage your own medical vocabularies (CodeSystem).

## What is a Thesaurus?

A **thesaurus** (or CodeSystem in FHIR) is a controlled vocabulary that contains medical **concepts**.

**Examples of thesauri:**
- `Biology`: codes for lab tests (Hemoglobin, Blood Glucose, etc.)
- `Procedure`: CCAM codes for medical procedures
- `Diagnosis`: ICD-10 codes for diagnoses
- `Phenotypes`: NLP concepts extracted from texts

## Create an Empty Thesaurus

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:ALLERGIES",
        "identifier": [
          {
            "use": "official",
            "value": "1"
          },
          {
            "use": "usual",
            "value": "ALLERGIES"
          }
        ],
        "name": "Allergies",
        "title": "Allergies Thesaurus",
        "status": "active",
        "content": "complete"
      }'
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    
    thesaurus = requests.post(f"{BASE_URL}/v4.3.0/codesystem/", json={
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:ALLERGIES",
        "identifier": [
          {
            "use": "official",
            "value": "1"
          },
          {
            "use": "usual",
            "value": "ALLERGIES"
          }
        ],
        "name": "Allergies",
        "title": "Allergies Thesaurus",
        "status": "active",
        "content": "complete"
    }).json()
    
    print(f"✅ Thesaurus created: {thesaurus['name']} (ID {thesaurus['id']})")
    ```

## Add a Single Concept

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/ \
      -H "Content-Type: application/json" \
      -d '{
        "code": "PENICILLINE",
        "display": "Penicillin allergy"
      }'
    ```

=== "Python"
    ```python
    concept = requests.post(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/concept/", json={
        "code": "PENICILLINE",
        "display": "Penicillin allergy"
    }).json()
    
    print(f"✅ Concept added: {concept['display']}")
    ```

## Add Multiple Concepts in Batch

=== "Python"
    ```python
    # List of concepts
    concepts = [
        {"code": "PENICILLINE", "display": "Penicillin allergy"},
        {"code": "IODE", "display": "Iodine allergy"},
        {"code": "LATEX", "display": "Latex allergy"},
        {"code": "ARACHIDE", "display": "Peanut allergy"},
        {"code": "GLUTEN", "display": "Gluten intolerance"}
    ]
    
    # Add all concepts at once
    response = requests.post(
        f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/concept/",
        json={"concept": concepts}
    )
    
    if response.status_code == 200:
        print(f"✅ {len(concepts)} concepts added successfully")
    ```

## Retrieve a Complete Thesaurus

=== "Python"
    ```python
    # Retrieve the thesaurus with all its concepts
    thesaurus = requests.get(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/").json()
    
    print(f"\n📚 Thesaurus: {thesaurus['name']}")
    print(f"   Status: {thesaurus['status']}")
    print(f"   Number of concepts: {len(thesaurus.get('concept', []))}")
    
    # Display all concepts
    for concept in thesaurus.get('concept', []):
        print(f"   - {concept['code']}: {concept['display']}")
    ```

## Update a Thesaurus

=== "Python"
    ```python
    # Modify name and status
    updated = requests.put(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/", json={
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:ALLERGIES",
        "identifier": [
          {"use": "official", "value": "1"},
          {"use": "usual", "value": "ALLERGIES"}
        ],
        "name": "Allergies and intolerances",
        "title": "Allergies Thesaurus",
        "status": "active",
        "content": "complete",
        "concept": [
            {"code": "PENICILLINE", "display": "Penicillin allergy"},
            {"code": "IODE", "display": "Iodine allergy"}
        ]
    }).json()
    
    print(f"✅ Thesaurus updated: {updated['name']}")
    ```

## Complete Example: COVID Symptoms Thesaurus

```python
import requests

BASE_URL = "{API_URL}"

# 1. Create the thesaurus
covid_thesaurus = requests.post(f"{BASE_URL}/v4.3.0/codesystem/", json={
    "resourceType": "CodeSystem",
    "url": "urn:codoc:fhir:codesystem:COVID_SYMPTOMES",
    "identifier": [
      {"use": "official", "value": "1"},
      {"use": "usual", "value": "COVID_SYMPTOMES"}
    ],
    "name": "COVID-19 Symptoms",
    "title": "COVID-19 Symptoms",
    "status": "active",
    "content": "complete"
}).json()

print(f"✅ Thesaurus created: {covid_thesaurus['name']}")

# 2. Define concepts
symptoms = [
    {"code": "FIEVRE", "display": "Fever > 38°C"},
    {"code": "TOUX", "display": "Persistent dry cough"},
    {"code": "DYSPNEE", "display": "Breathing difficulties"},
    {"code": "ANOSMIE", "display": "Loss of smell"},
    {"code": "AGUEUSIE", "display": "Loss of taste"},
    {"code": "FATIGUE", "display": "Severe fatigue"},
    {"code": "CEPHALEE", "display": "Headache"},
    {"code": "MYALGIE", "display": "Muscle pain"},
    {"code": "DIARRHEE", "display": "Diarrhea"},
    {"code": "RHINORRHEE", "display": "Runny nose"}
]

# 3. Add all concepts
response = requests.post(
    f"{BASE_URL}/v4.3.0/codesystem/COVID_SYMPTOMES/concept/",
    json={"concept": symptoms}
)

print(f"✅ {len(symptoms)} symptoms added")

# 4. Verify the result
thesaurus = requests.get(f"{BASE_URL}/v4.3.0/codesystem/COVID_SYMPTOMES/").json()

print(f"\n📚 Complete thesaurus:")
print(f"   Name: {thesaurus['name']}")
print(f"   Code: {thesaurus['identifier'][1]['value']}")
print(f"   Concepts: {len(thesaurus['concept'])}")

print("\n📋 Concept list:")
for concept in thesaurus['concept']:
    print(f"   {concept['code']:15} → {concept['display']}")
```

**Expected output:**
```
✅ Thesaurus created: COVID-19 Symptoms
✅ 10 symptoms added

📚 Complete thesaurus:
   Name: COVID-19 Symptoms
   Code: COVID_SYMPTOMES
   Concepts: 10

📋 Concept list:
   FIEVRE          → Fever > 38°C
   TOUX            → Persistent dry cough
   DYSPNEE         → Breathing difficulties
   ANOSMIE         → Loss of smell
   AGUEUSIE        → Loss of taste
   FATIGUE         → Severe fatigue
   CEPHALEE        → Headache
   MYALGIE         → Muscle pain
   DIARRHEE        → Diarrhea
   RHINORRHEE      → Runny nose
```

## Use the Thesaurus in Observations

Once created, use your thesaurus to code observations:

=== "Python"
    ```python
    # Create an observation with a code from the thesaurus
    observation = requests.post(f"{BASE_URL}/v4.3.0/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {
            "coding": [{
                "system": "http://codoc.com/fhir/codesystem/COVID_SYMPTOMES",
                "code": "FIEVRE",
                "display": "Fever > 38°C"
            }]
        },
        "subject": {"reference": "Patient/123"},
        "effectiveDateTime": "2024-11-05T10:00:00Z",
        "valueQuantity": {
            "value": 39.2,
            "unit": "°C"
        }
    }).json()
    
    print(f"✅ Observation created with code {observation['code']['coding'][0]['code']}")
    ```

## Filter Observations by Thesaurus

You can list observations and filter by thesaurus on the application side:

```python
import requests

# List observations with pagination
response = requests.get(f"{BASE_URL}/v4.3.0/observation/?_count=50")
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

## Delete a Thesaurus

=== "curl"
    ```bash
    curl -X DELETE {API_URL}/v4.3.0/codesystem/ALLERGIES/
    ```

=== "Python"
    ```python
    response = requests.delete(f"{BASE_URL}/v4.3.0/codesystem/ALLERGIES/")
    
    if response.status_code == 204:
        print("✅ Thesaurus deleted")
    ```

!!! warning "Deletion"
    Deletion will fail if observations still use codes from this thesaurus.

## Practical Use Cases

### Treatment Thesaurus

```python
treatments = requests.post(f"{BASE_URL}/v4.3.0/codesystem/", json={
    "resourceType": "CodeSystem",
    "url": "urn:codoc:fhir:codesystem:TRAITEMENTS_CARDIO",
    "identifier": [
      {"use": "official", "value": "1"},
      {"use": "usual", "value": "TRAITEMENTS_CARDIO"}
    ],
    "name": "Cardiology treatments",
    "title": "Cardiology Treatments",
    "status": "active",
    "content": "complete"
}).json()

concepts = [
    {"code": "STATINE", "display": "Statin"},
    {"code": "BETABLOQUANT", "display": "Beta-blocker"},
    {"code": "IEC", "display": "ACE inhibitor"},
    {"code": "ASPIRINE", "display": "Aspirin"},
    {"code": "CLOPIDOGREL", "display": "Clopidogrel"}
]

requests.post(
    f"{BASE_URL}/v4.3.0/codesystem/TRAITEMENTS_CARDIO/concept/",
    json={"concept": concepts}
)
```

### Clinical Scores Thesaurus

```python
scores = requests.post(f"{BASE_URL}/v4.3.0/codesystem/", json={
    "resourceType": "CodeSystem",
    "url": "urn:codoc:fhir:codesystem:SCORES_CARDIO",
    "identifier": [
      {"use": "official", "value": "1"},
      {"use": "usual", "value": "SCORES_CARDIO"}
    ],
    "name": "Cardiology scores",
    "title": "Cardiology Scores",
    "status": "active",
    "content": "complete"
}).json()

concepts = [
    {"code": "NYHA", "display": "NYHA Classification (heart failure)"},
    {"code": "GRACE", "display": "GRACE Score (acute coronary syndrome risk)"},
    {"code": "TIMI", "display": "TIMI Score (heart attack risk)"},
    {"code": "CHA2DS2_VASC", "display": "CHA2DS2-VASc Score (stroke risk in atrial fibrillation)"}
]

requests.post(
    f"{BASE_URL}/v4.3.0/codesystem/SCORES_CARDIO/concept/",
    json={"concept": concepts}
)
```

## Key Points

!!! tip "Naming Conventions"
    Use **UPPER_SNAKE_CASE** codes for identifiers and concept codes

!!! warning "Unique Codes"
    Concept codes must be **unique** within a thesaurus

!!! info "Batch Creation"
    Use `{"concept": [...]}` to add multiple concepts in a single request

## Next Steps

- [Semantic Enrichment](semantic-enrichment.md)
- [Create a Patient Record](patient-record.md)
