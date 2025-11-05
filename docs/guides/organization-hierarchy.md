---
title: Navigate Hospital Hierarchy
---

# Navigate Hospital Hierarchy

This guide explains how to create and organize your hospital's organizational structure.

## Supported Structure

```
Site (Hospital)
└── Department (Medical department)
    └── Unit (Care unit)
```

## Step 1: Create a Site (Hospital)

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"value": "CHU_PARIS"}],
        "type": [{"coding": [{"code": "site"}]}],
        "name": "CHU Paris - Saint-Antoine Site"
      }'
    ```

=== "Python"
    ```python
    import requests
    
    BASE_URL = "http://localhost:8000/v4.3.0"
    
    site = requests.post(f"{BASE_URL}/organization/", json={
        "resourceType": "Organization",
        "identifier": [{"value": "CHU_PARIS"}],
        "type": [{"coding": [{"code": "site"}]}],
        "name": "CHU Paris - Saint-Antoine Site"
    }).json()
    
    site_id = site["id"]
    print(f"✅ Site created: {site['name']} (ID {site_id})")
    ```

## Step 2: Create Departments

=== "Python"
    ```python
    # Cardiology Department
    cardio = requests.post(f"{BASE_URL}/organization/", json={
        "resourceType": "Organization",
        "identifier": [{"value": "CARDIO"}],
        "type": [{"coding": [{"code": "department"}]}],
        "name": "Cardiology Department",
        "partOf": {"reference": f"Organization/{site_id}"}
    }).json()
    cardio_id = cardio["id"]
    
    # Neurology Department
    neuro = requests.post(f"{BASE_URL}/organization/", json={
        "resourceType": "Organization",
        "identifier": [{"value": "NEURO"}],
        "type": [{"coding": [{"code": "department"}]}],
        "name": "Neurology Department",
        "partOf": {"reference": f"Organization/{site_id}"}
    }).json()
    neuro_id = neuro["id"]
    
    print(f"✅ Departments created: Cardiology (ID {cardio_id}), Neurology (ID {neuro_id})")
    ```

!!! warning "partOf Constraint"
    A **department** must always have a `partOf` pointing to a site or instance.

## Step 3: Create Care Units

=== "Python"
    ```python
    # Cardiology Units
    units_cardio = []
    for name in ["Unit A - Intensive Care", "Unit B - Hospitalization", "Unit C - Day Hospital"]:
        unit = requests.post(f"{BASE_URL}/organization/", json={
            "resourceType": "Organization",
            "identifier": [{"value": f"CARDIO_{name[5]}"}],
            "type": [{"coding": [{"code": "unit"}]}],
            "name": f"Cardiology - {name}",
            "partOf": {"reference": f"Organization/{cardio_id}"}
        }).json()
        units_cardio.append(unit)
        print(f"✅ Unit created: {unit['name']} (ID {unit['id']})")
    
    # Neurology Units
    units_neuro = []
    for name in ["Stroke Unit", "Epilepsy Unit"]:
        unit = requests.post(f"{BASE_URL}/organization/", json={
            "resourceType": "Organization",
            "identifier": [{"value": f"NEURO_{name.split()[0].upper()}"}],
            "type": [{"coding": [{"code": "unit"}]}],
            "name": f"Neurology - {name}",
            "partOf": {"reference": f"Organization/{neuro_id}"}
        }).json()
        units_neuro.append(unit)
        print(f"✅ Unit created: {unit['name']} (ID {unit['id']})")
    ```

!!! warning "partOf Constraint"
    A **unit** must always have a `partOf` pointing to a department.

## Step 4: Visualize the Hierarchy

=== "Python"
    ```python
    def print_hierarchy(org_id, level=0):
        """Display organization hierarchy recursively."""
        org = requests.get(f"{BASE_URL}/organization/{org_id}/").json()
        
        indent = "  " * level
        type_code = org["type"][0]["coding"][0]["code"]
        icon = {"site": "🏥", "department": "🏢", "unit": "🛏️"}.get(type_code, "📍")
        
        print(f"{indent}{icon} {org['name']} (ID: {org['id']}, Type: {type_code})")
    
    # Display complete hierarchy
    print("\n🏥 HOSPITAL HIERARCHY")
    print("=" * 60)
    print_hierarchy(site_id)
    
    # Display departments
    for dept_id in [cardio_id, neuro_id]:
        print_hierarchy(dept_id, level=1)
        
        # Display department units
        dept = requests.get(f"{BASE_URL}/organization/{dept_id}/").json()
        # Note: The API does not automatically return children,
        # you will need to retrieve them via your local variables
    ```

## Step 5: Navigate Upward (Parent)

=== "Python"
    ```python
    def get_parent_chain(org_id):
        """Retrieve complete parent chain."""
        chain = []
        current_id = org_id
        
        while current_id:
            org = requests.get(f"{BASE_URL}/organization/{current_id}/").json()
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
    unit_id = units_cardio[0]["id"]
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

