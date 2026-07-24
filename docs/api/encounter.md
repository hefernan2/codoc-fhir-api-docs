---
title: Encounter
---

# Encounter - Stays and Movements

The **Encounter** resource represents hospital stays and intra-hospital movements.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/encounter/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/encounter/stay/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/encounter/movement/{id}/</span>
</div>

## Key Concepts

### Stay
A complete hospital stay without `partOf`.

**Examples:** Complete hospitalization, outpatient consultation, emergency

### Movement
An intra-hospital transfer with `partOf` pointing to a Stay.

**Examples:** Service transfer, ICU admission

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `id` | string | Auto | Unique ID |
| `status` | code | ✅ Yes | planned, in-progress, finished, cancelled |
| `class` | Coding | ✅ Yes | IMP (inpatient), AMB (ambulatory), EMER (emergency) |
| `subject` | Reference | ✅ Yes | Related patient |
| `period.start` | dateTime | ✅ Yes | Admission date/time |
| `period.end` | dateTime | No | Discharge date/time |
| `serviceProvider` | Reference | No | Unit/Department where the movement takes place (`Organization/unit-{id}` or `Organization/department-{id}`) |
| `partOf` | Reference | No | Parent Stay (for Movement only) |

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `date` | date | Admission date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01&date=le2024-12-31` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Encounters

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/encounter/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/encounter/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} encounters")
    for entry in bundle.get("entry", []):
        enc = entry["resource"]
        print(f"  ID {enc['id']}: {enc['status']} - {enc['class']['code']}")
    ```

## Retrieve a Stay

=== "curl"
    ```bash
    # Direct Stay access
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/encounter/stay/789/
    
    # Automatic search (searches Stay then Movement)
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/encounter/789/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/encounter/stay/789/", headers=headers)
    stay = response.json()
    
    print(f"Status: {stay['status']}")
    print(f"Start: {stay['period']['start']}")
    if 'end' in stay.get('period', {}):
        print(f"End: {stay['period']['end']}")
    ```

## Accepted ID Formats

The API accepts multiple formats to retrieve an encounter:

```bash
# Direct Stay access
GET /v4.3.0/encounter/stay/789/

# Direct Movement access
GET /v4.3.0/encounter/movement/456/

# Automatic search (searches Stay then Movement)
GET /v4.3.0/encounter/789/
```

## Status Codes

| Code | Description | Usage |
|------|-------------|-------|
| `planned` | Planned stay | Future appointment |
| `in-progress` | In progress | Patient hospitalized |
| `finished` | Completed | Discharged |
| `cancelled` | Cancelled | Cancelled appointment |

## Encounter Classes

| Code | Display | Description |
|------|---------|-------------|
| `IMP` | Inpatient | Complete hospitalization |
| `AMB` | Ambulatory | Outpatient (consultation) |
| `EMER` | Emergency | Emergency |
| `HH` | Home Health | Home hospitalization |

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Organization](organization.md) - Via `serviceProvider`
- [DocumentReference](documentreference.md) - Stay documents

<div class="quick-links">
  <a href="../documentreference/">📄 DocumentReference</a>
  <a href="../../guides/patient-journey/">📖 Guide: Trace Patient Journey</a>
</div>
