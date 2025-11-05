---
title: Track Patient Journey
---

# Track Patient Journey

This guide explains how to track a patient's complete journey from admission to discharge.

## Overview

A **patient journey** includes:

1. **Admission**: Creating the stay (Stay)
2. **Movements**: Transfers between departments (Movement)
3. **Documents**: Reports at each stage
4. **Observations**: Clinical and laboratory data
5. **Discharge**: Closing the stay

## Step 1: Patient Admission

=== "Python"
    ```python
    import requests
    from datetime import datetime
    
    BASE_URL = "http://localhost:8000/v4.3.0"
    
    # Prerequisites: care units
    emergency = {"id": 1, "name": "Emergency"}
    cardio = {"id": 2, "name": "Cardiology"}
    icu = {"id": 3, "name": "Intensive Care"}
    
    # Patient
    patient = requests.post(f"{BASE_URL}/patient/", json={
        "resourceType": "Patient",
        "identifier": [{"value": "IPP789456"}],
        "name": [{"family": "Johnson", "given": ["John"]}],
        "gender": "male",
        "birthDate": "1958-08-10"
    }).json()
    patient_id = patient["id"]
    
    # Admission to Emergency
    stay = requests.post(f"{BASE_URL}/encounter/", json={
        "resourceType": "Encounter",
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "serviceProvider": {"reference": f"Organization/{emergency['id']}"},
        "period": {"start": "2024-11-05T08:30:00Z"}
    }).json()
    stay_id = stay["id"]
    
    print(f"✅ Patient admitted to {emergency['name']}")
    print(f"   Patient ID: {patient_id}")
    print(f"   Stay ID: {stay_id}")
    ```

## Step 2: First Movement (Emergency)

=== "Python"
    ```python
    # Create admission movement to Emergency
    mvt1 = requests.post(f"{BASE_URL}/encounter/", json={
        "resourceType": "Encounter",
        "status": "finished",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "partOf": {"reference": f"Encounter/{stay_id}"},
        "serviceProvider": {"reference": f"Organization/{emergency['id']}"},
        "period": {
            "start": "2024-11-05T08:30:00Z",
            "end": "2024-11-05T14:00:00Z"
        }
    }).json()
    
    print(f"✅ Movement to Emergency: {mvt1['id']}")
    print(f"   Duration: 5h30 (08:30 → 14:00)")
    ```

## Step 3: Admission Document

=== "Python"
    ```python
    import base64
    
    admission_text = """
    <h1>Emergency Admission</h1>
    <h2>Reason</h2>
    <p>Intense chest pain for 2 hours, resistant to analgesics.</p>
    
    <h2>Clinical Examination</h2>
    <p>Conscious patient, sweating. BP 160/100, HR 95, SpO2 98%.</p>
    <p>Cardiac auscultation: systolic murmur 3/6.</p>
    
    <h2>ECG</h2>
    <p>ST segment elevation in anterior leads.</p>
    
    <h2>Diagnosis</h2>
    <p>Acute ST-elevation coronary syndrome. Cardiology pathway activated.</p>
    """
    
    doc1 = requests.post(f"{BASE_URL}/documentreference/", json={
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": f"Patient/{patient_id}"},
        "context": {
            "encounter": [{"reference": f"Encounter/{stay_id}"}]
        },
        "date": "2024-11-05T13:45:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": base64.b64encode(admission_text.encode()).decode(),
                "title": "Emergency Admission Report"
            }
        }]
    }).json()
    
    print(f"✅ Admission document created: {doc1['id']}")
    ```

## Step 4: Transfer to Cardiology

