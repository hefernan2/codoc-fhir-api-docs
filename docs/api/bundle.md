---
title: Bundle (Bulk Create)
---

# Bundle - Bulk Create

Create multiple resources in a single HTTP request for optimal performance.

## Overview

The Bundle endpoint allows you to create many resources at once (bulk create) instead of sending individual requests.

**Endpoint:** <span class="http-method post">POST</span> `/v4.3.0/bundle/`

### Why Use Bulk Create?

| Approach | HTTP Requests | SQL Queries | Time | Throughput |
|----------|---------------|-------------|------|------------|
| **Individual** (100 resources) | 100 | 407+ | 6.7s | 15/sec |
| **Bulk (type: transaction)** | 1 | 8 | 0.66s | 150+/sec |
| **Gain** | **-99%** | **-98%** | **-90%** | **10×** |

---

## 3 Simple Rules for Automatic Bulk

When these 3 conditions are met, bulk optimization is **automatically enabled**:

### ✅ Rule 1: Use `"type": "transaction"`

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [...]
}
```

### ✅ Rule 2: At least 5 resources

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [
    {...},  // Resource 1
    {...},  // Resource 2
    {...},  // Resource 3
    {...},  // Resource 4
    {...}   // Resource 5 ← Minimum threshold
  ]
}
```

### ✅ Rule 3: Use `"method": "POST"` (create)

```json
{
  "entry": [
    {
      "request": {
        "method": "POST",
        "url": "procedure"
      },
      "resource": {...}
    }
  ]
}
```

**That's it!** ✅ No extra parameters required (no `?enable_bulk=true`, no special headers).

---

