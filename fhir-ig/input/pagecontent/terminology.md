# Terminology

This page documents the code systems and value sets defined in the Codoc Implementation Guide.

## Code Systems

### Codoc Organization Type

**URL:** `https://codoc.co/fhir/CodeSystem/codoc-organization-type`

Defines the types of organizations in the Codoc hospital hierarchy.

| Code | Display | Description |
|------|---------|-------------|
| `instance` | Instance | Hospital group or instance |
| `site` | Site | Hospital campus or facility |
| `department` | Department | Medical service or department |
| `unit` | Unit | Care unit within a department |

---

### Codoc Phenotype Components

**URL:** `https://codoc.co/fhir/CodeSystem/codoc-phenotype-components`

Defines the component codes used in phenotype observations.

| Code | Display | Description |
|------|---------|-------------|
| `phenotype` | Phenotype Flag | Indicates this is a phenotype (0 or 1) |
| `semantic_type` | Semantic Type | UMLS semantic type |
| `tfidf_code_document` | TF-IDF Score | Term frequency-inverse document frequency |
| `count_concept` | Concept Count | Number of concept occurrences |
| `count_concept_str_found` | String Found Count | Number of string fragment occurrences |

---

## Value Sets

### Codoc Organization Type ValueSet

**URL:** `https://codoc.co/fhir/ValueSet/codoc-organization-type`

**Binding:** Required

Includes all codes from the Codoc Organization Type code system.

---

### Codoc Observation Status ValueSet

**URL:** `https://codoc.co/fhir/ValueSet/codoc-observation-status`

**Binding:** Required

| Code | Display |
|------|---------|
| `registered` | Registered |
| `preliminary` | Preliminary |
| `final` | Final |
| `amended` | Amended |
| `cancelled` | Cancelled |

---

### Codoc Encounter Status ValueSet

**URL:** `https://codoc.co/fhir/ValueSet/codoc-encounter-status`

**Binding:** Required

| Code | Display |
|------|---------|
| `planned` | Planned |
| `in-progress` | In Progress |
| `finished` | Finished |
| `cancelled` | Cancelled |

---

### Codoc Encounter Class ValueSet

**URL:** `https://codoc.co/fhir/ValueSet/codoc-encounter-class`

**Binding:** Required

| Code | Display | Description |
|------|---------|-------------|
| `IMP` | Inpatient | Complete hospitalization |
| `AMB` | Ambulatory | Outpatient consultation |
| `EMER` | Emergency | Emergency visit |
| `HH` | Home Health | Home hospitalization |

---

### Codoc Phenotype Semantic Types ValueSet

**URL:** `https://codoc.co/fhir/ValueSet/codoc-phenotype-semantic-type`

**Binding:** Extensible

Common UMLS semantic types used for phenotype classification:

| Code | Display |
|------|---------|
| `Disease` | Disease or Syndrome |
| `Symptom` | Sign or Symptom |
| `Finding` | Finding |
| `Procedure` | Therapeutic or Preventive Procedure |
| `Anatomy` | Body Part, Organ, or Organ Component |
| `Substance` | Pharmacologic Substance |

---

## External Terminologies

The Codoc platform also uses the following external terminologies:

| Terminology | Use Case | Binding |
|-------------|----------|---------|
| **ICD-10** | Diagnoses, phenotype codes | Extensible |
| **CCAM** | French procedures | Required for Procedure |
| **ATC** | Medications | Required for MedicationRequest |
| **LOINC** | Lab observations | Extensible |
| **SNOMED CT** | Clinical findings | Extensible |
| **UCUM** | Units of measure | Required for Quantity |
