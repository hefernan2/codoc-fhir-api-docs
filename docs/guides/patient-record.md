---
title: Create a Complete Patient Record
---

# Create a Complete Patient Record

This guide shows you how to create a patient record with all necessary information.

## Objective

Create a patient with:
- Identity and demographics
- Hospital stay
- Clinical document
- Lab results

## Step 1: Create the Organization

Let's start by creating a care unit that will manage the patient.

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO_A"}],
        "type": [{"coding": [{"code": "unit"}]}],
        "name": "Cardiology Unit A"
      }'
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    
    # Create the unit
    unit = requests.post(f"{BASE_URL}/v4.3.0/organization/", json={
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO_A"}],
        "type": [{"coding": [{"code": "unit"}]}],
        "name": "Cardiology Unit A"
    }).json()
    
    unit_id = unit["id"]
    print(f"✅ Unit created: ID {unit_id}")
    ```

## Step 2: Create the Patient

=== "curl"
    ```bash
    # Replace {unit_id} with ID from step 1
    curl -X POST {API_URL}/v4.3.0/patient/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "identifier": [{"value": "IPP987654"}],
        "name": [{"family": "Smith", "given": ["Emma", "Marie"]}],
        "gender": "female",
        "birthDate": "1975-03-20",
        "managingOrganization": {"reference": "Organization/{unit_id}"}
      }'
    ```

=== "Python"
    ```python
    # Create the patient
    patient = requests.post(f"{BASE_URL}/v4.3.0/patient/", json={
        "resourceType": "Patient",
        "identifier": [{"value": "IPP987654"}],
        "name": [{"family": "Smith", "given": ["Emma", "Marie"]}],
        "gender": "female",
        "birthDate": "1975-03-20",
        "managingOrganization": {"reference": f"Organization/{unit_id}"}
    }).json()
    
    patient_id = patient["id"]
    print(f"✅ Patient created: {patient['name'][0]['family']} (ID {patient_id})")
    ```

## Step 3: Create the Stay

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/encounter/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Encounter",
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": "Patient/{patient_id}"},
        "serviceProvider": {"reference": "Organization/{unit_id}"},
        "period": {"start": "2024-11-05T08:00:00Z"}
      }'
    ```

=== "Python"
    ```python
    # Create the stay
    stay = requests.post(f"{BASE_URL}/v4.3.0/encounter/", json={
        "resourceType": "Encounter",
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "serviceProvider": {"reference": f"Organization/{unit_id}"},
        "period": {"start": "2024-11-05T08:00:00Z"}
    }).json()
    
    stay_id = stay["id"]
    print(f"✅ Stay created: ID {stay_id}")
    ```

## Step 4: Add a Clinical Document

=== "Python"
    ```python
    import base64
    
    # HTML document content
    html_content = """
    <h1>Admission Report</h1>
    <h2>Reason</h2>
    <p>Chest pain</p>
    <h2>Clinical Examination</h2>
    <p>Patient conscious, BP 140/90, HR 85</p>
    <h2>Diagnosis</h2>
    <p>Suspected unstable angina</p>
    """
    
    # Encode to Base64
    encoded_content = base64.b64encode(html_content.encode()).decode()
    
    # Create the document
    document = requests.post(f"{BASE_URL}/v4.3.0/documentreference/", json={
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": f"Patient/{patient_id}"},
        "context": {"encounter": [{"reference": f"Encounter/{stay_id}"}]},
        "author": [
            {"display": "Dr. Dubois"},
            {"reference": f"Organization/{unit_id}", "display": "Cardiology A"}
        ],
        "date": "2024-11-05T09:30:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": encoded_content,
                "title": "Admission Report"
            }
        }]
    }).json()
    
    document_id = document["id"]
    print(f"✅ Document created: ID {document_id}")
    ```

## Step 5: Add Lab Results

=== "Python"
    ```python
    # Hemoglobin
    obs1 = requests.post(f"{BASE_URL}/v4.3.0/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": "HEMOGLOBIN", "display": "Hemoglobin"}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "encounter": {"reference": f"Encounter/{stay_id}"},
        "effectiveDateTime": "2024-11-05T10:00:00Z",
        "valueQuantity": {"value": 13.5, "unit": "g/dL"}
    }).json()
    
    # Blood glucose
    obs2 = requests.post(f"{BASE_URL}/v4.3.0/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": "GLUCOSE", "display": "Blood Glucose"}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "encounter": {"reference": f"Encounter/{stay_id}"},
        "effectiveDateTime": "2024-11-05T10:00:00Z",
        "valueQuantity": {"value": 1.05, "unit": "g/L"}
    }).json()
    
    print(f"✅ Observations created: {obs1['id']}, {obs2['id']}")
    ```