=== "Python"
    ```python
    # Create movement to Cardiology
    mvt2 = requests.post(f"{BASE_URL}/encounter/", json={
        "resourceType": "Encounter",
        "status": "finished",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "partOf": {"reference": f"Encounter/{stay_id}"},
        "serviceProvider": {"reference": f"Organization/{cardio['id']}"},
        "period": {
            "start": "2024-11-05T14:00:00Z",
            "end": "2024-11-05T20:00:00Z"
        }
    }).json()
    
    print(f"✅ Transfer to Cardiology: {mvt2['id']}")
    print(f"   Duration: 6h (14:00 → 20:00)")
    
    # Transfer document
    cardio_text = """
    <h1>Cardiology Management</h1>
    <h2>Coronary Angiography</h2>
    <p>95% tight stenosis of proximal LAD. Angioplasty with drug-eluting stent placement.</p>
    
    <h2>Evolution</h2>
    <p>Chest pain resolved post-procedure.</p>
    <p>ECG: ST segment normalization.</p>
    
    <h2>Complications</h2>
    <p>Hemodynamic destabilization at 7:45 PM. SBP at 80 mmHg despite fluid resuscitation.</p>
    
    <h2>Decision</h2>
    <p>Transfer to Intensive Care for close monitoring.</p>
    """
    
    doc2 = requests.post(f"{BASE_URL}/documentreference/", json={
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": f"Patient/{patient_id}"},
        "context": {"encounter": [{"reference": f"Encounter/{stay_id}"}]},
        "date": "2024-11-05T19:50:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": base64.b64encode(cardio_text.encode()).decode(),
                "title": "Cardiology Report"
            }
        }]
    }).json()
    
    print(f"✅ Cardiology document created: {doc2['id']}")
    ```

## Step 5: Transfer to Intensive Care

=== "Python"
    ```python
    # Movement to Intensive Care (in progress)
    mvt3 = requests.post(f"{BASE_URL}/encounter/", json={
        "resourceType": "Encounter",
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "partOf": {"reference": f"Encounter/{stay_id}"},
        "serviceProvider": {"reference": f"Organization/{icu['id']}"},
        "period": {
            "start": "2024-11-05T20:00:00Z"
        }
    }).json()
    mvt3_id = mvt3["id"]
    
    print(f"✅ Transfer to Intensive Care: {mvt3_id}")
    print(f"   Status: in-progress (patient currently in ICU)")
    ```

## Step 6: Observations in Intensive Care

=== "Python"
    ```python
    # Elevated troponin
    obs1 = requests.post(f"{BASE_URL}/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": "TROPONINE", "display": "Troponin Ic"}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "encounter": {"reference": f"Encounter/{stay_id}"},
        "effectiveDateTime": "2024-11-05T21:00:00Z",
        "valueQuantity": {"value": 15000, "unit": "ng/L"}
    }).json()
    
    # BNP
    obs2 = requests.post(f"{BASE_URL}/observation/", json={
        "resourceType": "Observation",
        "status": "final",
        "code": {"coding": [{"code": "BNP", "display": "BNP"}]},
        "subject": {"reference": f"Patient/{patient_id}"},
        "encounter": {"reference": f"Encounter/{stay_id}"},
        "effectiveDateTime": "2024-11-05T21:00:00Z",
        "valueQuantity": {"value": 850, "unit": "pg/mL"}
    }).json()
    
    print(f"✅ Observations created: Troponin, BNP")
    ```

## Step 7: Patient Discharge

=== "Python"
    ```python
    # Close the Intensive Care movement
    mvt3_updated = requests.put(f"{BASE_URL}/encounter/movement/{mvt3_id}/", json={
        "resourceType": "Encounter",
        "status": "finished",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "partOf": {"reference": f"Encounter/{stay_id}"},
        "serviceProvider": {"reference": f"Organization/{icu['id']}"},
        "period": {
            "start": "2024-11-05T20:00:00Z",
            "end": "2024-11-07T10:00:00Z"
        }
    }).json()
    
    # Close the stay
    stay_updated = requests.put(f"{BASE_URL}/encounter/stay/{stay_id}/", json={
        "resourceType": "Encounter",
        "status": "finished",
        "class": {"code": "IMP"},
        "subject": {"reference": f"Patient/{patient_id}"},
        "serviceProvider": {"reference": f"Organization/{icu['id']}"},
        "period": {
            "start": "2024-11-05T08:30:00Z",
            "end": "2024-11-07T10:00:00Z"
        }
    }).json()
    
    print(f"✅ Patient discharged")
    print(f"   Total stay duration: 1 day 1h30")
    
    # Discharge document
    discharge_text = """
    <h1>Discharge Report</h1>
    <h2>Primary Diagnosis</h2>
    <p>Anterior ST-elevation myocardial infarction on LAD stenosis.</p>
    
    <h2>Procedure</h2>
    <p>Angioplasty with drug-eluting stent placement on proximal LAD.</p>
    
    <h2>Evolution</h2>
    <p>Transient post-procedure hemodynamic destabilization, stabilized in ICU.</p>
    <p>Echocardiography: LVEF 45%, anterior hypokinesis.</p>
    
    <h2>Discharge Treatment</h2>
    <p>- Aspirin 75 mg/day</p>
    <p>- Clopidogrel 75 mg/day (12 months)</p>
    <p>- Atorvastatin 80 mg/day</p>
    <p>- Bisoprolol 2.5 mg/day</p>
    <p>- Ramipril 5 mg/day</p>
    
    <h2>Follow-up</h2>
    <p>Cardiology appointment at 1 month. Control echocardiography at 3 months.</p>
    """
    
    doc3 = requests.post(f"{BASE_URL}/documentreference/", json={
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": f"Patient/{patient_id}"},
        "context": {"encounter": [{"reference": f"Encounter/{stay_id}"}]},
        "date": "2024-11-07T10:00:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": base64.b64encode(discharge_text.encode()).decode(),
                "title": "Discharge Report"
            }
        }]
    }).json()
    
    print(f"✅ Discharge document created: {doc3['id']}")
    ```

