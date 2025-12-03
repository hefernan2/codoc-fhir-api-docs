// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Extensions                                                            │
// ╰──────────────────────────────────────────────────────────────────────────────╯

// ═══════════════════════════════════════════════════════════════════════════════
// Unit Period Extension
// ═══════════════════════════════════════════════════════════════════════════════

Extension: UnitPeriod
Id: unit-period
Title: "Unit Period"
Description: """
Activity period for a care unit indicating when the unit was active.

This extension is used on Organization resources representing care units to
track their operational period (opening and closing dates).
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"
* ^url = "unit_period"
* ^context[0].type = #element
* ^context[0].expression = "Organization"

* value[x] only Period
* valuePeriod 1..1
* valuePeriod.start 1..1 MS
* valuePeriod.start ^short = "Unit opening date"
* valuePeriod.end MS
* valuePeriod.end ^short = "Unit closing date (if closed)"


// ═══════════════════════════════════════════════════════════════════════════════
// Note on Phenotype Metadata
// ═══════════════════════════════════════════════════════════════════════════════

// Phenotype NLP metadata (semantic type, TF-IDF scores, counts) is implemented 
// using the Observation.component pattern rather than extensions, following 
// FHIR best practices for observation-related data.
//
// See CodocPhenotypeObservation profile for component definitions.
// See CodocPhenotypeComponentsCS for the code system defining component codes.
