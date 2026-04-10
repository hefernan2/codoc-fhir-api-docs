---
title: Query a Patient Record
---

# Query a Patient Record

This guide shows you how to retrieve a complete patient record with all associated data.

## Objective

Query a patient with:
- Identity and demographics
- Hospital stays
- Clinical documents
- Lab results

## Step 1: Retrieve the Patient

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/patient/123/
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    HEADERS = {"Authorization": "Api-Key {API_KEY}"}
    patient_id = 123
    
    # Retrieve the patient
    patient = requests.get(f"{BASE_URL}/v4.3.0/patient/{patient_id}/", headers=HEADERS).json()
    
    print(f"Patient: {patient['name'][0]['family']} {patient['name'][0]['given'][0]}")
    print(f"IPP: {patient['identifier'][0]['value']}")
    print(f"Gender: {patient['gender']}")
    print(f"Birth date: {patient['birthDate']}")
    ```

## Step 2: Retrieve the Patient's Stays

=== "Python"
    ```python
    # List encounters (stays and movements)
    encounters = requests.get(
        f"{BASE_URL}/v4.3.0/encounter/",
        params={"_count": 50},
        headers=HEADERS
    ).json()
    
    print(f"\nTotal encounters: {encounters['total']}")
    for entry in encounters.get("entry", []):
        enc = entry["resource"]
        partof = " (movement)" if "partOf" in enc else " (stay)"
        print(f"  ID {enc['id']}: {enc['status']} - {enc['period'].get('start', 'N/A')}{partof}")
    ```

## Step 3: Retrieve Clinical Documents

=== "Python"
    ```python
    import base64
    
    # List documents
    documents = requests.get(
        f"{BASE_URL}/v4.3.0/documentreference/",
        params={"_count": 20},
        headers=HEADERS
    ).json()
    
    print(f"\nTotal documents: {documents['total']}")
    for entry in documents.get("entry", []):
        doc = entry["resource"]
        title = doc["content"][0]["attachment"].get("title", "Untitled")
        print(f"  ID {doc['id']}: {title} - {doc['date']}")
    
    # Retrieve and decode a specific document
    if documents.get("entry"):
        doc_id = documents["entry"][0]["resource"]["id"]
        doc = requests.get(f"{BASE_URL}/v4.3.0/documentreference/{doc_id}/", headers=HEADERS).json()
        
        encoded = doc["content"][0]["attachment"]["data"]
        content = base64.b64decode(encoded).decode()
        print(f"\nDocument content preview: {content[:200]}...")
    ```

## Step 4: Retrieve Lab Results

=== "Python"
    ```python
    # List observations
    observations = requests.get(
        f"{BASE_URL}/v4.3.0/observation/",
        params={"_count": 50},
        headers=HEADERS
    ).json()
    
    print(f"\nTotal observations: {observations['total']}")
    for entry in observations.get("entry", []):
        obs = entry["resource"]
        code = obs["code"]["coding"][0].get("display", obs["code"]["coding"][0]["code"])
        value = obs.get("valueQuantity", {})
        val_str = f"{value.get('value', 'N/A')} {value.get('unit', '')}" if value else obs.get("valueString", "N/A")
        print(f"  {code}: {val_str} ({obs['effectiveDateTime']})")
    ```

## Complete Script

Here is the complete Python script to retrieve the entire record:

```python
import requests
import base64

BASE_URL = "{API_URL}"
HEADERS = {"Authorization": "Api-Key {API_KEY}"}
patient_id = 123

# 1. Retrieve the patient
patient = requests.get(f"{BASE_URL}/v4.3.0/patient/{patient_id}/", headers=HEADERS).json()

# 2. Retrieve stays
encounters = requests.get(f"{BASE_URL}/v4.3.0/encounter/?_count=50", headers=HEADERS).json()

# 3. Retrieve documents
documents = requests.get(f"{BASE_URL}/v4.3.0/documentreference/?_count=20", headers=HEADERS).json()

# 4. Retrieve observations
observations = requests.get(f"{BASE_URL}/v4.3.0/observation/?_count=50", headers=HEADERS).json()

print("📋 COMPLETE PATIENT RECORD")
print("=" * 50)
print(f"Patient: {patient['name'][0]['family']} {patient['name'][0]['given'][0]}")
print(f"IPP: {patient['identifier'][0]['value']}")
print(f"Gender: {patient['gender']}")
print(f"Birth date: {patient['birthDate']}")
print(f"\nStays: {encounters['total']}")
print(f"Documents: {documents['total']}")
print(f"Observations: {observations['total']}")
```

## Key Points

!!! tip "Pagination"
    Use `_count` and `page` to paginate results for patients with many records.

!!! info "Base64 Encoding"
    HTML documents are Base64-encoded — use `base64.b64decode()` to read the content.

## Next Steps

- [Explore the Hospital Hierarchy](organization-hierarchy.md)
- [Trace the Patient Journey](patient-journey.md)
- [Semantic Enrichment](semantic-enrichment.md)