## Journey Visualization

=== "Python"
    ```python
    # Journey summary
    print("\n" + "="*70)
    print("📊 PATIENT JOURNEY - SUMMARY")
    print("="*70)
    
    print(f"\n👤 Patient: {patient['name'][0]['family']} {patient['name'][0]['given'][0]}")
    print(f"   IPP: {patient['identifier'][1]['value']}")
    print(f"   Stay ID: {stay_id}")
    
    print(f"\n🏥 Admission: 11/05/2024 08:30")
    print(f"🚪 Discharge: 11/07/2024 10:00")
    print(f"⏱️  Total duration: 1 day 1h30")
    
    print(f"\n📍 MOVEMENTS:")
    print(f"   1. Emergency (08:30-14:00) - 5h30")
    print(f"      → ECG, ST-elevation ACS diagnosis")
    print(f"   2. Cardiology (14:00-20:00) - 6h")
    print(f"      → Coronary angiography + angioplasty")
    print(f"   3. Intensive Care (20:00-10:00+2d) - 38h")
    print(f"      → Post-destabilization monitoring")
    
    print(f"\n📄 DOCUMENTS:")
    print(f"   - Emergency Admission (13:45)")
    print(f"   - Cardiology Report (19:50)")
    print(f"   - Discharge Report (10:00+2d)")
    
    print(f"\n🔬 OBSERVATIONS:")
    print(f"   - Troponin Ic: 15000 ng/L")
    print(f"   - BNP: 850 pg/mL")
    
    print("="*70)
    ```

## Complete Journey Script

The complete script is available below. It automatically creates the entire patient journey in a single execution.

```python
import requests
import base64

BASE_URL = "http://localhost:8000/v4.3.0"

# Create patient and stay
patient = requests.post(f"{BASE_URL}/patient/", json={
    "resourceType": "Patient",
    "identifier": [{"value": "IPP789456"}],
    "name": [{"family": "Johnson", "given": ["John"]}],
    "gender": "male",
    "birthDate": "1958-08-10"
}).json()
patient_id = patient["id"]

stay = requests.post(f"{BASE_URL}/encounter/", json={
    "resourceType": "Encounter",
    "status": "in-progress",
    "class": {"code": "IMP"},
    "subject": {"reference": f"Patient/{patient_id}"},
    "serviceProvider": {"reference": "Organization/1"},
    "period": {"start": "2024-11-05T08:30:00Z"}
}).json()
stay_id = stay["id"]

# Create movements and documents (see detailed code above)
# ...

print("✅ Patient journey created successfully!")
```

## Key Points

!!! tip "Movements vs Stay"
    - **Stay**: global stay (status `in-progress` or `finished`)
    - **Movement**: movement to a unit (always with `partOf` pointing to the Stay)

!!! warning "Chronological Order"
    Movement dates must be consistent (no overlap)

!!! info "Attached Documents"
    Documents use `context.encounter` pointing to the **Stay**, not to individual Movements

## Next Steps

- [Create a Patient Record](patient-record.md)
- [Navigate Hospital Hierarchy](organization-hierarchy.md)
