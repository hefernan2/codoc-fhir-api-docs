---
title: Organization
---

# Organization - Hospital Structure

The **Organization** resource represents the hospital's organizational hierarchy.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/organization/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/organization/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/organization/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/organization/{id}/</span>
</div>

## Organization Types

| Type | Code | Description | Possible Parent |
|------|------|-------------|------------------|
| **Instance** | `instance` | Hospital group | - (root) |
| **Site** | `site` | Campus/facility | Instance or root |
| **Department** | `department` | Medical service | Instance or Site |
| **Unit** | `unit` | Care unit | Department |

## Supported Hierarchies

```
Instance → Site → Department → Unit
Instance → Department → Unit
Site → Department → Unit
```

## Field Structure

| FHIR Field | Type | Required | Codoc Mapping | Description |
|------------|------|--------|---------------|-------------|
| `id` | string | Auto | `id` | Generated unique ID |
| `identifier[]` | Identifier | ✅ Yes | `code` | Organization code |
| `type[]` | CodeableConcept | ✅ Yes | Type (Site/Dept/Unit) | Organization type |
| `name` | string | ✅ Yes | `name` | Full name |
| `partOf` | Reference | Depends on type | `parent_id` | Parent organization |
| `extension[period]` | Extension | No | `start_date`, `end_date` | Activity period |
| `extension[*_count]` | Extension | No | Counters | Aggregated statistics |

## Create a Site (Hospital)

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [
          {
            "system": "http://codoc.com/fhir/organization",
            "value": "CHU_PARIS"
          }
        ],
        "type": [
          {
            "coding": [
              {
                "system": "http://codoc.com/fhir/organization-type",
                "code": "site",
                "display": "Site"
              }
            ]
          }
        ],
        "name": "Paris University Hospital"
      }'
    ```

=== "Python"
    ```python
    import requests
    
    site = {
        "resourceType": "Organization",
        "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "CHU_PARIS"}],
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "site"}]}],
        "name": "Paris University Hospital"
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/organization/", json=site)
    site_id = response.json()["id"]
    print(f"Site created with ID: {site_id}")
    ```

**Response (201 Created):**
```json
{
  "resourceType": "Organization",
  "id": "1",
  "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "CHU_PARIS"}],
  "type": [{"coding": [{"code": "site", "display": "Site"}]}],
  "name": "Paris University Hospital"
}
```

## Create a Department

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO"}],
        "type": [
          {
            "coding": [
              {
                "system": "http://codoc.com/fhir/organization-type",
                "code": "department"
              }
            ]
          }
        ],
        "name": "Cardiology Department",
        "partOf": {
          "reference": "Organization/1"
        }
      }'
    ```

=== "Python"
    ```python
    department = {
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO"}],
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "department"}]}],
        "name": "Cardiology Department",
        "partOf": {"reference": f"Organization/{site_id}"}
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/organization/", json=department)
    dept_id = response.json()["id"]
    ```

## Create a Care Unit

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO_ICU"}],
        "type": [{"coding": [{"code": "unit"}]}],
        "name": "Cardiology Intensive Care Unit",
        "partOf": {"reference": "Organization/2"}
      }'
    ```

!!! info "Hierarchy Validation"
    The API automatically validates that:
    
    - A **department** has an **instance** or **site** parent
    - A **unit** has a **department** parent
    - A **site** can be root or have an **instance** parent

## With Activity Period

```json
{
  "resourceType": "Organization",
  "identifier": [{"value": "CARDIO"}],
  "type": [{"coding": [{"code": "department"}]}],
  "name": "Cardiology Department",
  "partOf": {"reference": "Organization/1"},
  "extension": [
    {
      "url": "http://codoc.com/fhir/extension/period",
      "valuePeriod": {
        "start": "2020-01-01T00:00:00Z",
        "end": "2025-12-31T23:59:59Z"
      }
    }
  ]
}
```

## Retrieve an Organization

=== "curl"
    ```bash
    curl http://localhost:8000/v4.3.0/organization/2/
    ```

=== "Python"
    ```python
    response = requests.get("http://localhost:8000/v4.3.0/organization/2/")
    org = response.json()
    
    print(f"Type: {org['type'][0]['coding'][0]['code']}")
    print(f"Name: {org['name']}")
    if 'partOf' in org:
        print(f"Parent: {org['partOf']['reference']}")
    ```

## Common Errors

### Error 400 - Invalid Type

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "Invalid organization type. Must be: instance, site, department, unit"
  }]
}
```

### Error 400 - Parent Required

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "required",
    "diagnostics": "Organization partOf is required for department"
  }]
}
```

**Solution:** Departments and units must have a `partOf`.

### Error 400 - Non-existent Parent

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "not-found",
    "diagnostics": "Site with ID 999 does not exist"
  }]
}
```

**Solution:** Verify that the ID in `partOf.reference` exists.

### Error 400 - Invalid Hierarchy

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "Unit parent must be a Department, got Site"
  }]
}
```

**Solution:** Respect hierarchies: Unit → Department → Site/Instance.

## Use Cases

### Complete Hierarchy

```python
# 1. Create a site
site = requests.post("/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"value": "HOSP001"}],
    "type": [{"coding": [{"code": "site"}]}],
    "name": "Saint-Louis Hospital"
}).json()

# 2. Create a department
dept = requests.post("/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"value": "CARDIO"}],
    "type": [{"coding": [{"code": "department"}]}],
    "name": "Cardiology",
    "partOf": {"reference": f"Organization/{site['id']}"}
}).json()

# 3. Create a unit
unit = requests.post("/v4.3.0/organization/", json={
    "resourceType": "Organization",
    "identifier": [{"value": "CARDIO_A"}],
    "type": [{"coding": [{"code": "unit"}]}],
    "name": "Unit A - Cardiology",
    "partOf": {"reference": f"Organization/{dept['id']}"}
}).json()
```

### Navigate the Hierarchy

```python
# Retrieve a unit
unit = requests.get(f"/v4.3.0/organization/{unit_id}/").json()

# Get parent department
dept_ref = unit['partOf']['reference']  # "Organization/2"
dept_id = dept_ref.split('/')[-1]
dept = requests.get(f"/v4.3.0/organization/{dept_id}/").json()

# Get parent site
site_ref = dept['partOf']['reference']
site_id = site_ref.split('/')[-1]
site = requests.get(f"/v4.3.0/organization/{site_id}/").json()

print(f"{site['name']} → {dept['name']} → {unit['name']}")
```

## Related Resources

- [Patient](patient.md) - Via `managingOrganization`
- [Encounter](encounter.md) - Via `serviceProvider`
- [DocumentReference](documentreference.md) - Via `author`

## Next Steps

<div class="quick-links">
  <a href="../encounter/">🛏️ Encounter</a>
  <a href="../../guides/organization-hierarchy/">📖 Guide: Navigate the Hierarchy</a>
</div>
