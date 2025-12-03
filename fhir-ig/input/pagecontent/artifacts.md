# Artifacts Summary

This page provides a complete index of all artifacts defined in this Implementation Guide.

## Profiles

### Patient Profiles

| Profile | Base Resource | Description |
|---------|---------------|-------------|
| [CodocPatient](StructureDefinition-CodocPatient.html) | Patient | Patient identity with multi-IPP support |

### Organization Profiles

| Profile | Base Resource | Description |
|---------|---------------|-------------|
| [CodocOrganization](StructureDefinition-CodocOrganization.html) | Organization | Hospital organizational hierarchy |

### Clinical Profiles

| Profile | Base Resource | Description |
|---------|---------------|-------------|
| [CodocEncounter](StructureDefinition-CodocEncounter.html) | Encounter | Hospital stays and movements |
| [CodocDocumentReference](StructureDefinition-CodocDocumentReference.html) | DocumentReference | Clinical documents |

### Observation Profiles

| Profile | Base Resource | Description |
|---------|---------------|-------------|
| [CodocLabObservation](StructureDefinition-CodocLabObservation.html) | Observation | Laboratory test results |
| [CodocPatientDataObservation](StructureDefinition-CodocPatientDataObservation.html) | Observation | Patient data (weight, height, etc.) |
| [CodocPhenotypeObservation](StructureDefinition-CodocPhenotypeObservation.html) | Observation | NLP-extracted phenotypes |

### Procedure & Medication Profiles

| Profile | Base Resource | Description |
|---------|---------------|-------------|
| [CodocProcedure](StructureDefinition-CodocProcedure.html) | Procedure | Medical procedures (CCAM) |
| [CodocMedicationRequest](StructureDefinition-CodocMedicationRequest.html) | MedicationRequest | Medication prescriptions (ATC) |
| [CodocDiagnosticReport](StructureDefinition-CodocDiagnosticReport.html) | DiagnosticReport | Diagnostic reports |

---

## Extensions

| Extension | Context | Description |
|-----------|---------|-------------|
| [UnitPeriod](StructureDefinition-unit-period.html) | Organization | Activity period for care units |
| [PhenotypeSemanticType](StructureDefinition-phenotype-semantic-type.html) | Observation.component | UMLS semantic type |
| [PhenotypeTfidf](StructureDefinition-phenotype-tfidf.html) | Observation.component | TF-IDF relevance score |
| [PhenotypeCountConcept](StructureDefinition-phenotype-count-concept.html) | Observation.component | Concept occurrence count |
| [PhenotypeCountStrFound](StructureDefinition-phenotype-count-str-found.html) | Observation.component | String fragment count |

---

## Value Sets

| ValueSet | Binding | Description |
|----------|---------|-------------|
| [CodocOrganizationType](ValueSet-codoc-organization-type.html) | Required | Organization types |
| [CodocObservationStatus](ValueSet-codoc-observation-status.html) | Required | Observation status codes |
| [CodocEncounterStatus](ValueSet-codoc-encounter-status.html) | Required | Encounter status codes |
| [CodocEncounterClass](ValueSet-codoc-encounter-class.html) | Required | Encounter class codes |
| [CodocPhenotypeSemanticType](ValueSet-codoc-phenotype-semantic-type.html) | Extensible | Phenotype semantic types |

---

## Code Systems

| CodeSystem | Description |
|------------|-------------|
| [CodocOrganizationType](CodeSystem-codoc-organization-type.html) | Organization type codes |
| [CodocPhenotypeComponents](CodeSystem-codoc-phenotype-components.html) | Phenotype component codes |

---

## Capability Statement

| Artifact | Description |
|----------|-------------|
| [CodocCapabilityStatement](CapabilityStatement-codoc-capability-statement.html) | Server capabilities |

---

## Examples

| Example | Profile | Description |
|---------|---------|-------------|
| [PatientExample](Patient-patient-example.html) | CodocPatient | Example patient |
| [OrganizationSiteExample](Organization-organization-site-example.html) | CodocOrganization | Example hospital site |
| [OrganizationDeptExample](Organization-organization-dept-example.html) | CodocOrganization | Example department |
| [OrganizationUnitExample](Organization-organization-unit-example.html) | CodocOrganization | Example care unit |
| [EncounterStayExample](Encounter-encounter-stay-example.html) | CodocEncounter | Example hospital stay |
| [EncounterMovementExample](Encounter-encounter-movement-example.html) | CodocEncounter | Example movement |
| [DocumentExample](DocumentReference-document-example.html) | CodocDocumentReference | Example clinical document |
| [LabObservationExample](Observation-lab-observation-example.html) | CodocLabObservation | Example lab result |
| [PhenotypeExample](Observation-phenotype-example.html) | CodocPhenotypeObservation | Example phenotype |
