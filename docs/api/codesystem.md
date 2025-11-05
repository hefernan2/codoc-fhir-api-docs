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
| `url` | uri | ✅ Yes | Auto-generated: urn:codoc:fhir:codesystem:{code} |
| `identifier[]` | Identifier[] | ✅ Yes | 2 identifiers: official (ID) + usual (code) |
| `name` | string | ✅ Yes | Technical name (maps to Thesaurus.code) |
| `title` | string | ✅ **Yes** (NOT Optional!) | Full title (maps to Thesaurus.label) |
| `status` | code | ✅ Yes | ⚠️ Hardcoded "active" (not customizable) |
| `content` | code | ✅ Yes | ⚠️ Hardcoded "complete" (not customizable) |

### Concept

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `code` | code | ✅ Yes | Unique code in thesaurus |
| `display` | string | ✅ Yes | Concept label |

## Create a Thesaurus

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ \
      -H "Content-Type: application/json" \
      -d '{
          "resourceType": "CodeSystem",
          "url": "urn:codoc:fhir:codesystem:CIM10-FR",
          "identifier": [
            {
              "use": "official",
              "value": "1"
            },
            {
              "use": "usual",
              "value": "CIM10-FR"
            }
          ],
          "name": "CIM10-FR",
          "title": "CIM-10 French Classification",
          "status": "active",
          "content": "complete"
      }'
    ```

=== "Python"
    ```python
    thesaurus = {
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:CIM10-FR",
        "identifier": [
          {
            "use": "official",
            "value": "1"
          },
          {
            "use": "usual",
            "value": "CIM10-FR"
          }
        ],
        "name": "CIM10-FR",
        "title": "CIM-10 French Classification",
        "status": "active",
        "content": "complete"
    }
    
    response = requests.post("{API_URL}/v4.3.0/codesystem/", json=thesaurus)
    ```

## Add Concepts

=== "curl (single concept)"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/ \
    -H "Content-Type: application/json" \
    -d   '{
          "resourceType": "CodeSystemConcept",
          "code": "PENICILLIN",
          "display": "Penicillin allergy"
      }'
    ```

=== "curl (multiple concepts)"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/ \
      -H "Content-Type: application/json" \
      -d '{
        "concept": [
          {
            "code": "PENICILLIN",
            "display": "Penicillin allergy"
          },
          {
            "code": "PEANUT",
            "display": "Peanut allergy"
          },
          {
            "code": "LATEX",
            "display": "Latex allergy"
          }
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
        "{API_URL}/v4.3.0/codesystem/ALLERGIES/concept/",
        json={"concept": concepts}
    )
    ```

## Retrieve a Thesaurus with Concepts

=== "curl"
    ```bash
    curl {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/{CONCEPT_ID}
    ```

**Response:**
```json
{
  [
    {
      "id":"11",
      "code":"PENICILLIN",
      "display":"Penicillin allergy"
    },
    {
      "id":"12",
      "code":"PEANUT",
      "display":"Peanut allergy"
    },
    {
      "id":"13",
      "code":"LATEX",
      "display":"Latex allergy"
    }
  ]
}
```

## Update a Concept

=== "curl"
    ```bash
    curl -X PUT {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/{PENICILLIN_ID}/ \
      -H "Content-Type: application/json" \
      -d '{
            "resourceType": "CodeSystemConcept",
            "code": "PENICILLIN",
            "display": "Penicillin and derivatives allergy"
      }'
    ```

## Delete a Concept

=== "curl"
    ```bash
    curl -X DELETE {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/{CONCEPT_ID}/
    ```

## Use Cases

### Create a Custom Thesaurus

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/codesystem/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:COVID_SYMPTOMS",
        "identifier": [
          {
            "use": "official",
            "value": "1"
          },
          {
            "use": "usual",
            "value": "COVID_SYMPTOMS"
          }
        ],
        "name": "COVID-19 Symptoms",
        "title": "COVID-19 Symptoms",
        "status": "active",
        "content": "complete"
      }'
    ```

=== "Python"
    ```python
    # 1. Create the thesaurus
    thesaurus = requests.post("{API_URL}/v4.3.0/codesystem/", json={
        "resourceType": "CodeSystem",
        "url": "urn:codoc:fhir:codesystem:COVID_SYMPTOMS",
        "identifier": [
          {
            "use": "official",
            "value": "1"
          },
          {
            "use": "usual",
            "value": "COVID_SYMPTOMS"
          }
        ],
        "name": "COVID-19 Symptoms",
        "title": "COVID-19 Symptoms",
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
        "{API_URL}/v4.3.0/codesystem/COVID_SYMPTOMS/concept/",
        json={"concept": concepts}
    )
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
