---
title: MedicationRequest
---

# MedicationRequest - Medication Prescriptions

The **MedicationRequest** resource represents medication prescriptions.

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/medicationrequest/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
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

## Create a Prescription

=== "curl"
    ```bash
    curl -X POST {API_URL}/v4.3.0/medicationrequest/ \
      -H "Content-Type: application/json" \
      -d '{
            "resourceType": "MedicationRequest",
            "status": "active",
            "intent": "order",
            "medicationCodeableConcept": {
              "coding": [{
                "code": "AMOX500",
                "display": "Amoxicillin 500mg"
              }]
            },
            "subject": {"reference": "Patient/1"},
            "encounter": {"reference": "Encounter/2"},
            "authoredOn": "2024-01-15T09:00:00Z",
            "dosageInstruction": [
              {
                "doseAndRate": [{
                  "doseQuantity": {
                    "value": 500,
                    "unit": "mg"
                  }
                }],
                "timing": {
                  "repeat": {
                    "frequency": 3,
                    "period": 1,
                    "periodUnit": "d"
                  }
                },
                "route": {
                  "text": "Oral"
                }
              }
            ],
            "dispenseRequest": {
              "validityPeriod": {
                "start": "2024-01-15T00:00:00Z",
                "end": "2024-01-22T00:00:00Z"
              }
            },
            "performer": {"reference": "Organization/department-2"}
      }'
    ```

=== "Python"
    ```python
    prescription = {
          "resourceType": "MedicationRequest",
          "status": "active",
          "intent": "order",
          "medicationCodeableConcept": {
            "coding": [{
              "code": "AMOX500",
              "display": "Amoxicillin 500mg"
            }]
          },
          "subject": {"reference": "Patient/1"},
          "encounter": {"reference": "Encounter/2"},
          "authoredOn": "2024-01-15T09:00:00Z",
          "dosageInstruction": [
            {
              "doseAndRate": [{
                "doseQuantity": {
                  "value": 500,
                  "unit": "mg"
                }
              }],
              "timing": {
                "repeat": {
                  "frequency": 3,
                  "period": 1,
                  "periodUnit": "d"
                }
              },
              "route": {
                "text": "Oral"
              }
            }
          ],
          "dispenseRequest": {
            "validityPeriod": {
              "start": "2024-01-15T00:00:00Z",
              "end": "2024-01-22T00:00:00Z"
            }
          },
          "performer": {"reference": "Organization/department-2"}
    }
    
    response = requests.post("{API_URL}/v4.3.0/medicationrequest/", json=prescription)
    ```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `encounter`
- [CodeSystem](codesystem.md) - "Prescription" thesaurus (ATC)

<div class="quick-links">
  <a href="../procedure/">🏥 Procedure</a>
  <a href="../diagnosticreport/">📋 DiagnosticReport</a>
</div>
