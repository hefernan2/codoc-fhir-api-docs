---
title: Terminology
---

# Terminology

This page documents the code systems and value sets defined in the Codoc Implementation Guide.

## Code Systems

### Codoc Organization Type

**Code System ID:** `codoc-organization-type`

Defines the types of organizations in the Codoc hospital hierarchy.

| Code | Display | Definition |
|------|---------|------------|
| `instance` | Instance | Hospital group or instance - top level |
| `site` | Site | Hospital campus or facility |
| `department` | Department | Medical service or department |
| `unit` | Unit | Care unit within a department |

---

### Codoc Phenotype Components

**Code System ID:** `codoc-phenotype-components`

Component codes used in phenotype observations for NLP metadata.

| Code | Display | Definition |
|------|---------|------------|
| `phenotype` | Phenotype Flag | Indicates this is a phenotype (0 or 1) |
| `semantic_type` | Semantic Type | UMLS semantic type of the concept |
| `tfidf_code_document` | TF-IDF Score | Term frequency-inverse document frequency |
| `count_concept` | Concept Count | Number of concept occurrences |
| `count_concept_str_found` | String Found Count | Number of string fragment occurrences |

---

### Codoc Phenotype Semantic Types

**Code System ID:** `codoc-phenotype-semantic-type`

Common UMLS semantic types used for phenotype classification.

| Code | Display | Definition |
|------|---------|------------|
| `Disease` | Disease or Syndrome | A disorder or abnormal condition |
| `Symptom` | Sign or Symptom | An observable manifestation of a disease |
| `Finding` | Finding | A clinical observation or assessment |
| `Procedure` | Procedure | Therapeutic or preventive procedure |
| `Anatomy` | Anatomy | Body part, organ, or organ component |
| `Substance` | Substance | Pharmacologic substance or chemical |
| `Device` | Device | Medical device |
| `Organism` | Organism | Pathogenic organism |

---

### Codoc Thesaurus Types

**Code System ID:** `codoc-thesaurus-type`

Predefined thesaurus codes used to filter resources in Codoc.

| Code | Display | Use |
|------|---------|-----|
| `Biologie` | Biology/Lab | Filters Observation resources |
| `Phenotypes` | Phenotypes | Filters Observation (phenotype) resources |
| `Acte` | Procedures | Filters Procedure resources |
| `Prescription` | Medications | Filters MedicationRequest resources |
| `Diagnostic` | Diagnostics | Filters DiagnosticReport resources |

---

## Value Sets

### Organization Type

**Value Set ID:** `codoc-organization-type`

Includes:
- `instance`, `site`, `department`, `unit` from codoc-organization-type code system
- `prov` (Healthcare Provider) from HL7
- `dept` (Hospital Department) from HL7
- `team` (Organizational team) from HL7

---

### Observation Status

**Value Set ID:** `codoc-observation-status`

| Code | Display |
|------|---------|
| `registered` | Registered |
| `preliminary` | Preliminary |
| `final` | Final |
| `amended` | Amended |
| `cancelled` | Cancelled |
| `entered-in-error` | Entered in Error |
| `unknown` | Unknown |

---

### Encounter Status

**Value Set ID:** `codoc-encounter-status`

| Code | Display |
|------|---------|
| `planned` | Planned |
| `in-progress` | In Progress |
| `onleave` | On Leave |
| `finished` | Finished |
| `cancelled` | Cancelled |
| `entered-in-error` | Entered in Error |
| `unknown` | Unknown |

---

### Encounter Class

**Value Set ID:** `codoc-encounter-class`

| Code | Display | Description |
|------|---------|-------------|
| `IMP` | Inpatient | Complete hospitalization |
| `AMB` | Ambulatory | Outpatient consultation |
| `EMER` | Emergency | Emergency visit |
| `HH` | Home Health | Home hospitalization |

---

### Phenotype Semantic Type

**Value Set ID:** `codoc-phenotype-semantic-type`

Includes all codes from `codoc-phenotype-semantic-type` code system.

---

### Document Status

**Value Set ID:** `codoc-document-status`

| Code | Display |
|------|---------|
| `current` | Current |
| `superseded` | Superseded |
| `entered-in-error` | Entered in Error |

---

### Gender

**Value Set ID:** `codoc-gender`

| Code | Display |
|------|---------|
| `male` | Male |
| `female` | Female |
| `other` | Other |
| `unknown` | Unknown |

---

## External Terminologies

The Codoc platform also uses the following external terminologies:

| Terminology | System | Use Case |
|-------------|--------|----------|
| **ICD-10** | `http://hl7.org/fhir/sid/icd-10` | Diagnoses, phenotype codes |
| **CCAM** | `https://www.ameli.fr/accueil-de-la-ccam` | French procedures |
| **ATC** | `http://www.whocc.no/atc` | Medications |
| **LOINC** | `http://loinc.org` | Lab observations |
| **SNOMED CT** | `http://snomed.info/sct` | Clinical findings |
| **UCUM** | `http://unitsofmeasure.org` | Units of measure |

---

## Binding Strength

| Strength | Meaning |
|----------|---------|
| **Required** | Must use a code from the value set |
| **Extensible** | Should use a code from the value set, but can use others |
| **Preferred** | Encouraged to use a code from the value set |
| **Example** | For illustration only |

Most Codoc bindings are **Required** to ensure data consistency.
