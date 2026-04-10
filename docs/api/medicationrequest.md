---
title: MedicationRequest
---

# MedicationRequest - Medication Prescriptions

The **MedicationRequest** resource represents medication prescriptions.

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>

## Thesaurus Filtering

Filters on `thesaurus_code = "Prescription"` (configurable via `THESAURUS_CODE_MEDICATION`).

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | ⚠️ **Always "Unknown" - not customizable**  |
| `intent` | code | ✅ Yes | ⚠️ **Always "order" - not customizable** |
| `medicationCodeableConcept` | CodeableConcept | ✅ Yes | Prescribed medication (ATC/Thesaurus) |
| `subject` | Reference | ✅ Yes | Related patient |
| `authoredOn` | dateTime | ✅ **Yes** (NOT Optional!) | Prescription date |
| `encounter` | Reference | ❌ No | Associated stay |
| `dosageInstruction[].doseAndRate[].doseQuantity` | Quantity | ❌ No | Dose value + unit |
| `dosageInstruction[].timing.repeat` | TimingRepeat | ❌ No | Frequency/period information |
| `dosageInstruction[].route` | CodeableConcept | ❌ No | Administration route |
| `dispenseRequest.validityPeriod` | Period | ❌ No | Dispensing validity dates |
| `performer` | Reference | ❌ No | Department (Organization/department-{id}) |

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `encounter` | integer | Filter by stay ID | `?encounter=789` |
| `date` | date | Prescription date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Prescriptions

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/medicationrequest/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/medicationrequest/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} prescriptions")
    for entry in bundle.get("entry", []):
        rx = entry["resource"]
        med = rx["medicationCodeableConcept"]["coding"][0].get("display", "N/A")
        print(f"  ID {rx['id']}: {med} - {rx['authoredOn']}")
    ```

## Retrieve a Prescription

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/medicationrequest/1/
    ```

=== "Python"
    ```python
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get("{API_URL}/v4.3.0/medicationrequest/1/", headers=headers)
    rx = response.json()
    
    med = rx["medicationCodeableConcept"]["coding"][0]
    print(f"Medication: {med.get('display', med['code'])}")
    print(f"Prescribed on: {rx['authoredOn']}")
    print(f"Patient: {rx['subject']['reference']}")
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Prescription" thesaurus (ATC)

<div class="quick-links">
  <a href="../procedure/">🏥 Procedure</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
