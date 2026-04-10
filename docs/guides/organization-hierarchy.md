---
title: Explore Hospital Hierarchy
---

# Explore Hospital Hierarchy

This guide explains how to navigate and visualize your hospital's organizational structure.

## Supported Structure

```
Site (Hospital)
└── Department (Medical department)
    └── Unit (Care unit)
```

## Step 1: List All Organizations

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/organization/?_count=50"
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "{API_URL}"
    HEADERS = {"Authorization": "Api-Key {API_KEY}"}
    
    organizations = requests.get(
        f"{BASE_URL}/v4.3.0/organization/",
        params={"_count": 50},
        headers=HEADERS
    ).json()
    
    print(f"Total organizations: {organizations['total']}")
    for entry in organizations.get("entry", []):
        org = entry["resource"]
        org_type = org["type"][0]["coding"][0]["code"]
        parent = org.get("partOf", {}).get("reference", "root")
        print(f"  [{org_type}] {org['name']} (ID {org['id']}) → parent: {parent}")
    ```

## Step 2: Retrieve a Specific Organization

=== "Python"
    ```python
    # Retrieve a site by ID
    org = requests.get(f"{BASE_URL}/v4.3.0/organization/site-1/", headers=HEADERS).json()
    
    type_code = org["type"][0]["coding"][0]["code"]
    icon = {"site": "🏥", "department": "🏢", "unit": "🛏️"}.get(type_code, "📍")
    
    print(f"{icon} {org['name']} (ID: {org['id']}, Type: {type_code})")
    if "partOf" in org:
        print(f"  Parent: {org['partOf']['reference']}")
    ```

## Step 3: Navigate the Parent Chain

To navigate up the hierarchy, follow the `partOf` reference:

=== "Python"
    ```python
    def get_parent_chain(org_id):
        """Retrieve complete parent chain for an organization."""
        chain = []
        current_id = org_id
        
        while current_id:
            org = requests.get(f"{BASE_URL}/v4.3.0/organization/{current_id}/", headers=HEADERS).json()
            chain.append({
                "id": org["id"],
                "name": org["name"],
                "type": org["type"][0]["coding"][0]["code"]
            })
            
            # Check if there is a parent
            if "partOf" in org:
                current_id = org["partOf"]["reference"].split("/")[-1]
            else:
                break
        
        return chain
    
    # Example: find parents of a unit
    unit_id = "unit-5"
    chain = get_parent_chain(unit_id)
    
    print(f"\n🔗 Hierarchical chain for unit ID {unit_id}:")
    for i, org in enumerate(chain):
        indent = "  " * i
        print(f"{indent}→ {org['name']} ({org['type']})")
    ```

**Example output:**
```
🔗 Hierarchical chain for unit ID 5:
→ Cardiology - Unit A - Intensive Care (unit)
  → Cardiology Department (department)
    → CHU Paris - Saint-Antoine Site (site)
```

## Step 4: Visualize the Hierarchy

=== "Python"
    ```python
    def print_hierarchy(org_id, level=0):
        """Display organization hierarchy."""
        org = requests.get(f"{BASE_URL}/v4.3.0/organization/{org_id}/", headers=HEADERS).json()
        
        indent = "  " * level
        type_code = org["type"][0]["coding"][0]["code"]
        icon = {"site": "🏥", "department": "🏢", "unit": "🛏️"}.get(type_code, "📍")
        
        print(f"{indent}{icon} {org['name']} (ID: {org['id']}, Type: {type_code})")
    
    # Display a site and its known children
    print("\n🏥 HOSPITAL HIERARCHY")
    print("=" * 60)
    
    # Retrieve the root organization
    site = requests.get(f"{BASE_URL}/v4.3.0/organization/site-1/", headers=HEADERS).json()
    print_hierarchy(site["id"])
    ```

## Key Points

!!! tip "Navigation Direction"
    The API provides **upward navigation** (child → parent) via `partOf`. To list children, retrieve all organizations and filter by `partOf`.

!!! info "Organization Types"
    - `instance` — Hospital group (root)
    - `site` — Campus/facility
    - `department` — Medical service
    - `unit` — Care unit

## Next Steps

- [Query a Patient Record](patient-record.md)
- [Trace Patient Journey](patient-journey.md)
