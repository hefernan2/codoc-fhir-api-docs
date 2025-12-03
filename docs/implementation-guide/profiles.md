---
title: Profiles
---

# FHIR Profiles

This page documents all FHIR profiles defined in the Codoc Implementation Guide.

## Patient Profiles

### CodocPatient

The `CodocPatient` profile constrains the FHIR Patient resource for use in Codoc hospital systems.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocPatient`

#### Key Features

- ✅ **Multi-IPP** - Support for multiple patient identifiers
- ✅ **Patient Merging** - Via `link[]` with type `replaced-by`
- ✅ **CNIL Compliance** - Sensitive data can be anonymized

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `identifier` | 1..* | At least one identifier (IPP/NIP) |
| `name` | 1..* | Patient name |
| `name.family` | 1..1 | Family name |
| `name.given` | 1..* | Given name(s) |
| `gender` | 1..1 | male \| female \| other \| unknown |
| `birthDate` | 1..1 | Date of birth (YYYY-MM-DD) |

#### Identifier Usage

| Use | Purpose | Example |
|-----|---------|---------|
| `official` | Internal Codoc ID | `123` |
| `usual` | Hospital IPP/NIP | `IPP123456` |

#### Example

```json
{
  "resourceType": "Patient",
  "id": "123",
  "identifier": [
    {"use": "official", "value": "123"},
    {"use": "usual", "system": "HIS", "value": "IPP123456"}
  ],
  "name": [{"family": "Smith", "given": ["John", "Peter"]}],
  "gender": "male",
  "birthDate": "1980-05-15"
}
```

---

## Organization Profiles

### CodocOrganization

The `CodocOrganization` profile defines the hospital organizational hierarchy.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocOrganization`

#### Hierarchy

```
Instance (Hospital Group)
└── Site (Campus)
    └── Department (Service)
        └── Unit (Care Unit)
```

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `identifier` | 1..* | Organization code |
| `type` | 1..* | Organization type |
| `name` | 1..1 | Organization name |
| `partOf` | 0..1 | Parent organization (required for dept/unit) |

#### Extensions

| Extension | Type | Description |
|-----------|------|-------------|
| `unitPeriod` | Period | Activity period for care units |

#### Example

```json
{
  "resourceType": "Organization",
  "id": "unit-1",
  "identifier": [{"value": "ICU001"}],
  "type": [{"coding": [{"code": "team"}]}],
  "name": "Intensive Care Unit",
  "partOf": {"reference": "Organization/department-1"},
  "extension": [{
    "url": "unit_period",
    "valuePeriod": {
      "start": "2025-01-01",
      "end": "2025-12-31"
    }
  }]
}
```

---

## Clinical Profiles

### CodocEncounter

The `CodocEncounter` profile represents hospital stays and intra-hospital movements.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocEncounter`

#### Concepts

| Type | `partOf` | Description |
|------|----------|-------------|
| **Stay** | None | Complete hospitalization |
| **Movement** | Reference to Stay | Intra-hospital transfer |

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `status` | 1..1 | planned \| in-progress \| finished \| cancelled |
| `class` | 1..1 | IMP \| AMB \| EMER \| HH |
| `subject` | 1..1 | Patient reference |
| `period.start` | 1..1 | Admission date/time |

---

### CodocDocumentReference

The `CodocDocumentReference` profile represents clinical documents.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocDocumentReference`

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `status` | 1..1 | current \| superseded \| entered-in-error |
| `subject` | 1..1 | Patient reference |
| `date` | 1..1 | Document creation date |
| `content.attachment.contentType` | 1..1 | text/html \| text/plain |
| `content.attachment.data` | 1..1 | Base64-encoded content |

---

## Observation Profiles

### CodocLabObservation

Laboratory test results filtered by "Biologie" thesaurus.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocLabObservation`

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `status` | 1..1 | Observation status |
| `code` | 1..1 | Test type from Biologie thesaurus |
| `subject` | 1..1 | Patient reference |
| `effectiveDateTime` | 1..1 | Date/time of observation |

---

### CodocPhenotypeObservation

NLP-extracted phenotypes from clinical documents.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocPhenotypeObservation`

#### Required Elements

| Element | Cardinality | Description |
|---------|-------------|-------------|
| `status` | 1..1 | Always "final" |
| `code` | 1..1 | Phenotype concept |
| `subject` | 1..1 | Patient reference |
| `derivedFrom` | 1..* | Source DocumentReference |
| `valueString` | 1..1 | Exact text fragment found |

#### Components

| Component Code | Type | Description |
|----------------|------|-------------|
| `phenotype` | integer | Phenotype flag (0/1) |
| `semantic_type` | string | UMLS semantic type |
| `tfidf_code_document` | Quantity | TF-IDF score |
| `count_concept` | integer | Concept occurrence count |
| `count_concept_str_found` | integer | String fragment count |

#### Example

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": {"coding": [{"code": "I10", "display": "Essential hypertension"}]},
  "subject": {"reference": "Patient/1"},
  "derivedFrom": [{"reference": "DocumentReference/10"}],
  "valueString": "essential hypertension",
  "component": [
    {
      "code": {"coding": [{"code": "semantic_type"}]},
      "valueString": "Disease"
    },
    {
      "code": {"coding": [{"code": "tfidf_code_document"}]},
      "valueQuantity": {"value": 0.85}
    }
  ]
}
```

---

## Procedure & Medication Profiles

### CodocProcedure

Medical procedures with CCAM code binding.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocProcedure`

### CodocMedicationRequest

Medication prescriptions with ATC code binding.

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocMedicationRequest`

### CodocDiagnosticReport

Diagnostic reports (imaging, EFR, ECG).

**Canonical URL:** `https://codoc.co/fhir/StructureDefinition/CodocDiagnosticReport`

---

## Profile Summary Table

| Profile | Base | Required | Extensions |
|---------|------|----------|------------|
| CodocPatient | Patient | identifier, name, gender, birthDate | - |
| CodocOrganization | Organization | identifier, type, name | unitPeriod |
| CodocEncounter | Encounter | status, class, subject, period.start | - |
| CodocDocumentReference | DocumentReference | status, subject, date, content | - |
| CodocLabObservation | Observation | status, code, subject, effectiveDateTime | - |
| CodocPhenotypeObservation | Observation | status, code, subject, derivedFrom, valueString | (via component) |
| CodocProcedure | Procedure | status, code, subject | - |
| CodocMedicationRequest | MedicationRequest | status, intent, subject | - |
| CodocDiagnosticReport | DiagnosticReport | status, code, subject | - |
