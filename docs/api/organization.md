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
    curl -X POST {API_URL}/v4.3.0/organization/ \
      -H 'Content-Type: application/json' \
      -d '{
            "resourceType": "Organization",
            "identifier": [{"use": "usual", "value":  "HOSP001"}],
            "name": "Paris University Hospital",
            "type": [{"coding": [{"code": "prov"}]}]
    }'
    ```

=== "Python"
    ```python
    import requests
    
    site = {
        "resourceType": "Organization",
        "identifier": [{"use": "usual", "value":  "HOSP001"}],
        "name": "Paris University Hospital",
        "type": [{"coding": [{"code": "prov"}]}]
    }
    
    response = requests.post("{API_URL}/v4.3.0/organization/", json=site)
    site_id = response.json()["id"]
    print(f"Site created with ID: {site_id}")
    ```

**Response (201 Created):**
```json
{
  "resourceType":"Organization",
  "id":"site-1",
  "identifier":
  [
    {
      "use":"official",
      "value":"site-1"
    },
    {
      "use":"usual",
      "value":"HOSP001"
    }
  ],
  "type":
  [
    {
      "coding":
      [
        {
          "system":"http://terminology.hl7.org/CodeSystem/organization-type",
          "code":"prov",
          "display":"Healthcare Provider"
        }
      ]
    }
  ], 
  "name":"Paris University Hospital"
}
```

## Create a Department

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/organization/ \
      -H 'Content-Type: application/json' \
      -d '{
            "resourceType": "Organization",
            "identifier": [{"use": "usual", "value": "CARD001"}],
            "name": "Cardiology Department",
            "type": [{"coding": [{"code": "dept"}]}],
            "partOf": {"reference": "organization/site-1"}
      }'
    ```

=== "Python"
    ```python
    department = {
        "resourceType": "Organization",
        "identifier": [{"use": "usual", "value": "CARD001"}],
        "name": "Cardiology Department",
        "type": [{"coding": [{"code": "dept"}]}],
        "partOf": {"reference": "organization/site-1"}
    }
    
    response = requests.post("{API_URL}/v4.3.0/organization/", json=department)
    dept_id = response.json()["id"]
    print(f"Dept created with ID: {dept_id}")

    ```

## Create a Care Unit

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/organization/ \
      -H 'Content-Type: application/json' \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"use": "usual", "value": "ICU001"}],
        "name": "Intensive Care Unit",
        "type": [{"coding": [{"code": "team"}]}],
        "partOf": {"reference": "organization/department-1"}
      }'
    ```
=== "Python"
    ```python
    unit = {
        "resourceType": "Organization",
        "identifier": [{"use": "usual", "value": "ICU001"}],
        "name": "Intensive Care Unit",
        "type": [{"coding": [{"code": "team"}]}],
        "partOf": {"reference": "organization/department-1"}
    }
    
    response = requests.post("{API_URL}/v4.3.0/organization/", json=department)
    unit_id = response.json()["id"]
    print(f"Unit created with ID: {unit_id}")

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
    "identifier": [{"use": "usual", "value": "ICU001"}],
    "name": "Intensive Care Unit",
    "type": [{"coding": [{"code": "team"}]}],
    "partOf": {"reference": "organization/department-1"},
    "extension": [
      {
        "url": "unit_period",
        "valuePeriod": {
          "start": "2025-01-01T00:00:00Z",
          "end": "2025-12-31T23:59:59Z"
        }
      }
    ]
  }
```

## Retrieve an Organization

=== "curl"
    ```bash
    curl {API_URL}/v4.3.0/organization/site-1/
    ```

=== "Python"
    ```python
    response = requests.get("{API_URL}/v4.3.0/organization/site-1/")
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

## Related Resources

- [Patient](patient.md) - Via `managingOrganization`
- [Encounter](encounter.md) - Via `serviceProvider`
- [DocumentReference](documentreference.md) - Via `author`

## Next Steps

<div class="quick-links">
  <a href="../encounter/">🛏️ Encounter</a>
  <a href="../../guides/organization-hierarchy/">📖 Guide: Navigate the Hierarchy</a>
</div>
