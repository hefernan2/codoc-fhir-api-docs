// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Capability Statement                                                  │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: codoc-capability-statement
InstanceOf: CapabilityStatement
Title: "Codoc FHIR Server Capability Statement"
Description: "Capability Statement for the Codoc FHIR Server"
Usage: #definition

* url = "https://codoc.co/fhir/CapabilityStatement/codoc-capability-statement"
* version = "0.1.0"
* name = "CodocCapabilityStatement"
* title = "Codoc FHIR Server Capability Statement"
* status = #active
* experimental = false
* date = "2025-01-01"
* publisher = "Codoc"
* jurisdiction = urn:iso:std:iso:3166#FR "France"
* description = """
This CapabilityStatement describes the requirements for servers implementing the Codoc FHIR Implementation Guide.
It defines the expected RESTful capabilities, supported resources, and search parameters for
a Codoc-compliant FHIR server optimized for hospital data management.
"""

* kind = #requirements
* instantiates = "http://hl7.org/fhir/CapabilityStatement/base"
* fhirVersion = #4.3.0
* format[0] = #json
* format[1] = #xml

// ─────────────────────────────────────────────────────────────────────────────
// REST Configuration
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].mode = #server
* rest[0].documentation = "Codoc FHIR Server REST API"

// ─────────────────────────────────────────────────────────────────────────────
// Patient Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[0].type = #Patient
* rest[0].resource[0].profile = "https://codoc.co/fhir/StructureDefinition/CodocPatient"
* rest[0].resource[0].documentation = "Patient identity and demographics with multi-IPP support"
* rest[0].resource[0].interaction[0].code = #read
* rest[0].resource[0].interaction[1].code = #create
* rest[0].resource[0].interaction[2].code = #update
* rest[0].resource[0].interaction[3].code = #patch
* rest[0].resource[0].interaction[4].code = #delete
* rest[0].resource[0].interaction[5].code = #search-type

* rest[0].resource[0].searchParam[0].name = "identifier"
* rest[0].resource[0].searchParam[0].type = #token
* rest[0].resource[0].searchParam[0].documentation = "Patient IPP"

* rest[0].resource[0].searchParam[1].name = "name"
* rest[0].resource[0].searchParam[1].type = #string
* rest[0].resource[0].searchParam[1].documentation = "Patient name"

* rest[0].resource[0].searchParam[2].name = "birthdate"
* rest[0].resource[0].searchParam[2].type = #date
* rest[0].resource[0].searchParam[2].documentation = "Date of birth"

* rest[0].resource[0].searchParam[3].name = "gender"
* rest[0].resource[0].searchParam[3].type = #token
* rest[0].resource[0].searchParam[3].documentation = "Gender"

// ─────────────────────────────────────────────────────────────────────────────
// Organization Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[1].type = #Organization
* rest[0].resource[1].profile = "https://codoc.co/fhir/StructureDefinition/CodocOrganization"
* rest[0].resource[1].documentation = "Hospital organizational hierarchy"
* rest[0].resource[1].interaction[0].code = #read
* rest[0].resource[1].interaction[1].code = #create
* rest[0].resource[1].interaction[2].code = #update
* rest[0].resource[1].interaction[3].code = #delete
* rest[0].resource[1].interaction[4].code = #search-type

* rest[0].resource[1].searchParam[0].name = "identifier"
* rest[0].resource[1].searchParam[0].type = #token
* rest[0].resource[1].searchParam[0].documentation = "Organization code"

* rest[0].resource[1].searchParam[1].name = "type"
* rest[0].resource[1].searchParam[1].type = #token
* rest[0].resource[1].searchParam[1].documentation = "Organization type"

* rest[0].resource[1].searchParam[2].name = "partof"
* rest[0].resource[1].searchParam[2].type = #reference
* rest[0].resource[1].searchParam[2].documentation = "Parent organization"

// ─────────────────────────────────────────────────────────────────────────────
// Encounter Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[2].type = #Encounter
* rest[0].resource[2].profile = "https://codoc.co/fhir/StructureDefinition/CodocEncounter"
* rest[0].resource[2].documentation = "Hospital stays and movements"
* rest[0].resource[2].interaction[0].code = #read
* rest[0].resource[2].interaction[1].code = #create
* rest[0].resource[2].interaction[2].code = #update
* rest[0].resource[2].interaction[3].code = #patch
* rest[0].resource[2].interaction[4].code = #delete
* rest[0].resource[2].interaction[5].code = #search-type

* rest[0].resource[2].searchParam[0].name = "patient"
* rest[0].resource[2].searchParam[0].type = #reference
* rest[0].resource[2].searchParam[0].documentation = "Patient reference"

* rest[0].resource[2].searchParam[1].name = "status"
* rest[0].resource[2].searchParam[1].type = #token
* rest[0].resource[2].searchParam[1].documentation = "Encounter status"

* rest[0].resource[2].searchParam[2].name = "class"
* rest[0].resource[2].searchParam[2].type = #token
* rest[0].resource[2].searchParam[2].documentation = "Encounter class"