## Complete Script

```python
import requests

BASE_URL = "http://localhost:8000/v4.3.0"

def create_organization(code, org_type, name, parent_id=None):
    """Create an organization with validation."""
    data = {
        "resourceType": "Organization",
        "identifier": [{"value": code}],
        "type": [{"coding": [{"code": org_type}]}],
        "name": name
    }
    
    if parent_id:
        data["partOf"] = {"reference": f"Organization/{parent_id}"}
    
    response = requests.post(f"{BASE_URL}/organization/", json=data)
    org = response.json()
    
    if response.status_code == 201:
        print(f"✅ {org_type.capitalize()} created: {name} (ID {org['id']})")
        return org
    else:
        print(f"❌ Error: {org}")
        return None

# 1. Create the site
site = create_organization("CHU_PARIS", "site", "CHU Paris - Saint-Antoine Site")
site_id = site["id"]

# 2. Create departments
cardio = create_organization("CARDIO", "department", "Cardiology Department", site_id)
neuro = create_organization("NEURO", "department", "Neurology Department", site_id)

# 3. Create Cardiology units
cardio_units = [
    create_organization("CARDIO_A", "unit", "Cardiology - Unit A - Intensive Care", cardio["id"]),
    create_organization("CARDIO_B", "unit", "Cardiology - Unit B - Hospitalization", cardio["id"]),
    create_organization("CARDIO_C", "unit", "Cardiology - Unit C - Day Hospital", cardio["id"])
]

# 4. Create Neurology units
neuro_units = [
    create_organization("NEURO_STROKE", "unit", "Neurology - Stroke Unit", neuro["id"]),
    create_organization("NEURO_EPIL", "unit", "Neurology - Epilepsy Unit", neuro["id"])
]

print(f"\n✅ Complete hierarchy created!")
print(f"   1 Site → 2 Departments → 5 Units")
```

## Advanced Use Cases

### Create Hierarchy with Instances

```python
# Level 0: Instance (Hospital group)
instance = create_organization("GH_PARIS", "instance", "Paris Hospital Group")

# Level 1: Sites
site1 = create_organization("SITE_A", "site", "Site A - Pitié-Salpêtrière", instance["id"])
site2 = create_organization("SITE_B", "site", "Site B - Saint-Antoine", instance["id"])

# Level 2: Departments
dept = create_organization("CARDIO", "department", "Cardiology", site1["id"])

# Level 3: Units
unit = create_organization("CARDIO_A", "unit", "Cardiology - Unit A", dept["id"])
```

### Update an Organization

```python
# Change department name
cardio_updated = requests.put(f"{BASE_URL}/organization/{cardio_id}/", json={
    "resourceType": "Organization",
    "identifier": [{"value": "CARDIO"}],
    "type": [{"coding": [{"code": "department"}]}],
    "name": "Cardiology and Vascular Diseases Department",
    "partOf": {"reference": f"Organization/{site_id}"}
}).json()

print(f"✅ Department updated: {cardio_updated['name']}")
```

## Key Points

!!! tip "Creation Order"
    Always create from top to bottom: Site → Department → Unit

!!! warning "Hierarchical Validation"
    The API automatically validates that hierarchies are correct (e.g., a unit cannot point to a site)

!!! info "Deletion"
    Deleting an organization may fail if resources reference it (patients, stays, etc.)

## Next Steps

- [Create a Patient Record](patient-record.md)
- [Track Patient Journey](patient-journey.md)
