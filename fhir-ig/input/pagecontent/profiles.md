# Profiles

This page provides an overview of all profiles defined in the Codoc FHIR Implementation Guide.

## Patient Profiles

### CodocPatient

The [CodocPatient](StructureDefinition-CodocPatient.html) profile constrains the FHIR Patient resource for use in Codoc hospital systems.

**Key Features:**
- Multi-IPP support with `official` (internal ID) and `usual` (hospital IPP) identifiers
- Required fields: identifier, name, gender, birthDate
- Patient merging support via `link[]` with type `replaced-by`
- CNIL-compliant: sensitive data can be anonymized

---

## Organization Profiles

### CodocOrganization

The [CodocOrganization](StructureDefinition-CodocOrganization.html) profile defines the hospital organizational hierarchy.

**Supported Types:**
| Type | Code | Possible Parent |
|------|------|-----------------|
| Instance | `instance` | None (root) |
| Site | `site` | Instance or root |
| Department | `department` | Instance or Site |
| Unit | `unit` | Department |

**Key Features:**
- Hierarchical validation enforced by API
- Activity period extension for units
- Aggregated statistics extensions

---

## Clinical Profiles

### CodocEncounter

The [CodocEncounter](StructureDefinition-CodocEncounter.html) profile represents hospital stays and intra-hospital movements.

**Key Concepts:**
- **Stay**: Complete hospitalization (no `partOf`)
- **Movement**: Intra-hospital transfer (`partOf` → Stay)

**Supported Classes:**
- `IMP` - Inpatient
- `AMB` - Ambulatory
- `EMER` - Emergency
- `HH` - Home Health

### CodocDocumentReference

The [CodocDocumentReference](StructureDefinition-CodocDocumentReference.html) profile represents clinical documents.

**Key Features:**
- Base64-encoded content (HTML or plain text)
- Links to encounter context
- Author can be Organization or practitioner name

---

## Observation Profiles

### CodocLabObservation

The [CodocLabObservation](StructureDefinition-CodocLabObservation.html) profile represents laboratory test results.

**Key Features:**
- Filtered by "Biologie" thesaurus
- Supports valueQuantity, valueString, valueCodeableConcept

### CodocPatientDataObservation

The [CodocPatientDataObservation](StructureDefinition-CodocPatientDataObservation.html) profile represents patient traits.

**Examples:** Weight, height, allergies, vital signs

### CodocPhenotypeObservation

The [CodocPhenotypeObservation](StructureDefinition-CodocPhenotypeObservation.html) profile represents NLP-extracted phenotypes from clinical documents.

**Key Features:**
- Linked to source DocumentReference via `derivedFrom`
- Component-based metadata:
  - `semantic_type` - UMLS semantic type
  - `tfidf_code_document` - TF-IDF relevance score
  - `count_concept` - Concept occurrence count
  - `count_concept_str_found` - String fragment count

---

## Procedure & Medication Profiles

### CodocProcedure

The [CodocProcedure](StructureDefinition-CodocProcedure.html) profile represents medical procedures.

**Key Features:**
- CCAM code binding for French procedures

### CodocMedicationRequest

The [CodocMedicationRequest](StructureDefinition-CodocMedicationRequest.html) profile represents medication prescriptions.

**Key Features:**
- ATC code binding for medications

### CodocDiagnosticReport

The [CodocDiagnosticReport](StructureDefinition-CodocDiagnosticReport.html) profile represents diagnostic reports.

**Examples:** Imaging reports, EFR, ECG
