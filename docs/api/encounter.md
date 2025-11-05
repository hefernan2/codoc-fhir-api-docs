---
title: Encounter
---

# Encounter - Stays and Movements

The **Encounter** resource represents hospital stays and intra-hospital movements.

## Endpoints

<div class="api-endpoint">
  <span class="http-method post">POST</span>
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
<div class="api-endpoint">
  <span class="http-method patch">PATCH</span>
  <span class="endpoint-path">/v4.3.0/encounter/stay/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/encounter/stay/{id}/</span>
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
| `serviceProvider` | Reference | No | Responsible organization |
| `partOf` | Reference | No | Parent Stay (for Movement only) |
| `location[]` | BackboneElement | No | Location(s) |

## Create a Stay

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/encounter/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Encounter",
        "identifier": [{"use": "usual", "value": "ADM001"}],
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": "Patient/1"},
        "serviceProvider": {"reference": "Organization/department-1"},
        "period": {"start": "2024-01-15T08:00:00Z"},
        "hospitalization": {
          "admitSource": {"coding": [{"code": "H"}]},
          "dischargeDisposition": {"coding": [{"code": "01"}]}
        }
      }'
    ```

=== "Python"
    ```python
    stay = {
        "resourceType": "Encounter",
        "identifier": [{"use": "usual", "value": "ADM001"}],
        "status": "in-progress",
        "class": {"code": "IMP"},
        "subject": {"reference": "Patient/1"},
        "serviceProvider": {"reference": "Organization/department-1"},
        "period": {"start": "2024-01-15T08:00:00Z"},
        "hospitalization": {
          "admitSource": {"coding": [{"code": "H"}]},
          "dischargeDisposition": {"coding": [{"code": "01"}]}
    }
    }
    
    response = requests.post("{API_URL}/v4.3.0/encounter/", json=stay)
    stay_id = response.json()["id"]
    ```

## Create a Movement

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/encounter/ \
      -H "Content-Type: application/json" \
      -d '{
            "resourceType": "Encounter",
            "identifier": [{"use": "usual", "value": "MOV001"}],
            "status": "in-progress",
            "class": {"code": "IMP"},
            "subject": {"reference": "Patient/1"},
            "serviceProvider": {"reference": "Organization/unit-1"},
            "period": {"start": "2025-01-20T10:00:00Z"},
            "partOf": {"reference": "Encounter/1"},
            "hospitalization": {
            "admitSource": {"coding": [{"code": "H"}]},
            "dischargeDisposition": {"coding": [{"code": "01"}]}
          }
    }'
    ```

## Close a Stay

=== "curl"
    ```bash
    curl -X PATCH {API_URL}/v4.3.0/encounter/stay/1/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Encounter",
        "status": "finished",
        "subject": {"reference": "Patient/1"},
        "period": {"start": "2024-01-15T10:00:00Z", "end": "2024-01-20T16:00:00Z"}
      }'
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

## Common Errors

### Error 400 - Non-existent Patient

```json
{
  "issue": [{
    "severity": "error",
    "diagnostics": "Patient with ID 999 does not exist"
  }]
}
```

### Error 400 - Parent Stay Not Found

```json
{
  "issue": [{
    "severity": "error",
    "diagnostics": "Stay with ID 999 does not exist"
  }]
}
```

**Solution:** To create a Movement, ensure the parent Stay exists.

## Complete Use Case

### Typical Patient Journey

```python
# Patient Journey: Hospital → Department → Unit

# Prerequisites: Create the organization hierarchy
site = requests.post("{API_URL}/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"use": "usual", "value": "HOSP001"}],
    "name": "Paris University Hospital",
    "type": [{"coding": [{"code": "prov"}]}]
}).json()
site_id = site["id"]

department = requests.post("{API_URL}/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"use": "usual", "value": "CARD001"}],
    "name": "Cardiology Department",
    "type": [{"coding": [{"code": "dept"}]}],
    "partOf": {"reference": f"organization/{site_id}"}
}).json()
dept_id = department["id"]

unit = requests.post("{API_URL}/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"use": "usual", "value": "ICU001"}],
    "name": "Intensive Care Unit",
    "type": [{"coding": [{"code": "team"}]}],
    "partOf": {"reference": f"organization/{dept_id}"}
}).json()
unit_id = unit["id"]

# 1. Emergency admission
stay = requests.post("{API_URL}/v4.3.0/encounter/", json={
    "resourceType": "Encounter",
    "identifier": [{"use": "usual", "value": "ADM001"}],
    "status": "in-progress",
    "class": {"code": "EMER"},
    "subject": {"reference": "Patient/123"},
    "serviceProvider": {"reference": f"Organization/{site_id}"},
    "period": {"start": "2024-01-15T08:00:00Z"}
}).json()
stay_id = stay["id"]

# 2. Transfer to Cardiology Department
movement1 = requests.post("{API_URL}/v4.3.0/encounter/", json={
    "resourceType": "Encounter",
    "identifier": [{"use": "usual", "value": "MOV001"}],
    "status": "in-progress",
    "class": {"code": "IMP"},
    "subject": {"reference": "Patient/123"},
    "serviceProvider": {"reference": f"Organization/{dept_id}"},
    "partOf": {"reference": f"Encounter/{stay_id}"},
    "period": {"start": "2024-01-15T14:00:00Z"}
}).json()

# 3. Transfer to ICU (Intensive Care Unit)
movement2 = requests.post("{API_URL}/v4.3.0/encounter/", json={
    "resourceType": "Encounter",
    "identifier": [{"use": "usual", "value": "MOV002"}],
    "status": "in-progress",
    "class": {"code": "IMP"},
    "subject": {"reference": "Patient/123"},
    "serviceProvider": {"reference": f"Organization/{unit_id}"},
    "partOf": {"reference": f"Encounter/{stay_id}"},
    "period": {"start": "2024-01-17T02:00:00Z"}
}).json()

# 4. Discharge
requests.patch("{API_URL}/v4.3.0/encounter/stay/{stay_id}/", json={
    "resourceType": "Encounter",
    "status": "finished",
    "period": {
        "start": "2024-01-15T08:00:00Z",
        "end": "2024-01-20T10:00:00Z"
    }
})
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Organization](organization.md) - Via `serviceProvider` and `location`
- [DocumentReference](documentreference.md) - Stay documents

<div class="quick-links">
  <a href="../documentreference/">📄 DocumentReference</a>
  <a href="../../guides/patient-journey/">📖 Guide: Patient Journey</a>
</div>
