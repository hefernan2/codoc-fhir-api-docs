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
| **Authentication** | API Key (`Authorization: Api-Key`) |
| **Base URL** | `{API_URL}/v4.3.0/` |

---

## Supported Resources

| Resource | Profile | Read | Search |
|----------|---------|:----:|:------:|
| Patient | CodocPatient | ✅ | ✅ |
| Organization | CodocOrganization | ✅ | ✅ |
| Encounter | CodocEncounter | ✅ | ✅ |
| DocumentReference | CodocDocumentReference | ✅ | ✅ |
| Observation | CodocLabObservation | ✅ | ✅ |
| Observation | CodocPhenotypeObservation | ✅ | ✅ |
| Procedure | CodocProcedure | ✅ | ✅ |
| MedicationRequest | CodocMedicationRequest | ✅ | ✅ |
| DiagnosticReport | CodocDiagnosticReport | ✅ | ✅ |

---

## REST Interactions

### Patient

```
GET    /v4.3.0/patient/           # List
GET    /v4.3.0/patient/{id}/      # Read
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `birthdate` | date | Date of birth (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `death-date` | date | Date of death (FHIR prefixes supported) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### Organization

```
GET    /v4.3.0/organization/           # List
GET    /v4.3.0/organization/{id}/      # Read
```

**Search Parameters:**

No search parameters available. Returns the full list (paginated).

---

### Encounter

```
GET    /v4.3.0/encounter/              # List
GET    /v4.3.0/encounter/stay/{id}/    # Read Stay
GET    /v4.3.0/encounter/movement/{id}/ # Read Movement
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `date` | date | Encounter period (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### DocumentReference

```
GET    /v4.3.0/documentreference/           # List
GET    /v4.3.0/documentreference/{id}/      # Read
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `encounter` | integer | Stay ID |
| `date` | date | Document date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### Observation

```
GET    /v4.3.0/observation/                  # List Lab Observations
GET    /v4.3.0/observation/phenotype/        # List Phenotypes
GET    /v4.3.0/observation/{id}/             # Read
GET    /v4.3.0/observation/phenotype/{id}/   # Read Phenotype
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `encounter` | integer | Stay ID |
| `date` | date | Observation date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### Procedure

```
GET    /v4.3.0/procedure/         # List
GET    /v4.3.0/procedure/{id}/    # Read
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `encounter` | integer | Stay ID |
| `date` | date | Procedure date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### MedicationRequest

```
GET    /v4.3.0/medicationrequest/         # List
GET    /v4.3.0/medicationrequest/{id}/    # Read
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `encounter` | integer | Stay ID |
| `date` | date | Prescription date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

---

### DiagnosticReport

```
GET    /v4.3.0/diagnosticreport/         # List
GET    /v4.3.0/diagnosticreport/{id}/    # Read
```

**Search Parameters:**

| Parameter | Type | Description |
|-----------|------|-------------|
| `patient` | integer | Patient ID |
| `encounter` | integer | Stay ID |
| `date` | date | Examination date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) |

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
| `200` | OK - Successful read |
| `401` | Unauthorized - Authentication required |
| `403` | Forbidden - Insufficient permissions |
| `404` | Not Found - Resource not found |
| `429` | Too Many Requests - Rate limit reached |
| `500` | Server Error - Internal error |

---

## Security

### Authentication

All requests require an API key passed as an HTTP header:

```bash
curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/patient/123/
```

The key format is `Api-Key <key>` where `<key>` starts with `fhir_`.

!!! info "Public endpoints"
    The following endpoints do not require authentication:
    `/v4.3.0/codesystem/`, `/v4.3.0/codesystem/{code}/concept/`, `/v4.3.0/observation/phenotype/`

### Authorization

Each API key is created with permissions scoped to specific FHIR resources. A key may grant access to one resource (e.g., `Patient` only), a subset, or all resources (`*`). Contact your administrator to obtain a key or to adjust which resources it can access.

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