## Step 6: Verify the Complete Record

=== "Python"
    ```python
    # Retrieve all data
    patient_data = requests.get(f"{BASE_URL}/v4.3.0/patient/{patient_id}/").json()
    stay_data = requests.get(f"{BASE_URL}/v4.3.0/encounter/{stay_id}/").json()
    document_data = requests.get(f"{BASE_URL}/v4.3.0/documentreference/{document_id}/").json()
    
    print("\n📋 COMPLETE PATIENT RECORD")
    print("=" * 50)
    print(f"Patient: {patient_data['name'][0]['family']} {patient_data['name'][0]['given'][0]}")
    print(f"IPP: {patient_data['identifier'][0]['value']}")
    print(f"Gender: {patient_data['gender']}")
    print(f"Birth date: {patient_data['birthDate']}")
    print(f"\nStay: {stay_data['status']} since {stay_data['period']['start']}")
    print(f"Document: {document_data['content'][0]['attachment']['title']}")
    print(f"Observations: Hemoglobin 13.5 g/dL, Blood glucose 1.05 g/L")
    ```

## Complete Script

Here is the complete Python script to create the entire record at once:

```python
import requests
import base64

BASE_URL = "{API_URL}"

# 1. Create the unit
unit = requests.post(f"{BASE_URL}/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"value": "CARDIO_A"}],
    "type": [{"coding": [{"code": "unit"}]}],
    "name": "Cardiology Unit A"
}).json()
unit_id = unit["id"]

# 2. Create the patient
patient = requests.post(f"{BASE_URL}/v4.3.0/patient/", json={
    "resourceType": "Patient",
    "identifier": [{"value": "IPP987654"}],
    "name": [{"family": "Martin", "given": ["Sophie", "Marie"]}],
    "gender": "female",
    "birthDate": "1975-03-20",
    "managingOrganization": {"reference": f"Organization/{unit_id}"}
}).json()
patient_id = patient["id"]

# 3. Create the stay
stay = requests.post(f"{BASE_URL}/v4.3.0/encounter/", json={
    "resourceType": "Encounter",
    "status": "in-progress",
    "class": {"code": "IMP"},
    "subject": {"reference": f"Patient/{patient_id}"},
    "serviceProvider": {"reference": f"Organization/{unit_id}"},
    "period": {"start": "2024-11-05T08:00:00Z"}
}).json()
stay_id = stay["id"]

# 4. Create the document
html_content = "<h1>Admission Report</h1><p>Chest pain</p>"
encoded_content = base64.b64encode(html_content.encode()).decode()
document = requests.post(f"{BASE_URL}/v4.3.0/documentreference/", json={
    "resourceType": "DocumentReference",
    "status": "current",
    "subject": {"reference": f"Patient/{patient_id}"},
    "context": {"encounter": [{"reference": f"Encounter/{stay_id}"}]},
    "date": "2024-11-05T09:30:00Z",
    "content": [{"attachment": {"contentType": "text/html", "data": encoded_content}}]
}).json()

# 5. Create the observations
obs1 = requests.post(f"{BASE_URL}/v4.3.0/observation/", json={
    "resourceType": "Observation",
    "status": "final",
    "code": {"coding": [{"code": "HEMOGLOBIN"}]},
    "subject": {"reference": f"Patient/{patient_id}"},
    "encounter": {"reference": f"Encounter/{stay_id}"},
    "effectiveDateTime": "2024-11-05T10:00:00Z",
    "valueQuantity": {"value": 13.5, "unit": "g/dL"}
}).json()

print(f"✅ Patient record created successfully!")
print(f"   Patient ID: {patient_id}")
print(f"   Stay ID: {stay_id}")
print(f"   Document ID: {document['id']}")
print(f"   Observation ID: {obs1['id']}")
```

## Key Points

!!! tip "Creation Order"
    Always create in this order: Organization → Patient → Encounter → Documents/Observations

!!! warning "References"
    Use the IDs returned by each creation for subsequent references

!!! info "Base64 Encoding"
    HTML documents must be Base64 encoded before sending

## Next Steps

- [Navigate the Hospital Hierarchy](organization-hierarchy.md)
- [Track the Patient Journey](patient-journey.md)
- [Semantic Enrichment](semantic-enrichment.md)
