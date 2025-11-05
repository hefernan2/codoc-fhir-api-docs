---
title: Patient
---

# Patient - Identity and Demographics

The **Patient** resource represents patient identity and demographic data.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/patient/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/patient/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/patient/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method patch">PATCH</span>
  <span class="endpoint-path">/v4.3.0/patient/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/patient/{id}/</span>
</div>

## Key Features

- ✅ **Multi-IPP** - Management of multiple identifiers per patient
- ✅ **Demographic data** - Last name, first name, gender, date of birth
- ✅ **Death management** - deceasedBoolean or deceasedDateTime
- ✅ **Patient merging** - Via link[] with type="replaced-by"
- ✅ **CNIL compliance** - Sensitive data nullable

## Field Structure

| FHIR Field | Type | Required | Codoc Mapping | Description |
|------------|------|----------|---------------|-------------|
| `id` | string | Auto | `Patient.id` | Generated unique ID |
| `identifier[]` | Identifier | ✅ Yes | `Patient.nip` (use=usual) | Patient IPP/NIP |
| `identifier[0].value` | string | ✅ Yes | - | Identifier value |
| `name[]` | HumanName | ✅ Yes | `Patient.last_name`, `first_name` | Full name |
| `name[0].family` | string | ✅ Yes | `Patient.last_name` | Family name |
| `name[0].given[]` | string[] | ✅ Yes | `Patient.first_name` | Given name(s) |
| `gender` | code | ✅ Yes | `Patient.sex` | male, female, other, unknown |
| `birthDate` | date | ✅ Yes | `Patient.birth_date` | Birth date (YYYY-MM-DD) |
| `deceasedBoolean` | boolean | No | `Patient.deceased` | Deceased or not |
| `deceasedDateTime` | dateTime | No | `Patient.death_datetime` | Date and time of death |
| `managingOrganization` | Reference | No | `Patient.managing_organization` | Managing unit |
| `link[]` | BackboneElement | No | `Patient.fused_into` | Patient merging |

## Create a Patient

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/patient/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "identifier": [
          {
            "use": "usual",
            "value": "IPP123456"
          }
        ],
        "name": [
          {
            "family": "Smith",
            "given": ["John", "Peter"]
          }
        ],
        "gender": "male",
        "birthDate": "1980-05-15",
        "managingOrganization": {
          "reference": "Organization/department-1"
        }
      }'
    ```

=== "Python"
    ```python
    import requests
    
    patient = {
        "resourceType": "Patient",
        "identifier": [{"use": "usual", "value": "IPP123456"}],
        "name": [{"family": "Smith", "given": ["John", "Peter"]}],
        "gender": "male",
        "birthDate": "1980-05-15",
        "managingOrganization": {"reference": "Organization/department-1"}
    }
    
    response = requests.post(
        "{API_URL}/v4.3.0/patient/",
        json=patient
    )
    
    print(f"Status: {response.status_code}")
    print(f"Patient ID: {response.json()['id']}")
    ```

**Response (201 Created):**
```json
{
  "resourceType":"Patient",
  "id":"123",
  "identifier":[
    {
      "use":"official","value":"123"
    },
    {
      "use":"usual",
      "system":"HIS",
      "value":"IPP123456"
    }
  ],
  "name":[
    {
      "family":"Smith",
      "given":["John Peter"]
    }
  ],
  "gender":"male",
  "birthDate":"1980-05-15",
  "managingOrganization":
  {
    "reference":"organization/department-1",
    "type":"https://hl7.org/fhir/R4B/organization.html","display":"Cardiology Department"
  }
}
```

## Retrieve a Patient

=== "curl"
    ```bash
    curl {API_URL}/v4.3.0/patient/123/
    ```

=== "Python"
    ```python
    response = requests.get("{API_URL}/v4.3.0/patient/123/")
    patient = response.json()
    
    print(f"Last name: {patient['name'][0]['family']}")
    print(f"First name: {patient['name'][0]['given'][0]}")
    print(f"Gender: {patient['gender']}")
    ```

## Declare a Death

    curl -X PATCH {API_URL}/v4.3.0/patient/123/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "deceasedDateTime": "2024-01-15T14:30:00Z"
      }'
    ```

    curl -X PATCH {API_URL}/v4.3.0/patient/123/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "deceasedBoolean": true
      }'
    ```

!!! warning "Mutual exclusivity"
    Use **either** `deceasedBoolean` **or** `deceasedDateTime`, never both.

    curl -X PATCH {API_URL}/v4.3.0/patient/456/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "Patient",
        "link": [
          {
            "other": {"reference": "Patient/123"},
            "type": "replaced-by"
          }
        ]
      }'
    ```

**Meaning:** Patient 456 has been merged into patient 123.

## Multi-IPP (Multiple Identifiers)

A patient can have multiple identifiers:

```json
{
  "resourceType": "Patient",
  "identifier": [
    {"use": "official", "value": "123"},
    {"use": "usual", "value": "IPP123456"},
    {"use": "usual", "value": "IPP_OLD_789"}
  ],
  "name": [{"family": "Smith", "given": ["John"]}],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

- `use: "official"` → Internal Codoc ID
- `use: "usual"` → External IPP/NIP

## Common Errors

### Error 400 - Missing Required Field

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

**Solution:** Verify that all required fields are present.

### Error 400 - Invalid Date Format

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "invalid",
    "diagnostics": "Invalid date format. Expected YYYY-MM-DD"
  }]
}
```

**Solution:** Use ISO 8601 format for `birthDate` (YYYY-MM-DD).

### Error 404 - Organization Not Found

```json
{
  "resourceType": "OperationOutcome",
  "issue": [{
    "severity": "error",
    "code": "not-found",
    "diagnostics": "Organization with ID 999 does not exist"
  }]
}
```

**Solution:** Verify that the ID in `managingOrganization.reference` exists.

## CNIL Compliance

Sensitive data is **optional** (nullable) to comply with CNIL constraints:

- `name` can be empty (anonymous patients)
- `gender` can be "unknown"
- `birthDate` can be approximate or absent

## Use Cases

### Create an Anonymous Patient

```json
{
  "resourceType": "Patient",
  "identifier": [{"value": "ANON_001"}],
  "name": [{"family": "Anonymous", "given": ["Patient"]}],
  "gender": "unknown",
  "birthDate": "1970-01-01"
}
```

### Patient with Phone and Address

```json
{
  "resourceType": "Patient",
  "identifier": [{"value": "IPP123"}],
  "name": [{"family": "Smith", "given": ["John"]}],
  "telecom": [
    {"system": "phone", "value": "01 23 45 67 89", "use": "home"},
    {"system": "email", "value": "john.smith@email.com"}
  ],
  "address": [
    {
      "use": "home",
      "line": ["123 Peace Street"],
      "city": "Paris",
      "postalCode": "75001",
      "country": "FR"
    }
  ],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

## Related Resources

- [Organization](organization.md) - For `managingOrganization`
- [Encounter](encounter.md) - Patient stays
- [DocumentReference](documentreference.md) - Patient documents

## Next Steps

<div class="quick-links">
  <a href="../organization/">🏥 Organization</a>
  <a href="../encounter/">🛏️ Encounter</a>
  <a href="../../guides/patient-record/">📖 Guide: Create a Patient Record</a>
</div>
