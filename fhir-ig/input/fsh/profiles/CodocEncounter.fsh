// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Encounter Profile                                                     │
// │  Based on FHIR R4B Encounter resource                                        │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Profile: CodocEncounter
Parent: Encounter
Id: CodocEncounter
Title: "Codoc Encounter"
Description: """
Profile for hospital stays and intra-hospital movements in Codoc systems.

**Key Concepts:**
- **Stay**: Complete hospitalization (no `partOf`)
- **Movement**: Intra-hospital transfer (`partOf` references a Stay)

**Supported Classes:**
- IMP (Inpatient), AMB (Ambulatory), EMER (Emergency), HH (Home Health)
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// ─────────────────────────────────────────────────────────────────────────────
// Identifier - Optional
// ─────────────────────────────────────────────────────────────────────────────
* identifier MS
* identifier ^short = "Encounter identifier (e.g., ADM001, MOV001)"

// ─────────────────────────────────────────────────────────────────────────────
// Status - Required
// ─────────────────────────────────────────────────────────────────────────────
* status 1..1 MS
* status ^short = "planned | in-progress | finished | cancelled"
* status from CodocEncounterStatusVS (required)

// ─────────────────────────────────────────────────────────────────────────────
// Class - Required
// ─────────────────────────────────────────────────────────────────────────────
* class 1..1 MS
* class ^short = "Classification of the encounter"
* class ^definition = "IMP (inpatient), AMB (ambulatory), EMER (emergency), HH (home health)"
* class from CodocEncounterClassVS (required)

// ─────────────────────────────────────────────────────────────────────────────
// Subject - Required
// ─────────────────────────────────────────────────────────────────────────────
* subject 1..1 MS
* subject ^short = "The patient present at the encounter"
* subject only Reference(CodocPatient)

// ─────────────────────────────────────────────────────────────────────────────
// Period - Required (at least start)
// ─────────────────────────────────────────────────────────────────────────────
* period 1..1 MS
* period ^short = "The start and end time of the encounter"

* period.start 1..1 MS
* period.start ^short = "Admission date/time"

* period.end MS
* period.end ^short = "Discharge date/time (when finished)"

// ─────────────────────────────────────────────────────────────────────────────
// Service Provider - Optional
// ─────────────────────────────────────────────────────────────────────────────
* serviceProvider MS
* serviceProvider ^short = "Organization responsible for this encounter"
* serviceProvider only Reference(CodocOrganization)

// ─────────────────────────────────────────────────────────────────────────────
// Part Of - Optional (for movements)
// ─────────────────────────────────────────────────────────────────────────────
* partOf MS
* partOf ^short = "Parent stay (for movements only)"
* partOf ^definition = "If present, this encounter is a movement within the referenced stay."
* partOf only Reference(CodocEncounter)

// ─────────────────────────────────────────────────────────────────────────────
// Hospitalization - Optional
// ─────────────────────────────────────────────────────────────────────────────
* hospitalization MS
* hospitalization ^short = "Details about the admission and discharge"

* hospitalization.admitSource MS
* hospitalization.admitSource ^short = "Source of admission"

* hospitalization.dischargeDisposition MS
* hospitalization.dischargeDisposition ^short = "Discharge disposition"

// ─────────────────────────────────────────────────────────────────────────────
// Location - Optional
// ─────────────────────────────────────────────────────────────────────────────
* location MS
* location ^short = "Location(s) where the encounter takes place"


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Examples                                                                    │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: encounter-stay-example
InstanceOf: CodocEncounter
Title: "Encounter Example - Hospital Stay"
Description: "Example of a hospital stay (no partOf)"
Usage: #example

* identifier[0].use = #usual
* identifier[0].value = "ADM001"

* status = #in-progress

* class.system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* class.code = #IMP
* class.display = "inpatient encounter"

* subject = Reference(Patient/123)
* subject.display = "John Smith"

* serviceProvider = Reference(Organization/department-1)
* serviceProvider.display = "Cardiology Department"

* period.start = "2024-01-15T08:00:00Z"

* hospitalization.admitSource.coding[0].code = #hosp-trans
* hospitalization.admitSource.coding[0].display = "Transferred from other hospital"


Instance: encounter-movement-example
InstanceOf: CodocEncounter
Title: "Encounter Example - Movement"
Description: "Example of an intra-hospital movement"
Usage: #example

* identifier[0].use = #usual
* identifier[0].value = "MOV001"

* status = #in-progress

* class.system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* class.code = #IMP
* class.display = "inpatient encounter"

* subject = Reference(Patient/123)
* subject.display = "John Smith"

* serviceProvider = Reference(Organization/unit-1)
* serviceProvider.display = "Intensive Care Unit"

* period.start = "2024-01-17T02:00:00Z"

* partOf = Reference(Encounter/1)
* partOf.display = "Main Stay ADM001"


Instance: encounter-finished-example
InstanceOf: CodocEncounter
Title: "Encounter Example - Finished Stay"
Description: "Example of a completed hospital stay"
Usage: #example

* identifier[0].use = #usual
* identifier[0].value = "ADM002"

* status = #finished

* class.system = "http://terminology.hl7.org/CodeSystem/v3-ActCode"
* class.code = #IMP
* class.display = "inpatient encounter"

* subject = Reference(Patient/456)
* subject.display = "Jane Doe"

* serviceProvider = Reference(Organization/department-1)

* period.start = "2024-01-10T10:00:00Z"
* period.end = "2024-01-15T16:00:00Z"

* hospitalization.dischargeDisposition.coding[0].code = #home
* hospitalization.dischargeDisposition.coding[0].display = "Discharged to home"