* rest[0].resource[2].searchParam[3].name = "date"
* rest[0].resource[2].searchParam[3].type = #date
* rest[0].resource[2].searchParam[3].documentation = "Encounter period"

// ─────────────────────────────────────────────────────────────────────────────
// DocumentReference Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[3].type = #DocumentReference
* rest[0].resource[3].profile = "https://codoc.co/fhir/StructureDefinition/CodocDocumentReference"
* rest[0].resource[3].documentation = "Clinical documents"
* rest[0].resource[3].interaction[0].code = #read
* rest[0].resource[3].interaction[1].code = #create
* rest[0].resource[3].interaction[2].code = #update
* rest[0].resource[3].interaction[3].code = #delete
* rest[0].resource[3].interaction[4].code = #search-type

* rest[0].resource[3].searchParam[0].name = "patient"
* rest[0].resource[3].searchParam[0].type = #reference
* rest[0].resource[3].searchParam[0].documentation = "Patient reference"

* rest[0].resource[3].searchParam[1].name = "encounter"
* rest[0].resource[3].searchParam[1].type = #reference
* rest[0].resource[3].searchParam[1].documentation = "Encounter reference"

* rest[0].resource[3].searchParam[2].name = "date"
* rest[0].resource[3].searchParam[2].type = #date
* rest[0].resource[3].searchParam[2].documentation = "Document date"

// ─────────────────────────────────────────────────────────────────────────────
// Observation Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[4].type = #Observation
* rest[0].resource[4].supportedProfile[0] = "https://codoc.co/fhir/StructureDefinition/CodocLabObservation"
* rest[0].resource[4].supportedProfile[1] = "https://codoc.co/fhir/StructureDefinition/CodocPatientDataObservation"
* rest[0].resource[4].supportedProfile[2] = "https://codoc.co/fhir/StructureDefinition/CodocPhenotypeObservation"
* rest[0].resource[4].documentation = "Lab results, patient data, and NLP phenotypes"
* rest[0].resource[4].interaction[0].code = #read
* rest[0].resource[4].interaction[1].code = #create
* rest[0].resource[4].interaction[2].code = #update
* rest[0].resource[4].interaction[3].code = #delete
* rest[0].resource[4].interaction[4].code = #search-type

* rest[0].resource[4].searchParam[0].name = "patient"
* rest[0].resource[4].searchParam[0].type = #reference
* rest[0].resource[4].searchParam[0].documentation = "Patient reference"

* rest[0].resource[4].searchParam[1].name = "code"
* rest[0].resource[4].searchParam[1].type = #token
* rest[0].resource[4].searchParam[1].documentation = "Observation code"

* rest[0].resource[4].searchParam[2].name = "date"
* rest[0].resource[4].searchParam[2].type = #date
* rest[0].resource[4].searchParam[2].documentation = "Observation date"

* rest[0].resource[4].searchParam[3].name = "status"
* rest[0].resource[4].searchParam[3].type = #token
* rest[0].resource[4].searchParam[3].documentation = "Observation status"

// ─────────────────────────────────────────────────────────────────────────────
// Procedure Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[5].type = #Procedure
* rest[0].resource[5].profile = "https://codoc.co/fhir/StructureDefinition/CodocProcedure"
* rest[0].resource[5].documentation = "Medical procedures (CCAM)"
* rest[0].resource[5].interaction[0].code = #read
* rest[0].resource[5].interaction[1].code = #create
* rest[0].resource[5].interaction[2].code = #update
* rest[0].resource[5].interaction[3].code = #delete
* rest[0].resource[5].interaction[4].code = #search-type

// ─────────────────────────────────────────────────────────────────────────────
// MedicationRequest Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[6].type = #MedicationRequest
* rest[0].resource[6].profile = "https://codoc.co/fhir/StructureDefinition/CodocMedicationRequest"
* rest[0].resource[6].documentation = "Medication prescriptions (ATC)"
* rest[0].resource[6].interaction[0].code = #read
* rest[0].resource[6].interaction[1].code = #create
* rest[0].resource[6].interaction[2].code = #update
* rest[0].resource[6].interaction[3].code = #delete
* rest[0].resource[6].interaction[4].code = #search-type

// ─────────────────────────────────────────────────────────────────────────────
// DiagnosticReport Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[7].type = #DiagnosticReport
* rest[0].resource[7].profile = "https://codoc.co/fhir/StructureDefinition/CodocDiagnosticReport"
* rest[0].resource[7].documentation = "Diagnostic reports"
* rest[0].resource[7].interaction[0].code = #read
* rest[0].resource[7].interaction[1].code = #create
* rest[0].resource[7].interaction[2].code = #update
* rest[0].resource[7].interaction[3].code = #delete
* rest[0].resource[7].interaction[4].code = #search-type

// ─────────────────────────────────────────────────────────────────────────────
// Bundle Resource
// ─────────────────────────────────────────────────────────────────────────────
* rest[0].resource[8].type = #Bundle
* rest[0].resource[8].documentation = "Batch operations"
* rest[0].resource[8].interaction[0].code = #create
