---
title: Quick Start
---

# Quick Start - First API Call

This guide shows you how to query the FHIR API in less than 5 minutes.

## Important: Use Version 4.3.0

⚠️ **Production:** Only version `v4.3.0` is currently available in production. Version `v5.0.0` is in development and not usable yet. Always use `/v4.3.0/` in your requests.

## Prerequisites

- ✅ Codoc FHIR API installed and started
- ✅ HTTP client installed (curl, Postman, or HTTP library)

## 1. Verify the Connection

Start by verifying that the API responds:

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/metadata/
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/metadata/", headers=headers)
    print(response.status_code)  # Should display 200
    print(response.json()["resourceType"])  # "CapabilityStatement"
    ```

=== "JavaScript"
    ```javascript
    fetch("{API_URL}/v4.3.0/metadata/")
      .then(response => response.json())
      .then(data => {
        console.log(data.resourceType);  // "CapabilityStatement"
        console.log(data.fhirVersion);   // "4.3.0"
      });
    ```

**Expected response:** HTTP 200 with a FHIR `CapabilityStatement` object.

## 2. List Patients

Retrieve a paginated list of patients:

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/patient/?_count=10"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/patient/",
        params={"_count": 10},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} patients")
    print(f"Page: {len(bundle.get('entry', []))} results")
    
    for entry in bundle.get("entry", []):
        patient = entry["resource"]
        print(f"  - ID {patient['id']}: {patient.get('name', [{}])[0].get('family', 'N/A')}")
    ```

=== "JavaScript"
    ```javascript
    fetch("{API_URL}/v4.3.0/patient/?_count=10")
      .then(response => response.json())
      .then(bundle => {
        console.log(`Total: ${bundle.total} patients`);
        bundle.entry?.forEach(entry => {
          const p = entry.resource;
          console.log(`  - ID ${p.id}: ${p.name?.[0]?.family ?? 'N/A'}`);
        });
      });
    ```

**Expected response:**

```json
{
  "resourceType": "Bundle",
  "type": "searchset",
  "total": 245,
  "link": [
    {"relation": "self", "url": "{API_URL}/v4.3.0/patient/?_count=10"},
    {"relation": "next", "url": "{API_URL}/v4.3.0/patient/?_count=10&page=2"}
  ],
  "entry": [
    {"resource": {"resourceType": "Patient", "id": "1", ...}},
    {"resource": {"resourceType": "Patient", "id": "2", ...}}
  ]
}
```

## 3. Retrieve a Patient

Use the `id` to retrieve a specific patient:

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/patient/1/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/patient/1/", headers=headers)
    patient = response.json()
    
    print(f"Last name: {patient['name'][0]['family']}")
    print(f"First name: {patient['name'][0]['given'][0]}")
    print(f"Birth date: {patient['birthDate']}")
    ```

=== "JavaScript"
    ```javascript
    fetch("{API_URL}/v4.3.0/patient/1/")
      .then(response => response.json())
      .then(patient => {
        console.log(`Last name: ${patient.name[0].family}`);
        console.log(`First name: ${patient.name[0].given[0]}`);
        console.log(`Birth date: ${patient.birthDate}`);
      });
    ```

## 4. Explore Related Resources

Once you have a patient ID, you can retrieve their associated data:

=== "Python"
    ```python
    patient_id = 1
    
    # Hospital stays
    encounters = requests.get(f"{API_URL}/v4.3.0/encounter/?_count=20", headers=headers).json()
    
    # Observations (lab results)
    observations = requests.get(f"{API_URL}/v4.3.0/observation/?_count=20", headers=headers).json()
    
    # Clinical documents
    documents = requests.get(f"{API_URL}/v4.3.0/documentreference/?_count=20", headers=headers).json()
    
    print(f"Stays found: {encounters['total']}")
    print(f"Observations found: {observations['total']}")
    print(f"Documents found: {documents['total']}")
    ```

## Read Operations Summary

| Operation | HTTP Method | Endpoint |
|-----------|-------------|----------|
| **List** | GET | `/v4.3.0/{resource}/` |
| **Read** | GET | `/v4.3.0/{resource}/{id}/` |
| **Paginate** | GET | `/v4.3.0/{resource}/?_count=20&page=2` |

## HTTP Status Codes

| Code | Meaning | Example |
|------|---------|----------|
| **200** | OK - Success | Successful GET |
| **401** | Unauthorized - Authentication required | Missing or invalid credentials |
| **403** | Forbidden - Insufficient permissions | Valid credentials but no read access |
| **404** | Not Found - Resource not found | Non-existent ID |
| **429** | Too Many Requests - Rate limit reached | Rate limit exceeded (limits not yet finalized) |
| **500** | Internal Server Error | Server error |

## Next Steps

Now that you've mastered the basics, explore:

<div class="quick-links">
  <a href="../../api/">📚 Complete API Reference</a>
  <a href="../../guides/">📖 Practical Guides</a>
</div>
