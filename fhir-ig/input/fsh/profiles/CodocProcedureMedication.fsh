// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Procedure, MedicationRequest, DiagnosticReport Profiles               │
// │  Based on FHIR R4B resources                                                 │
// ╰──────────────────────────────────────────────────────────────────────────────╯

// ═══════════════════════════════════════════════════════════════════════════════
// Procedure Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocProcedure
Parent: Procedure
Id: CodocProcedure
Title: "Codoc Procedure"
Description: """
Profile for medical procedures in Codoc systems.

**Key Features:**
- CCAM code binding for French procedures
- Links to patient and encounter
- Filtered by thesaurus "Acte"
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* identifier MS
* identifier ^short = "Procedure identifiers"
* identifier ^definition = "Official (pk) and usual (id_source) identifiers"

* status 1..1 MS
* status ^short = "preparation | in-progress | completed | cancelled | unknown"
* status ^comment = "API always returns 'unknown'"

* code 1..1 MS
* code ^short = "Procedure code from thesaurus 'Acte' (CCAM)"

* subject 1..1 MS
* subject only Reference(CodocPatient)

* encounter MS
* encounter only Reference(CodocEncounter)

* performedDateTime 1..1 MS
* performedDateTime ^short = "When the procedure was performed (REQUIRED)"

* performer MS
* performer ^short = "Who performed the procedure"
* performer.actor only Reference(CodocOrganization)
* performer.actor ^short = "Department or Unit that performed the procedure"


// ═══════════════════════════════════════════════════════════════════════════════
// MedicationRequest Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocMedicationRequest
Parent: MedicationRequest
Id: CodocMedicationRequest
Title: "Codoc MedicationRequest"
Description: """
Profile for medication prescriptions in Codoc systems.

**Key Features:**
- ATC code binding for medications
- Links to patient and encounter
- Filtered by thesaurus "Prescription"
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* status 1..1 MS
* status ^short = "active | on-hold | cancelled | completed | unknown"
* status ^comment = "API always returns 'unknown'"

* intent 1..1 MS
* intent ^short = "proposal | plan | order"
* intent ^comment = "API always returns 'order'"

* medicationCodeableConcept 1..1 MS
* medicationCodeableConcept ^short = "Medication code from thesaurus 'Prescription' (ATC)"

* subject 1..1 MS
* subject only Reference(CodocPatient)

* encounter MS
* encounter only Reference(CodocEncounter)

* authoredOn 1..1 MS
* authoredOn ^short = "When request was authored (REQUIRED)"

* performer MS
* performer ^short = "Prescribing department"
* performer only Reference(CodocOrganization)

* dosageInstruction MS
* dosageInstruction ^short = "Dosing instructions"
* dosageInstruction.doseAndRate MS
* dosageInstruction.doseAndRate.doseQuantity MS
* dosageInstruction.doseAndRate.doseQuantity ^short = "Dose with unit (e.g., 500 mg)"
* dosageInstruction.timing MS
* dosageInstruction.timing.repeat MS
* dosageInstruction.timing.repeat.frequency MS
* dosageInstruction.timing.repeat.frequency ^short = "Number of times per period"
* dosageInstruction.timing.repeat.period MS
* dosageInstruction.timing.repeat.periodUnit MS
* dosageInstruction.route MS
* dosageInstruction.route ^short = "Route of administration (oral, IV, etc.)"

* dispenseRequest MS
* dispenseRequest ^short = "Dispensing request details"
* dispenseRequest.validityPeriod MS
* dispenseRequest.validityPeriod ^short = "Prescription validity period"


// ═══════════════════════════════════════════════════════════════════════════════
// DiagnosticReport Profile
// ═══════════════════════════════════════════════════════════════════════════════

Profile: CodocDiagnosticReport
Parent: DiagnosticReport
Id: CodocDiagnosticReport
Title: "Codoc DiagnosticReport"
Description: """
Profile for diagnostic reports in Codoc systems.

**Examples:** Imaging reports, EFR, ECG
**Filtered by:** thesaurus "Diagnostic"
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

* status 1..1 MS
* status ^short = "registered | partial | final | amended | unknown"
* status ^comment = "API always returns 'unknown'"

* code 1..1 MS
* code ^short = "Type of diagnostic report from thesaurus 'Diagnostic'"

* subject 1..1 MS
* subject only Reference(CodocPatient)

* encounter MS
* encounter only Reference(CodocEncounter)

* effectiveDateTime 1..1 MS
* effectiveDateTime ^short = "Clinically relevant time (REQUIRED)"

* issued MS
* issued ^short = "DateTime this report was issued"

* performer MS
* performer ^short = "Responsible department"
* performer only Reference(CodocOrganization)

* conclusion MS
* conclusion ^short = "Clinical conclusion text"

* result MS
* result ^short = "Associated observations"
* result only Reference(CodocLabObservation or CodocPatientDataObservation)


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Examples                                                                    │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: procedure-example
InstanceOf: CodocProcedure
Title: "Procedure Example - Cardiac Catheterization"
Description: "Example of a medical procedure"
Usage: #example

* status = #completed

* code.coding[0].system = "https://www.ameli.fr/accueil-de-la-ccam"
* code.coding[0].code = #YYYY123
* code.coding[0].display = "Cardiac Catheterization"

* subject = Reference(Patient/1)
* encounter = Reference(Encounter/1)
* performedDateTime = "2024-01-16T14:00:00Z"


Instance: medication-request-example
InstanceOf: CodocMedicationRequest
Title: "MedicationRequest Example - Aspirin"
Description: "Example of a medication prescription"
Usage: #example

* status = #active
* intent = #order

* medicationCodeableConcept.coding[0].system = "http://www.whocc.no/atc"
* medicationCodeableConcept.coding[0].code = #B01AC06
* medicationCodeableConcept.coding[0].display = "Acetylsalicylic acid"

* subject = Reference(Patient/1)
* encounter = Reference(Encounter/1)
* authoredOn = "2024-01-15T09:00:00Z"


Instance: diagnostic-report-example
InstanceOf: CodocDiagnosticReport
Title: "DiagnosticReport Example - ECG"
Description: "Example of an ECG diagnostic report"
Usage: #example

* status = #final

* code.coding[0].code = #ECG
* code.coding[0].display = "Electrocardiogram"

* subject = Reference(Patient/1)
* encounter = Reference(Encounter/1)

* effectiveDateTime = "2024-01-15T10:30:00Z"
* issued = "2024-01-15T11:00:00Z"
