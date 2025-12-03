// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Code Systems                                                          │
// ╰──────────────────────────────────────────────────────────────────────────────╯

// ═══════════════════════════════════════════════════════════════════════════════
// Organization Type Code System
// ═══════════════════════════════════════════════════════════════════════════════

CodeSystem: CodocOrganizationTypeCS
Id: codoc-organization-type
Title: "Codoc Organization Type Code System"
Description: "Types of organizations in the Codoc hospital hierarchy"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"
* ^caseSensitive = true
* ^content = #complete

* #instance "Instance" "Hospital group or instance - top level"
* #site "Site" "Hospital campus or facility"
* #department "Department" "Medical service or department"
* #unit "Unit" "Care unit within a department"


// ═══════════════════════════════════════════════════════════════════════════════
// Thesaurus Types Code System
// ═══════════════════════════════════════════════════════════════════════════════

CodeSystem: CodocThesaurusTypeCS
Id: codoc-thesaurus-type
Title: "Codoc Thesaurus Types"
Description: "Predefined thesaurus codes used to filter resources in Codoc"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"
* ^caseSensitive = true
* ^content = #complete

* #Biologie "Biologie" "Laboratory analyses - filters Observation resources"
* #Phenotypes "Phenotypes" "NLP-extracted medical concepts - filters Observation (phenotype)"
* #Acte "Acte" "Medical procedures (CCAM) - filters Procedure resources"
* #Prescription "Prescription" "Medications (ATC) - filters MedicationRequest resources"
* #Diagnostic "Diagnostic" "Diagnostic types - filters DiagnosticReport resources"


// ═══════════════════════════════════════════════════════════════════════════════
// Phenotype Components Code System
// ═══════════════════════════════════════════════════════════════════════════════

CodeSystem: CodocPhenotypeComponentsCS
Id: codoc-phenotype-components
Title: "Codoc Phenotype Components Code System"
Description: "Component codes used in phenotype observations for NLP metadata"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"
* ^caseSensitive = true
* ^content = #complete

* #phenotype "Phenotype Flag" "Indicates this is a phenotype (0 or 1)"
* #semantic_type "Semantic Type" "UMLS semantic type of the concept"
* #tfidf_code_document "TF-IDF Score" "Term frequency-inverse document frequency relevance score"
* #count_concept "Concept Count" "Number of concept occurrences in the document"
* #count_concept_str_found "String Found Count" "Number of exact string fragment occurrences"


// ═══════════════════════════════════════════════════════════════════════════════
// Phenotype Semantic Types Code System
// ═══════════════════════════════════════════════════════════════════════════════

CodeSystem: CodocPhenotypeSemanticTypeCS
Id: codoc-phenotype-semantic-type
Title: "Codoc Phenotype Semantic Type Code System"
Description: "Common UMLS semantic types used for phenotype classification"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"
* ^caseSensitive = true
* ^content = #complete

* #Disease "Disease or Syndrome" "A disorder or abnormal condition"
* #Symptom "Sign or Symptom" "An observable manifestation of a disease"
* #Finding "Finding" "A clinical observation or assessment"
* #Procedure "Procedure" "Therapeutic or preventive procedure"
* #Anatomy "Anatomy" "Body part, organ, or organ component"
* #Substance "Substance" "Pharmacologic substance or chemical"
* #Device "Device" "Medical device"
* #Organism "Organism" "Pathogenic organism"
