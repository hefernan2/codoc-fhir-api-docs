---
title: Quick Start
---

# Quick Start - First API Call

This guide shows you how to make your first FHIR API call in less than 5 minutes.

## Important: Use Version 4.3.0

⚠️ **Production:** Only version `v4.3.0` is currently available in production. Version `v5.0.0` is in development and not usable yet. Always use `/v4.3.0/` in your requests.

## Prerequisites

- ✅ Codoc FHIR API installed and started ([see Installation](installation.md))
- ✅ Server accessible at `http://localhost:8000`
- ✅ HTTP client installed (curl, Postman, or HTTP library)

## 1. Verify the Connection

Start by verifying that the API responds:

=== "curl"
    ```bash
    curl http://localhost:8000/v4.3.0/metadata/
    ```

=== "Python"
    ```python
    import requests
    
    response = requests.get("http://localhost:8000/v4.3.0/metadata/")
    print(response.status_code)  # Should display 200
    print(response.json()["resourceType"])  # "CapabilityStatement"
    ```

=== "JavaScript"
    ```javascript
    fetch("http://localhost:8000/v4.3.0/metadata/")
      .then(response => response.json())
      .then(data => {
        console.log(data.resourceType);  // "CapabilityStatement"
        console.log(data.fhirVersion);   // "4.3.0"
      });
    ```

**Expected response:** HTTP 200 with a FHIR `CapabilityStatement` object.

## 2. Create a Patient

Let's create your first FHIR patient:

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/Patient/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "identifier": [
          {
            "system": "http://codoc.com/fhir/patient/nip",
            "value": "123456789"
          }
        ],
        "name": [
          {
            "family": "Smith",
            "given": ["John", "Michael"]
          }
        ],
        "gender": "male",
        "birthDate": "1980-05-15"
      }'
    ```

=== "Python"
    ```python
    import requests
    
    patient = {
        "resourceType": "Patient",
        "identifier": [{
            "system": "http://codoc.com/fhir/patient/nip",
            "value": "123456789"
        }],
        "name": [{
            "family": "Smith",
            "given": ["John", "Michael"]
        }],
        "gender": "male",
        "birthDate": "1980-05-15"
    }
    
    response = requests.post(
        "http://localhost:8000/v4.3.0/Patient/",
        json=patient,
        headers={"Content-Type": "application/json"}
    )
    
    print(f"Status: {response.status_code}")
    print(f"Patient ID: {response.json()['id']}")
    ```

=== "JavaScript"
    ```javascript
    const patient = {
      resourceType: "Patient",
      identifier: [{
        system: "http://codoc.com/fhir/patient/nip",
        value: "123456789"
      }],
      name: [{
        family: "Smith",
        given: ["John", "Michael"]
      }],
      gender: "male",
      birthDate: "1980-05-15"
    };
    
    fetch("http://localhost:8000/v4.3.0/Patient/", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify(patient)
    })
      .then(response => response.json())
      .then(data => {
        console.log(`Patient created with ID: ${data.id}`);
      });
    ```

**Expected response:**

```json
{
  "resourceType": "Patient",
  "id": "1",
  "identifier": [
    {
      "system": "http://codoc.com/fhir/patient/nip",
      "value": "123456789"
    }
  ],
  "name": [
    {
      "family": "Smith",
      "given": ["John", "Michael"]
    }
  ],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

!!! success "First patient created!"
    Note the returned `id` (here `"1"`), you'll need it for the next steps.

## 3. Retrieve the Patient

Use the `id` to retrieve the patient data:

=== "curl"
    ```bash
    curl http://localhost:8000/v4.3.0/Patient/1/
    ```

=== "Python"
    ```python
    response = requests.get("http://localhost:8000/v4.3.0/Patient/1/")
    patient = response.json()
    
    print(f"Last name: {patient['name'][0]['family']}")
    print(f"First name: {patient['name'][0]['given'][0]}")
    print(f"Birth date: {patient['birthDate']}")
    ```

=== "JavaScript"
    ```javascript
    fetch("http://localhost:8000/v4.3.0/Patient/1/")
      .then(response => response.json())
      .then(patient => {
        console.log(`Last name: ${patient.name[0].family}`);
        console.log(`First name: ${patient.name[0].given[0]}`);
        console.log(`Birth date: ${patient.birthDate}`);
      });
    ```

## 4. Update the Patient

Let's add a phone number:

=== "curl"
    ```bash
    curl -X PATCH http://localhost:8000/v4.3.0/Patient/1/ \
      -H "Content-Type: application/json" \
      -d '{
        "telecom": [
          {
            "system": "phone",
            "value": "01 23 45 67 89",
            "use": "home"
          }
        ]
      }'
    ```

=== "Python"
    ```python
    update = {
        "telecom": [{
            "system": "phone",
            "value": "01 23 45 67 89",
            "use": "home"
        }]
    }
    
    response = requests.patch(
        "http://localhost:8000/v4.3.0/Patient/1/",
        json=update
    )
    
    print(f"Phone added: {response.json()['telecom'][0]['value']}")
    ```

=== "JavaScript"
    ```javascript
    const update = {
      telecom: [{
        system: "phone",
        value: "01 23 45 67 89",
        use: "home"
      }]
    };
    
    fetch("http://localhost:8000/v4.3.0/Patient/1/", {
      method: "PATCH",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify(update)
    })
      .then(response => response.json())
      .then(data => {
        console.log(`Phone: ${data.telecom[0].value}`);
      });
    ```

## 5. Create an Organization Hierarchy

Let's create a hospital with a department:

### 5.1. Create a Site (Hospital)

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/Organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "HOSP001"}],
        "name": "Paris University Hospital",
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "site"}]}]
      }'
    ```

=== "Python"
    ```python
    site = {
        "resourceType": "Organization",
        "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "HOSP001"}],
        "name": "Paris University Hospital",
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "site"}]}]
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/Organization/", json=site)
    site_id = response.json()["id"]
    print(f"Site created with ID: {site_id}")
    ```

**Response:** Note the site `id` (e.g., `"1"`).

### 5.2. Create a Department

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/Organization/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Organization",
        "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "CARDIO"}],
        "name": "Cardiology Department",
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "department"}]}],
        "partOf": {"reference": "Organization/1"}
      }'
    ```

