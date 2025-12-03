// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Observation Profiles                                                  │
// │  Based on FHIR R4B Observation resource                                      │
// ╰──────────────────────────────────────────────────────────────────────────────╯

// ═══════════════════════════════════════════════════════════════════════════════
// Lab Observation Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocLabObservation
Parent: Observation
Id: CodocLabObservation
Title: "Codoc Lab Observation"
Description: """
Profile for laboratory test results in Codoc systems.

**Key Features:**
- Filtered by "Biologie" thesaurus
- Supports valueQuantity, valueString, valueCodeableConcept
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// Required fields
* status 1..1 MS
* status from CodocObservationStatusVS (required)

* code 1..1 MS
* code ^short = "Test type from Biologie thesaurus"

* subject 1..1 MS
* subject only Reference(CodocPatient)

* effectiveDateTime 1..1 MS
* effectiveDateTime ^short = "Date/time of observation"

// Optional fields
* encounter MS
* encounter only Reference(CodocEncounter)

* value[x] MS
* value[x] ^short = "Result value (quantity, string, or coded)"


// ═══════════════════════════════════════════════════════════════════════════════
// Patient Data Observation Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocPatientDataObservation
Parent: Observation
Id: CodocPatientDataObservation
Title: "Codoc Patient Data Observation"
Description: """
Profile for patient data observations (traits, vital signs) in Codoc systems.

**Examples:** Weight, height, allergies, vital signs
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// Required fields
* status 1..1 MS
* status from CodocObservationStatusVS (required)

* code 1..1 MS
* code ^short = "Type of patient data"

* subject 1..1 MS
* subject only Reference(CodocPatient)

* effectiveDateTime MS
* effectiveDateTime ^short = "Date/time of observation"

// Value
* value[x] MS


// ═══════════════════════════════════════════════════════════════════════════════
// Phenotype Observation Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocPhenotypeObservation
Parent: Observation
Id: CodocPhenotypeObservation
Title: "Codoc Phenotype Observation"
Description: """
Profile for NLP-extracted phenotypes from clinical documents.

**Key Features:**
- Linked to source DocumentReference via `derivedFrom`
- Component-based metadata for NLP extraction details
- Supports semantic type, TF-IDF score, concept counts
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// ─────────────────────────────────────────────────────────────────────────────
// Required fields
// ─────────────────────────────────────────────────────────────────────────────
* status 1..1 MS
* status = #final
* status ^short = "Always 'final' for phenotypes"

* code 1..1 MS
* code ^short = "Phenotype concept from Phenotypes thesaurus"
* code ^definition = "The medical concept detected (e.g., ICD-10 code)"

* subject 1..1 MS
* subject ^short = "Patient reference"
* subject only Reference(CodocPatient)

* derivedFrom 1..* MS
* derivedFrom ^short = "Source DocumentReference (REQUIRED)"
* derivedFrom ^definition = "Reference to the clinical document from which this phenotype was extracted"
* derivedFrom only Reference(CodocDocumentReference)

* valueString 1..1 MS
* valueString ^short = "Exact text fragment found in document"
* valueString ^definition = "The actual text that was matched by NLP (concept_str_found)"

// ─────────────────────────────────────────────────────────────────────────────
// Effective Date (auto-populated from document)
// ─────────────────────────────────────────────────────────────────────────────
* effectiveDateTime MS
* effectiveDateTime ^short = "Date from source document"

// ─────────────────────────────────────────────────────────────────────────────
// Components for NLP metadata
// ─────────────────────────────────────────────────────────────────────────────
* component MS
* component ^slicing.discriminator.type = #pattern
* component ^slicing.discriminator.path = "code"
* component ^slicing.rules = #open
* component ^short = "NLP extraction metadata"

* component contains
    phenotypeFlag 0..1 MS and
    semanticType 0..1 MS and
    tfidfScore 0..1 MS and
    countConcept 0..1 MS and
    countStrFound 0..1 MS

* component[phenotypeFlag] ^short = "Phenotype flag (0 or 1)"
* component[phenotypeFlag].code = CodocPhenotypeComponentsCS#phenotype
* component[phenotypeFlag].valueInteger 0..1

* component[semanticType] ^short = "UMLS semantic type"
* component[semanticType].code = CodocPhenotypeComponentsCS#semantic_type
* component[semanticType].valueString 0..1

* component[tfidfScore] ^short = "TF-IDF relevance score"
* component[tfidfScore].code = CodocPhenotypeComponentsCS#tfidf_code_document
* component[tfidfScore].valueQuantity 0..1

* component[countConcept] ^short = "Concept occurrence count"
* component[countConcept].code = CodocPhenotypeComponentsCS#count_concept
* component[countConcept].valueInteger 0..1

* component[countStrFound] ^short = "String fragment occurrence count"
* component[countStrFound].code = CodocPhenotypeComponentsCS#count_concept_str_found
* component[countStrFound].valueInteger 0..1


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Examples                                                                    │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: lab-observation-example
InstanceOf: CodocLabObservation
Title: "Lab Observation Example - Blood Glucose"
Description: "Example of a blood glucose lab result"
Usage: #example

* status = #final

* code.coding[0].code = #GLU
* code.coding[0].display = "Blood Glucose"

* subject = Reference(Patient/1)

* effectiveDateTime = "2024-01-21T07:00:00Z"

* valueQuantity.value = 95
* valueQuantity.unit = "mg/dL"
* valueQuantity.system = "http://unitsofmeasure.org"
* valueQuantity.code = #mg/dL


Instance: phenotype-example
InstanceOf: CodocPhenotypeObservation
Title: "Phenotype Example - Hypertension"
Description: "Example of an NLP-extracted phenotype"
Usage: #example

* status = #final

* code.coding[0].code = #I10
* code.coding[0].display = "Essential hypertension"

* subject = Reference(Patient/1)

* derivedFrom[0] = Reference(DocumentReference/10)

* valueString = "essential hypertension"

* effectiveDateTime = "2024-01-15T10:00:00Z"

* component[phenotypeFlag].code = CodocPhenotypeComponentsCS#phenotype
* component[phenotypeFlag].valueInteger = 1

* component[semanticType].code = CodocPhenotypeComponentsCS#semantic_type
* component[semanticType].valueString = "Disease"

* component[tfidfScore].code = CodocPhenotypeComponentsCS#tfidf_code_document
* component[tfidfScore].valueQuantity.value = 0.85

* component[countConcept].code = CodocPhenotypeComponentsCS#count_concept
* component[countConcept].valueInteger = 2

* component[countStrFound].code = CodocPhenotypeComponentsCS#count_concept_str_found
* component[countStrFound].valueInteger = 1


Instance: phenotype-symptom-example
InstanceOf: CodocPhenotypeObservation
Title: "Phenotype Example - Chest Pain"
Description: "Example of an NLP-extracted symptom phenotype"
Usage: #example

* status = #final

* code.coding[0].code = #R07.9
* code.coding[0].display = "Chest pain, unspecified"

* subject = Reference(Patient/1)

* derivedFrom[0] = Reference(DocumentReference/10)

* valueString = "chest pain"

* component[semanticType].code = CodocPhenotypeComponentsCS#semantic_type
* component[semanticType].valueString = "Symptom"

* component[tfidfScore].code = CodocPhenotypeComponentsCS#tfidf_code_document
* component[tfidfScore].valueQuantity.value = 0.92

* component[countConcept].code = CodocPhenotypeComponentsCS#count_concept
* component[countConcept].valueInteger = 1
