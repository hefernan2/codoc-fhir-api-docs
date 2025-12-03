// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Value Sets                                                            │
// ╰──────────────────────────────────────────────────────────────────────────────╯

// ═══════════════════════════════════════════════════════════════════════════════
// Organization Type Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocOrganizationTypeVS
Id: codoc-organization-type
Title: "Codoc Organization Type Value Set"
Description: "Allowed organization types in the Codoc hospital hierarchy"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* include codes from system CodocOrganizationTypeCS
* include http://terminology.hl7.org/CodeSystem/organization-type#prov "Healthcare Provider"
* include http://terminology.hl7.org/CodeSystem/organization-type#dept "Hospital Department"
* include http://terminology.hl7.org/CodeSystem/organization-type#team "Organizational team"


// ═══════════════════════════════════════════════════════════════════════════════
// Observation Status Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocObservationStatusVS
Id: codoc-observation-status
Title: "Codoc Observation Status Value Set"
Description: "Allowed observation status codes in Codoc"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* http://hl7.org/fhir/observation-status#registered "Registered"
* http://hl7.org/fhir/observation-status#preliminary "Preliminary"
* http://hl7.org/fhir/observation-status#final "Final"
* http://hl7.org/fhir/observation-status#amended "Amended"
* http://hl7.org/fhir/observation-status#cancelled "Cancelled"
* http://hl7.org/fhir/observation-status#entered-in-error "Entered in Error"
* http://hl7.org/fhir/observation-status#unknown "Unknown"


// ═══════════════════════════════════════════════════════════════════════════════
// Encounter Status Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocEncounterStatusVS
Id: codoc-encounter-status
Title: "Codoc Encounter Status Value Set"
Description: "Allowed encounter status codes in Codoc"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* http://hl7.org/fhir/encounter-status#planned "Planned"
* http://hl7.org/fhir/encounter-status#in-progress "In Progress"
* http://hl7.org/fhir/encounter-status#onleave "On Leave"
* http://hl7.org/fhir/encounter-status#finished "Finished"
* http://hl7.org/fhir/encounter-status#cancelled "Cancelled"
* http://hl7.org/fhir/encounter-status#entered-in-error "Entered in Error"
* http://hl7.org/fhir/encounter-status#unknown "Unknown"


// ═══════════════════════════════════════════════════════════════════════════════
// Encounter Class Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocEncounterClassVS
Id: codoc-encounter-class
Title: "Codoc Encounter Class Value Set"
Description: "Allowed encounter class codes in Codoc"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* http://terminology.hl7.org/CodeSystem/v3-ActCode#IMP "inpatient encounter"
* http://terminology.hl7.org/CodeSystem/v3-ActCode#AMB "ambulatory"
* http://terminology.hl7.org/CodeSystem/v3-ActCode#EMER "emergency"
* http://terminology.hl7.org/CodeSystem/v3-ActCode#HH "home health"


// ═══════════════════════════════════════════════════════════════════════════════
// Phenotype Semantic Type Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocPhenotypeSemanticTypeVS
Id: codoc-phenotype-semantic-type
Title: "Codoc Phenotype Semantic Type Value Set"
Description: "Common semantic types for phenotype classification"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* include codes from system CodocPhenotypeSemanticTypeCS


// ═══════════════════════════════════════════════════════════════════════════════
// Document Status Value Set
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocDocumentStatusVS
Id: codoc-document-status
Title: "Codoc Document Status Value Set"
Description: "Allowed document status codes in Codoc"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* http://hl7.org/fhir/document-reference-status#current "Current"
* http://hl7.org/fhir/document-reference-status#superseded "Superseded"
* http://hl7.org/fhir/document-reference-status#entered-in-error "Entered in Error"


// ═══════════════════════════════════════════════════════════════════════════════
// Gender Value Set (using standard FHIR)
// ═══════════════════════════════════════════════════════════════════════════════

ValueSet: CodocGenderVS
Id: codoc-gender
Title: "Codoc Gender Value Set"
Description: "Administrative gender codes"

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* http://hl7.org/fhir/administrative-gender#male "Male"
* http://hl7.org/fhir/administrative-gender#female "Female"
* http://hl7.org/fhir/administrative-gender#other "Other"
* http://hl7.org/fhir/administrative-gender#unknown "Unknown"
