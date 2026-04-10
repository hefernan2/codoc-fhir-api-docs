---
title: CodeSystem
---

# CodeSystem - Medical Vocabularies

The **CodeSystem** resource represents medical thesauruses (ICD10, ATC, CCAM, custom vocabularies).

## Endpoints

### Thesaurus

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/</span>
</div>

### Concepts

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/codesystem/{code}/concept/{concept_code}/</span>
</div>

## Search Parameters

No filter parameters are available for CodeSystem. The full list of thesauruses is returned (paginated).

!!! info "Public endpoint"
    This endpoint does not require authentication.

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

## List Thesauruses

```bash
curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/codesystem/?_count=20"
```

```python
import requests

response = requests.get(
    "{API_URL}/v4.3.0/codesystem/",
    params={"_count": 20}
)

bundle = response.json()
print(f"Total: {bundle['total']} thesauruses")
for entry in bundle.get("entry", []):
    cs = entry["resource"]
    print(f"  {cs['name']}: {cs.get('title', 'N/A')}")
```

## Retrieve a Thesaurus with Concepts

```bash
curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/codesystem/ALLERGIES/
```

```python
import requests

thesaurus = requests.get("{API_URL}/v4.3.0/codesystem/ALLERGIES/").json()

print(f"Thesaurus: {thesaurus['name']}")
print(f"Status: {thesaurus['status']}")
print(f"Number of concepts: {len(thesaurus.get('concept', []))}")

for concept in thesaurus.get('concept', []):
    print(f"  {concept['code']}: {concept['display']}")
```

**Response:**
```json
{
  "resourceType": "CodeSystem",
  "id": "1",
  "name": "ALLERGIES",
  "title": "Allergies Thesaurus",
  "status": "active",
  "content": "complete",
  "concept": [
    {"id": "11", "code": "PENICILLIN", "display": "Penicillin allergy"},
    {"id": "12", "code": "PEANUT", "display": "Peanut allergy"},
    {"id": "13", "code": "LATEX", "display": "Latex allergy"}
  ]
}
```

## Retrieve a Single Concept

```bash
curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/codesystem/ALLERGIES/concept/PENICILLIN/
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

## Related Resources

All thesauruses are used by:

- [Observation](observation.md) - "Biologie" thesaurus
- [Observation-phenotype](observation-phenotype.md) - "Phenotypes" thesaurus
- [Procedure](procedure.md) - "Acte" thesaurus
- [MedicationRequest](medicationrequest.md) - "Prescription" thesaurus
- [DiagnosticReport](diagnosticreport.md) - "Diagnostic" thesaurus

<div class="quick-links">
  <a href="../../guides/custom-thesaurus/">📖 Guide: Query Medical Vocabularies</a>
</div>
