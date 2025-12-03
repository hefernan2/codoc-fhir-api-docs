// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Organization Profile                                                  │
// │  Based on FHIR R4B Organization resource                                     │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Profile: CodocOrganization
Parent: Organization
Id: CodocOrganization
Title: "Codoc Organization"
Description: """
Profile for hospital organizational hierarchy in Codoc systems.

**Supported Hierarchy:**
- Instance (Hospital group) → Site → Department → Unit
- Site → Department → Unit
- Instance → Department → Unit

**Key Features:**
- Hierarchical validation enforced by API
- Activity period extension for units
- Aggregated statistics extensions
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// ─────────────────────────────────────────────────────────────────────────────
// Identifier - Required
// ─────────────────────────────────────────────────────────────────────────────
* identifier 1..* MS
* identifier ^short = "Organization code"
* identifier ^definition = "Unique code identifying the organization (e.g., HOSP001, CARDIO, ICU001)"

* identifier.use MS
* identifier.value 1..1 MS

// ─────────────────────────────────────────────────────────────────────────────
// Type - Required
// ─────────────────────────────────────────────────────────────────────────────
* type 1..* MS
* type ^short = "Organization type"
* type ^definition = "The type of organization: instance, site, department, or unit"
* type from CodocOrganizationTypeVS (extensible)

* type.coding 1..* MS
* type.coding.code 1..1 MS

// ─────────────────────────────────────────────────────────────────────────────
// Name - Required
// ─────────────────────────────────────────────────────────────────────────────
* name 1..1 MS
* name ^short = "Organization name"
* name ^definition = "The full name of the organization"

// ─────────────────────────────────────────────────────────────────────────────
// PartOf - Conditional (required for department and unit)
// ─────────────────────────────────────────────────────────────────────────────
* partOf MS
* partOf ^short = "Parent organization"
* partOf ^definition = """
Reference to the parent organization. Required for:
- **Department**: Must reference an Instance or Site
- **Unit**: Must reference a Department
"""
* partOf only Reference(CodocOrganization)

// ─────────────────────────────────────────────────────────────────────────────
// Extension: Unit Period
// ─────────────────────────────────────────────────────────────────────────────
* extension contains UnitPeriod named unitPeriod 0..1 MS
* extension[unitPeriod] ^short = "Activity period for the unit"


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Examples                                                                    │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: organization-site-example
InstanceOf: CodocOrganization
Title: "Organization Example - Hospital Site"
Description: "Example of a hospital site"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "site-1"

* identifier[1].use = #usual
* identifier[1].value = "HOSP001"

* type[0].coding[0].system = "https://codoc.co/fhir/CodeSystem/codoc-organization-type"
* type[0].coding[0].code = #prov
* type[0].coding[0].display = "Healthcare Provider"

* name = "Paris University Hospital"


Instance: organization-dept-example
InstanceOf: CodocOrganization
Title: "Organization Example - Department"
Description: "Example of a hospital department"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "department-1"

* identifier[1].use = #usual
* identifier[1].value = "CARD001"

* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/organization-type"
* type[0].coding[0].code = #dept
* type[0].coding[0].display = "Hospital Department"

* name = "Cardiology Department"
* partOf = Reference(Organization/site-1)
* partOf.display = "Paris University Hospital"


Instance: organization-unit-example
InstanceOf: CodocOrganization
Title: "Organization Example - Care Unit"
Description: "Example of a care unit with activity period"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "unit-1"

* identifier[1].use = #usual
* identifier[1].value = "ICU001"

* type[0].coding[0].system = "http://terminology.hl7.org/CodeSystem/organization-type"
* type[0].coding[0].code = #team
* type[0].coding[0].display = "Organizational team"

* name = "Intensive Care Unit"
* partOf = Reference(Organization/department-1)
* partOf.display = "Cardiology Department"

* extension[unitPeriod].valuePeriod.start = "2025-01-01T00:00:00Z"
* extension[unitPeriod].valuePeriod.end = "2025-12-31T23:59:59Z"
