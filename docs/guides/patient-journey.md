---
title: Trace Patient Journey
---

# Trace Patient Journey

This guide explains how to retrieve a patient's complete journey from admission to discharge.

## Overview

A **patient journey** consists of:

1. **Stay**: global hospitalization record
2. **Movements**: transfers between departments
3. **Documents**: reports at each stage
4. **Observations**: clinical and laboratory data

## Step 1: Retrieve the Stay

=== "curl"
    ```bash
    # Retrieve a stay by ID
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/encounter/stay/789/
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    HEADERS = {"Authorization": "Api-Key {API_KEY}"}
    stay_id = 789
    
    stay = requests.get(f"{BASE_URL}/v4.3.0/encounter/stay/{stay_id}/", headers=HEADERS).json()
    
    print(f"Stay ID: {stay['id']}")
    print(f"Status: {stay['status']}")
    print(f"Admission: {stay['period']['start']}")
    if 'end' in stay.get('period', {}):
        print(f"Discharge: {stay['period']['end']}")
    if 'serviceProvider' in stay:
        print(f"Service: {stay['serviceProvider']['reference']}")
    ```

## Step 2: Retrieve Movements

Movements are encounters with a `partOf` reference pointing to the stay:

=== "Python"
    ```python
    # List all encounters and filter movements for this stay
    encounters = requests.get(
        f"{BASE_URL}/v4.3.0/encounter/",
        params={"_count": 100},
        headers=HEADERS
    ).json()
    
    # Filter movements linked to this stay
    movements = []
    for entry in encounters.get("entry", []):
        enc = entry["resource"]
        if "partOf" in enc:
            parent_ref = enc["partOf"]["reference"]
            if str(stay_id) in parent_ref:
                movements.append(enc)
    
    print(f"\n📍 MOVEMENTS ({len(movements)} total):")
    for mvt in movements:
        period = mvt.get("period", {})
        start = period.get("start", "N/A")
        end = period.get("end", "in progress")
        service = mvt.get("serviceProvider", {}).get("display", "N/A")
        print(f"  [{mvt['status']}] {service}: {start} → {end}")
    ```

## Step 3: Retrieve Associated Documents

=== "Python"
    ```python
    import base64
    
    # List documents
    documents = requests.get(
        f"{BASE_URL}/v4.3.0/documentreference/",
        params={"_count": 50},
        headers=HEADERS
    ).json()
    
    print(f"\n📄 DOCUMENTS ({documents['total']} total):")
    for entry in documents.get("entry", []):
        doc = entry["resource"]
        title = doc["content"][0]["attachment"].get("title", "Untitled")
        print(f"  {doc['date']}: {title} (ID {doc['id']})")
    
    # Decode a document's content
    if documents.get("entry"):
        doc = documents["entry"][0]["resource"]
        encoded = doc["content"][0]["attachment"]["data"]
        content = base64.b64decode(encoded).decode()
        print(f"\n  Content preview: {content[:200]}...")
    ```

## Step 4: Retrieve Clinical Observations

=== "Python"
    ```python
    # List observations
    observations = requests.get(
        f"{BASE_URL}/v4.3.0/observation/",
        params={"_count": 100},
        headers=HEADERS
    ).json()
    
    print(f"\n🔬 OBSERVATIONS ({observations['total']} total):")
    for entry in observations.get("entry", []):
        obs = entry["resource"]
        code = obs["code"]["coding"][0].get("display", obs["code"]["coding"][0]["code"])
        value = obs.get("valueQuantity", {})
        val_str = f"{value.get('value')} {value.get('unit', '')}" if value else obs.get("valueString", "N/A")
        print(f"  {obs['effectiveDateTime']}: {code} = {val_str}")
    ```

## Journey Summary

=== "Python"
    ```python
    print("\n" + "="*70)
    print("📊 PATIENT JOURNEY - SUMMARY")
    print("="*70)
    
    period = stay.get("period", {})
    print(f"\n🏥 Admission: {period.get('start', 'N/A')}")
    if "end" in period:
        print(f"🚪 Discharge: {period['end']}")
    else:
        print(f"🏥 Status: {stay['status']} (ongoing)")
    
    print(f"\n📍 Movements: {len(movements)}")
    print(f"📄 Documents: {documents['total']}")
    print(f"🔬 Observations: {observations['total']}")
    print("="*70)
    ```

## Key Points

!!! tip "Movements vs Stay"
    - **Stay**: global stay (status `in-progress` or `finished`)
    - **Movement**: movement to a unit (always has `partOf` pointing to the Stay)

!!! info "Attached Documents"
    Documents use `context.encounter` pointing to the **Stay**

## Next Steps

- [Query a Patient Record](patient-record.md)
- [Explore Hospital Hierarchy](organization-hierarchy.md)
