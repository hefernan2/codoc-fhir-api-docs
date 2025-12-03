# Capability Statement

This page describes the capabilities of a Codoc FHIR server.

## Overview

The Codoc FHIR Server implements a subset of the FHIR R4B specification, optimized for hospital data management including patient identity, organizational hierarchy, clinical encounters, and NLP-extracted phenotypes.

## Server Information

| Property | Value |
|----------|-------|
| **FHIR Version** | 4.3.0 (R4B) |
| **Mode** | Server |
| **Format** | JSON |
| **Authentication** | HTTP Basic Auth |

## REST Capabilities

### Supported Resources

| Resource | Create | Read | Update | Delete | Search |
|----------|--------|------|--------|--------|--------|
| Patient | ✅ | ✅ | ✅ | ✅ | ✅ |
| Organization | ✅ | ✅ | ✅ | ✅ | ✅ |
| Encounter | ✅ | ✅ | ✅ | ✅ | ✅ |
| DocumentReference | ✅ | ✅ | ✅ | ✅ | ✅ |
| Observation | ✅ | ✅ | ✅ | ✅ | ✅ |
| Procedure | ✅ | ✅ | ✅ | ✅ | ✅ |
| MedicationRequest | ✅ | ✅ | ✅ | ✅ | ✅ |
| DiagnosticReport | ✅ | ✅ | ✅ | ✅ | ✅ |
| CodeSystem | ✅ | ✅ | ✅ | ✅ | ✅ |
| Bundle | ✅ | - | ✅ | ✅ | - |

### Interactions

#### Patient

```
POST   /v4.3.0/patient/           # Create
GET    /v4.3.0/patient/{id}/      # Read
PUT    /v4.3.0/patient/{id}/      # Update
PATCH  /v4.3.0/patient/{id}/      # Partial Update
DELETE /v4.3.0/patient/{id}/      # Delete
```

**Search Parameters:**
- `identifier` - Patient IPP
- `name` - Patient name
- `birthdate` - Date of birth
- `gender` - Gender

#### Organization

```
POST   /v4.3.0/organization/           # Create
GET    /v4.3.0/organization/{id}/      # Read
PUT    /v4.3.0/organization/{id}/      # Update
DELETE /v4.3.0/organization/{id}/      # Delete
```

**Search Parameters:**
- `identifier` - Organization code
- `type` - Organization type (instance, site, department, unit)
- `partof` - Parent organization

#### Encounter

```
POST   /v4.3.0/encounter/              # Create Stay or Movement
GET    /v4.3.0/encounter/stay/{id}/    # Read Stay
GET    /v4.3.0/encounter/movement/{id}/ # Read Movement
PATCH  /v4.3.0/encounter/stay/{id}/    # Update Stay
DELETE /v4.3.0/encounter/stay/{id}/    # Delete Stay
```

**Search Parameters:**
- `patient` - Patient reference
- `status` - Encounter status
- `class` - Encounter class
- `date` - Encounter period

#### DocumentReference

```
POST   /v4.3.0/documentreference/           # Create
GET    /v4.3.0/documentreference/{id}/      # Read
PUT    /v4.3.0/documentreference/{id}/      # Update
DELETE /v4.3.0/documentreference/{id}/      # Delete
```

**Search Parameters:**
- `patient` - Patient reference
- `encounter` - Encounter reference
- `date` - Document date
- `author` - Author reference

#### Observation

```
POST   /v4.3.0/observation/                  # Create Lab Observation
POST   /v4.3.0/observation/phenotype/        # Create Phenotype
GET    /v4.3.0/observation/{id}/             # Read
GET    /v4.3.0/observation/phenotype/{id}/   # Read Phenotype
PUT    /v4.3.0/observation/{id}/             # Update
DELETE /v4.3.0/observation/{id}/             # Delete
```

**Search Parameters:**
- `patient` - Patient reference
- `code` - Observation code
- `date` - Observation date
- `status` - Observation status

#### Bundle

```
POST   /v4.3.0/bundle/    # Batch create
```

**Supported Types:**
- `batch` - Execute multiple operations

## Validation

The server validates:

1. **Required fields** - All mandatory elements must be present
2. **Data types** - Values must match expected types
3. **References** - Referenced resources must exist
4. **Value sets** - Coded values must be from allowed value sets
5. **Business rules** - Organization hierarchy, encounter relationships

## Error Handling

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
| 200 | OK - Successful read/update |
| 201 | Created - Successful create |
| 400 | Bad Request - Validation error |
| 401 | Unauthorized - Authentication required |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Version conflict |
| 500 | Server Error - Internal error |
