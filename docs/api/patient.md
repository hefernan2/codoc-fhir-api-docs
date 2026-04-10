---
title: Patient
---

# Patient - Identity and Demographics

The **Patient** resource represents patient identity and demographic data.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/patient/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `birthdate` | date | Date of birth (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?birthdate=ge1990-01-01` |
| `death-date` | date | Date of death (FHIR prefixes supported) | `?death-date=le2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Patients

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/patient/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/patient/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} patients")
    for entry in bundle.get("entry", []):
        p = entry["resource"]
        print(f"  ID {p['id']}: {p.get('name', [{}])[0].get('family', 'N/A')}")
    ```

## Retrieve a Patient

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/patient/123/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/patient/123/", headers=headers)
    patient = response.json()
    
    print(f"Last name: {patient['name'][0]['family']}")
    print(f"First name: {patient['name'][0]['given'][0]}")
    print(f"Gender: {patient['gender']}")
    ```

**Response (200 OK):**
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

## CNIL Compliance

Sensitive data is **optional** (nullable) to comply with CNIL constraints:

- `name` can be empty (anonymous patients)
- `gender` can be "unknown"
- `birthDate` can be approximate or absent

## Related Resources

- [Organization](organization.md) - For `managingOrganization`
- [Encounter](encounter.md) - Patient stays
- [DocumentReference](documentreference.md) - Patient documents

## Next Steps

<div class="quick-links">
  <a href="../organization/">🏥 Organization</a>
  <a href="../encounter/">🛏️ Encounter</a>
  <a href="../../guides/patient-record/">📖 Guide: Query a Patient Record</a>
</div>