## Bundle Structure

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [
    {
      "request": {
        "method": "POST",
        "url": "procedure"
      },
      "resource": {
        "resourceType": "Procedure",
        "status": "completed",
        "code": {"coding": [{"code": "PROC001"}]},
        "subject": {"reference": "Patient/1"},
        "encounter": {"reference": "Encounter/10"}
      }
    }
  ]
}
```

| Field | Description |
|-------|-------------|
| `resourceType` | Always `"Bundle"` |
| `type` | `"transaction"` (atomic) or `"batch"` (independent) |
| `entry[].request.method` | `"POST"` for create operations |
| `entry[].request.url` | Resource type in lowercase (e.g., `procedure`, `observation`) |
| `entry[].resource` | The FHIR resource to create |

---

## Examples

### Minimal Example - Create 5 Patients

=== "curl"

    ```bash
    curl -X POST {API_URL}/v4.3.0/bundle/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Bundle",
        "type": "transaction",
        "entry": [
          {
            "request": {"method": "POST", "url": "patient"},
            "resource": {
              "resourceType": "Patient",
              "identifier": [{"use": "usual", "value": "IPP001"}],
              "name": [{"family": "Dupont", "given": ["Jean"]}],
              "gender": "male",
              "birthDate": "1980-05-15"
            }
          },
          {
            "request": {"method": "POST", "url": "patient"},
            "resource": {
              "resourceType": "Patient",
              "identifier": [{"use": "usual", "value": "IPP002"}],
              "name": [{"family": "Martin", "given": ["Marie"]}],
              "gender": "female",
              "birthDate": "1985-03-22"
            }
          },
          {
            "request": {"method": "POST", "url": "patient"},
            "resource": {
              "resourceType": "Patient",
              "identifier": [{"use": "usual", "value": "IPP003"}],
              "name": [{"family": "Bernard", "given": ["Pierre"]}],
              "gender": "male",
              "birthDate": "1975-07-10"
            }
          },
          {
            "request": {"method": "POST", "url": "patient"},
            "resource": {
              "resourceType": "Patient",
              "identifier": [{"use": "usual", "value": "IPP004"}],
              "name": [{"family": "Leclerc", "given": ["Sophie"]}],
              "gender": "female",
              "birthDate": "1990-11-08"
            }
          },
          {
            "request": {"method": "POST", "url": "patient"},
            "resource": {
              "resourceType": "Patient",
              "identifier": [{"use": "usual", "value": "IPP005"}],
              "name": [{"family": "Thomas", "given": ["Laurent"]}],
              "gender": "male",
              "birthDate": "1988-01-30"
            }
          }
        ]
      }'
    ```

=== "Python"

    ```python
    import requests

    bundle = {
        "resourceType": "Bundle",
        "type": "transaction",
        "entry": [
            {
                "request": {"method": "POST", "url": "patient"},
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [{"use": "usual", "value": "IPP001"}],
                    "name": [{"family": "Dupont", "given": ["Jean"]}],
                    "gender": "male",
                    "birthDate": "1980-05-15"
                }
            },
            {
                "request": {"method": "POST", "url": "patient"},
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [{"use": "usual", "value": "IPP002"}],
                    "name": [{"family": "Martin", "given": ["Marie"]}],
                    "gender": "female",
                    "birthDate": "1985-03-22"
                }
            },
            {
                "request": {"method": "POST", "url": "patient"},
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [{"use": "usual", "value": "IPP003"}],
                    "name": [{"family": "Bernard", "given": ["Pierre"]}],
                    "gender": "male",
                    "birthDate": "1975-07-10"
                }
            },
            {
                "request": {"method": "POST", "url": "patient"},
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [{"use": "usual", "value": "IPP004"}],
                    "name": [{"family": "Leclerc", "given": ["Sophie"]}],
                    "gender": "female",
                    "birthDate": "1990-11-08"
                }
            },
            {
                "request": {"method": "POST", "url": "patient"},
                "resource": {
                    "resourceType": "Patient",
                    "identifier": [{"use": "usual", "value": "IPP005"}],
                    "name": [{"family": "Thomas", "given": ["Laurent"]}],
                    "gender": "male",
                    "birthDate": "1988-01-30"
                }
            }
        ]
    }

    response = requests.post(
        "{API_URL}/v4.3.0/bundle/",
        json=bundle,
        headers={"Content-Type": "application/json"}
    )

    if response.status_code == 200:
        result = response.json()
        success_count = sum(
            1 for entry in result["entry"]
            if entry["response"]["status"].startswith("201")
        )
        print(f"✅ {success_count}/5 patients created")
        for entry in result["entry"]:
            patient = entry["resource"]
            print(f"  - {patient['name'][0]['family']} {patient['name'][0]['given'][0]} (ID: {patient['id']})")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text)
    ```

### Response

```json
{
  "resourceType": "Bundle",
  "type": "transaction-response",
  "entry": [
    {
      "resource": {
        "resourceType": "Patient",
        "id": "11",
        "identifier": [
          {"use": "official", "value": "11"},
          {"use": "usual", "system": "HIS", "value": "IPP001"}
        ],
        "name": [{"family": "Dupont", "given": ["Jean"]}],
        "gender": "male",
        "birthDate": "1980-05-15"
      },
      "response": {"status": "201 Created", "location": "patient/11"}
    },
    {
      "resource": {
        "resourceType": "Patient",
        "id": "12",
        "identifier": [
          {"use": "official", "value": "12"},
          {"use": "usual", "system": "HIS", "value": "IPP002"}
        ],
        "name": [{"family": "Martin", "given": ["Marie"]}],
        "gender": "female",
        "birthDate": "1985-03-22"
      },
      "response": {"status": "201 Created", "location": "patient/12"}
    },
    {
      "resource": {
        "resourceType": "Patient",
        "id": "13",
        "identifier": [
          {"use": "official", "value": "13"},
          {"use": "usual", "system": "HIS", "value": "IPP003"}
        ],
        "name": [{"family": "Bernard", "given": ["Pierre"]}],
        "gender": "male",
        "birthDate": "1975-07-10"
      },
      "response": {"status": "201 Created", "location": "patient/13"}
    },
    {
      "resource": {
        "resourceType": "Patient",
        "id": "14",
        "identifier": [
          {"use": "official", "value": "14"},
          {"use": "usual", "system": "HIS", "value": "IPP004"}
        ],
        "name": [{"family": "Leclerc", "given": ["Sophie"]}],
        "gender": "female",
        "birthDate": "1990-11-08"
      },
      "response": {"status": "201 Created", "location": "patient/14"}
    },
    {
      "resource": {
        "resourceType": "Patient",
        "id": "15",
        "identifier": [
          {"use": "official", "value": "15"},
          {"use": "usual", "system": "HIS", "value": "IPP005"}
        ],
        "name": [{"family": "Thomas", "given": ["Laurent"]}],
        "gender": "male",
        "birthDate": "1988-01-30"
      },
      "response": {"status": "201 Created", "location": "patient/15"}
    }
  ]
}
```

---

## Transaction vs Batch

### Transaction Mode (`"type": "transaction"`)

**Behavior: All or Nothing**

- ✅ All resources created successfully → Success
- ❌ One resource fails → Rollback all (nothing created)
- 📊 Ideal for: Critical operations, linked data

```json
{
  "resourceType": "Bundle",
  "type": "transaction",
  "entry": [...]
}
```

### Batch Mode (`"type": "batch"`)

**Behavior: Independent**

- ✅ Each resource created independently
- ✅ Continues even if one fails (no rollback)
- 📊 Ideal for: Large imports, non-critical data

```json
{
  "resourceType": "Bundle",
  "type": "batch",
  "entry": [...]
}
```

### Comparison

| Aspect | Transaction | Batch |
|--------|-------------|-------|
| Atomicity | ✅ Yes (all or nothing) | ❌ No (independent) |
| Bulk optimization | ✅ Yes (optimal) | ❌ No (slower) |
| Rollback | ✅ Automatic | ❌ Manual |
| Partial failure | ❌ Fails all | ✅ Creates the rest |
| Performance | ✅ Fast | ⚠️ Slower |
| Use case | Critical operations | Mass imports |

!!! tip "Recommendation"
    Use `"type": "transaction"` for automatic bulk optimization!

---

## Supported Resources & Performance

### Optimized Resources (with reference caching)

| Resource | Throughput | SQL Queries (100 resources) |
|----------|------------|----------------------------|
| **Procedure** | ~150/sec | 8 |
| **Observation** | ~480/sec | 8 |
| **MedicationRequest** | ~600/sec | 8 |
| **DiagnosticReport** | ~400/sec | ~10 |

**Savings:** 407 → 8 SQL queries (98% reduction!)

### Other Resources (Standard performance)

| Resource | Bulk Support | Performance |
|----------|--------------|-------------|
| **Patient** | ✅ Yes | Good |
| **Organization** | ✅ Yes | Good |
| **Encounter** | ✅ Yes | Standard |
| **DocumentReference** | ✅ Yes | Standard |

---

## Best Practices

### Pre-flight Checklist

- [ ] Valid JSON structure (no syntax errors)
- [ ] `type: "transaction"` for bulk optimization
- [ ] At least 5 resources (otherwise individual mode)
- [ ] All resources have `method: "POST"`
- [ ] All references exist (Patient, Encounter, codes)
- [ ] Client timeout configured (recommended: 60s for 1000 resources)

---

## Common Errors

### Error 1: "Patient with ID X does not exist"

```json
{
  "response": {
    "status": "400 Bad Request",
    "outcome": {
      "issue": [{
        "severity": "error",
        "diagnostics": "Patient with ID 999 does not exist"
      }]
    }
  }
}
```

**Solution:** Verify that the referenced Patient exists before bulk create.

### Error 2: "ThesaurusData not found"

```json
{
  "diagnostics": "ThesaurusData with concept_code=INVALID_CODE not found"
}
```

**Solution:** Use valid codes from your CodeSystem.

### Error 3: Less than 5 resources

```json
{
  "diagnostics": "At least 5 entries required for bulk, got 3"
}
```

**Solution:** Add more resources to reach the minimum threshold of 5.

### Error 4: Timeout (504)

**Solution:**
- Reduce batch size (500 → 100)
- Increase client timeout
- Parallelize requests for large imports

---


## FHIR Compliance

This implementation follows the FHIR R4B specification:

- [FHIR Bundle](https://hl7.org/fhir/R4B/bundle.html)
- [HTTP Interactions](https://hl7.org/fhir/R4B/http.html)
