---
title: Organization
---

# Organization - Hospital Structure

The **Organization** resource represents the hospital's organizational hierarchy.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/organization/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

No filter parameters are available for this resource. The list endpoint returns all organizations.

## List Organizations

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/organization/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/organization/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} organizations")
    for entry in bundle.get("entry", []):
        org = entry["resource"]
        org_type = org["type"][0]["coding"][0]["code"]
        print(f"  [{org_type}] {org['name']} (ID {org['id']})")
    ```

## Retrieve an Organization

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/organization/site-1/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/organization/site-1/", headers=headers)
    org = response.json()
    
    print(f"Type: {org['type'][0]['coding'][0]['code']}")
    print(f"Name: {org['name']}")
    if 'partOf' in org:
        print(f"Parent: {org['partOf']['reference']}")
    ```

**Response (200 OK):**
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

## Navigate the Hierarchy

To navigate up the hierarchy, follow the `partOf` reference:

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    
    def get_parent_chain(org_id):
        """Retrieve complete parent chain."""
        chain = []
        current_id = org_id
        
        while current_id:
            org = requests.get(f"{API_URL}/v4.3.0/organization/{current_id}/", headers=headers).json()
            chain.append({
                "id": org["id"],
                "name": org["name"],
                "type": org["type"][0]["coding"][0]["code"]
            })
            
            if "partOf" in org:
                current_id = org["partOf"]["reference"].split("/")[-1]
            else:
                break
        
        return chain
    
    # Example: find parents of a unit
    chain = get_parent_chain("unit-5")
    for i, org in enumerate(chain):
        print("  " * i + f"→ {org['name']} ({org['type']})")
    ```

**Example output:**
```
→ Cardiology - Unit A (unit)
  → Cardiology Department (department)
    → CHU Paris - Saint-Antoine Site (site)
```

## Related Resources

- [Patient](patient.md) - Via `managingOrganization`
- [Encounter](encounter.md) - Via `serviceProvider`
- [DocumentReference](documentreference.md) - Via `author`

## Next Steps

<div class="quick-links">
  <a href="../encounter/">🛏️ Encounter</a>
  <a href="../../guides/organization-hierarchy/">📖 Guide: Explore the Hierarchy</a>
</div>
