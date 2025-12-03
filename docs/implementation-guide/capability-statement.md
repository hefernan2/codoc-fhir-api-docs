---
title: Capability Statement
---

# Capability Statement

This page describes the capabilities of a Codoc FHIR server.

## Server Information

| Property | Value |
|----------|-------|
| **FHIR Version** | 4.3.0 (R4B) |
| **Mode** | Server |
| **Formats** | JSON, XML |
| **Authentication** | HTTP Basic Auth |
| **Base URL** | `{API_URL}/v4.3.0/` |

---

## Supported Resources

| Resource | Profile | Create | Read | Update | Delete | Search |
|----------|---------|:------:|:----:|:------:|:------:|:------:|
| Patient | CodocPatient | ✅ | ✅ | ✅ | ✅ | ✅ |
| Organization | CodocOrganization | ✅ | ✅ | ✅ | ✅ | ✅ |
| Encounter | CodocEncounter | ✅ | ✅ | ✅ | ✅ | ✅ |
| DocumentReference | CodocDocumentReference | ✅ | ✅ | ✅ | ✅ | ✅ |
| Observation | CodocLabObservation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Observation | CodocPhenotypeObservation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Procedure | CodocProcedure | ✅ | ✅ | ✅ | ✅ | ✅ |
| MedicationRequest | CodocMedicationRequest | ✅ | ✅ | ✅ | ✅ | ✅ |
| DiagnosticReport | CodocDiagnosticReport | ✅ | ✅ | ✅ | ✅ | ✅ |
| Bundle | - | ✅ | ✅ | ✅ | ✅ | - |

---

## REST Interactions

### Patient

```
POST   /v4.3.0/patient/           # Create
GET    /v4.3.0/patient/{id}/      # Read
PUT    /v4.3.0/patient/{id}/      # Update
PATCH  /v4.3.0/patient/{id}/      # Partial Update
DELETE /v4.3.0/patient/{id}/      # Delete
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `identifier` | token | Patient IPP |
| `name` | string | Patient name |
| `birthdate` | date | Date of birth |
| `gender` | token | Gender |

---

### Organization

```
POST   /v4.3.0/organization/           # Create
GET    /v4.3.0/organization/{id}/      # Read
PUT    /v4.3.0/organization/{id}/      # Update
DELETE /v4.3.0/organization/{id}/      # Delete
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `identifier` | token | Organization code |
| `type` | token | Organization type |
| `partof` | reference | Parent organization |

---

### Encounter

```
POST   /v4.3.0/encounter/              # Create Stay or Movement
GET    /v4.3.0/encounter/stay/{id}/    # Read Stay
GET    /v4.3.0/encounter/movement/{id}/ # Read Movement
PATCH  /v4.3.0/encounter/stay/{id}/    # Update Stay
DELETE /v4.3.0/encounter/stay/{id}/    # Delete Stay
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | reference | Patient reference |
| `status` | token | Encounter status |
| `class` | token | Encounter class |
| `date` | date | Encounter period |

---

### DocumentReference

```
POST   /v4.3.0/documentreference/           # Create
GET    /v4.3.0/documentreference/{id}/      # Read
PUT    /v4.3.0/documentreference/{id}/      # Update
DELETE /v4.3.0/documentreference/{id}/      # Delete
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | reference | Patient reference |
| `encounter` | reference | Encounter reference |
| `date` | date | Document date |
| `author` | reference | Author reference |

---

### Observation

```
POST   /v4.3.0/observation/                  # Create Lab Observation
POST   /v4.3.0/observation/phenotype/        # Create Phenotype
GET    /v4.3.0/observation/{id}/             # Read
GET    /v4.3.0/observation/phenotype/{id}/   # Read Phenotype
PUT    /v4.3.0/observation/{id}/             # Update
DELETE /v4.3.0/observation/{id}/             # Delete
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | reference | Patient reference |
| `code` | token | Observation code |
| `date` | date | Observation date |
| `status` | token | Observation status |

---

### Bundle

```
POST   /v4.3.0/bundle/    # Batch create
```

Supported bundle type: `batch`

---

## Validation Rules

The server validates:

1. **Required fields** - All mandatory elements must be present
2. **Data types** - Values must match expected types
3. **References** - Referenced resources must exist
4. **Value sets** - Coded values must be from allowed value sets
5. **Business rules** - Organization hierarchy, encounter relationships

---

## Error Responses

Errors are returned as `OperationOutcome` resources:

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "required",
    "diagnostics": "Field 'birthDate' is required"
  }]
}
```

### HTTP Status Codes

| Code | Meaning |
|------|---------|
| `200` | OK - Successful read/update |
| `201` | Created - Successful create |
| `400` | Bad Request - Validation error |
| `401` | Unauthorized - Authentication required |
| `404` | Not Found - Resource not found |
| `409` | Conflict - Version conflict |
| `500` | Server Error - Internal error |

---

## Security

### Authentication

All requests require HTTP Basic Authentication:

```bash
curl -u username:password {API_URL}/v4.3.0/patient/123/
```

### Authorization

Access control is managed at the organization level. Users can only access data from organizations they are authorized to view.

---

## Conformance Testing

To test conformance against Codoc profiles:

```bash
# Download FHIR Validator
curl -L https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar -o validator_cli.jar

# Validate a resource
java -jar validator_cli.jar my-patient.json \
  -ig codoc.fhir.ig#0.1.0 \
  -profile https://codoc.co/fhir/StructureDefinition/CodocPatient
```