=== "Python"
    ```python
    department = {
        "resourceType": "Organization",
        "identifier": [{"system": "http://codoc.com/fhir/organization", "value": "CARDIO"}],
        "name": "Cardiology Department",
        "type": [{"coding": [{"system": "http://codoc.com/fhir/organization-type", "code": "department"}]}],
        "partOf": {"reference": f"Organization/{site_id}"}
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/Organization/", json=department)
    dept_id = response.json()["id"]
    print(f"Department created with ID: {dept_id}")
    ```

!!! tip "Hierarchy created"
    You now have: **Paris University Hospital** → **Cardiology Department**

## 6. Create an Encounter (Admission)

Let's create an admission for our patient in the cardiology department:

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/Encounter/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Encounter",
        "identifier": [{"system": "http://codoc.com/fhir/encounter", "value": "ADM001"}],
        "status": "in-progress",
        "class": {"code": "IMP", "display": "Inpatient"},
        "subject": {"reference": "Patient/1"},
        "serviceProvider": {"reference": "Organization/2"},
        "period": {"start": "2024-01-15T08:00:00Z"}
      }'
    ```

=== "Python"
    ```python
    encounter = {
        "resourceType": "Encounter",
        "identifier": [{"system": "http://codoc.com/fhir/encounter", "value": "ADM001"}],
        "status": "in-progress",
        "class": {"code": "IMP", "display": "Inpatient"},
        "subject": {"reference": "Patient/1"},
        "serviceProvider": {"reference": f"Organization/{dept_id}"},
        "period": {"start": "2024-01-15T08:00:00Z"}
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/Encounter/", json=encounter)
    print(f"Admission created: {response.json()['id']}")
    ```

## 7. Delete a Resource

If needed, you can delete a resource:

=== "curl"
    ```bash
    curl -X DELETE http://localhost:8000/v4.3.0/Patient/1/
    ```

=== "Python"
    ```python
    response = requests.delete("http://localhost:8000/v4.3.0/Patient/1/")
    print(f"Status: {response.status_code}")  # 204 = success
    ```

!!! warning "Permanent deletion"
    Deletion is **immediate and irreversible**. No trash bin exists.

## CRUD Operations Summary

| Operation | HTTP Method | Endpoint | Body |
|-----------|-------------|----------|------|
| **Create** | POST | `/v4.3.0/Patient/` | FHIR resource JSON |
| **Read** | GET | `/v4.3.0/Patient/123/` | - |
| **Update (complete)** | PUT | `/v4.3.0/Patient/123/` | Complete resource |
| **Update (partial)** | PATCH | `/v4.3.0/Patient/123/` | Fields to modify |
| **Delete** | DELETE | `/v4.3.0/Patient/123/` | - |

## HTTP Status Codes

| Code | Meaning | Example |
|------|---------|----------|
| **200** | OK - Success | Successful GET, PATCH |
| **201** | Created | Successful POST |
| **204** | No Content - Deleted | Successful DELETE |
| **400** | Bad Request - Invalid data | Malformed JSON, missing required field |
| **404** | Not Found - Resource not found | Non-existent ID |
| **405** | Method Not Allowed | GET on list (not supported) |
| **500** | Internal Server Error | Server error |

## Next Steps

Now that you've mastered the basics, explore:

<div class="quick-links">
  <a href="../../api/">📚 Complete API Reference</a>
  <a href="../../guides/">📖 Practical Guides</a>
</div>
