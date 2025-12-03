// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc Patient Profile                                                       │
// │  Based on FHIR R4B Patient resource                                          │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Profile: CodocPatient
Parent: Patient
Id: CodocPatient
Title: "Codoc Patient"
Description: """
Profile for patient identity and demographics in Codoc hospital systems.

**Key Features:**
- Multi-IPP support with `official` (internal ID) and `usual` (hospital IPP) identifiers
- Patient merging support via `link[]` with type `replaced-by`
- CNIL-compliant: sensitive data can be anonymized
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// ─────────────────────────────────────────────────────────────────────────────
// Identifier - Required, supports multi-IPP
// ─────────────────────────────────────────────────────────────────────────────
* identifier 1..* MS
* identifier ^short = "Patient identifiers (IPP/NIP)"
* identifier ^definition = "At least one identifier is required. Supports multiple IPPs."
* identifier ^comment = "Use 'official' for internal Codoc ID, 'usual' for hospital IPP/NIP"

* identifier.use MS
* identifier.use ^short = "official | usual"
* identifier.value 1..1 MS
* identifier.value ^short = "The identifier value"

// ─────────────────────────────────────────────────────────────────────────────
// Name - Required
// ─────────────────────────────────────────────────────────────────────────────
* name 1..* MS
* name ^short = "Patient name"
* name ^definition = "The patient's legal name. For anonymous patients, use placeholder values."

* name.family 1..1 MS
* name.family ^short = "Family name (last name)"

* name.given 1..* MS
* name.given ^short = "Given name(s) (first name)"

// ─────────────────────────────────────────────────────────────────────────────
// Gender - Required
// ─────────────────────────────────────────────────────────────────────────────
* gender 1..1 MS
* gender ^short = "male | female | other | unknown"
* gender ^definition = "Administrative gender. Use 'unknown' for CNIL compliance when data is anonymized."

// ─────────────────────────────────────────────────────────────────────────────
// Birth Date - Required
// ─────────────────────────────────────────────────────────────────────────────
* birthDate 1..1 MS
* birthDate ^short = "Date of birth (YYYY-MM-DD)"
* birthDate ^definition = "The patient's date of birth in ISO 8601 format."

// ─────────────────────────────────────────────────────────────────────────────
// Deceased - Optional
// ─────────────────────────────────────────────────────────────────────────────
* deceased[x] MS
* deceased[x] ^short = "Indicates if the patient is deceased"
* deceased[x] ^comment = "Use either deceasedBoolean OR deceasedDateTime, never both."

// ─────────────────────────────────────────────────────────────────────────────
// Managing Organization - Optional
// ─────────────────────────────────────────────────────────────────────────────
* managingOrganization MS
* managingOrganization ^short = "Organization managing this patient"
* managingOrganization ^definition = "The organization (department/unit) responsible for the patient."
* managingOrganization only Reference(CodocOrganization)

// ─────────────────────────────────────────────────────────────────────────────
// Link - Optional (for patient merging)
// ─────────────────────────────────────────────────────────────────────────────
* link MS
* link ^short = "Link to another patient (for merging)"
* link ^definition = "Used for patient merging. When type='replaced-by', this patient has been merged into the referenced patient."

* link.other only Reference(CodocPatient)
* link.type MS
* link.type ^short = "replaced-by | replaces | refer | seealso"

// ─────────────────────────────────────────────────────────────────────────────
// Contact Information - Optional
// ─────────────────────────────────────────────────────────────────────────────
* telecom MS
* telecom ^short = "Contact details (phone, email)"

* address MS
* address ^short = "Patient address"


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Example: Basic Patient                                                      │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: patient-example
InstanceOf: CodocPatient
Title: "Patient Example - John Smith"
Description: "Example of a Codoc patient with multi-IPP"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "123"

* identifier[1].use = #usual
* identifier[1].system = "HIS"
* identifier[1].value = "IPP123456"

* name[0].family = "Smith"
* name[0].given[0] = "John"
* name[0].given[1] = "Peter"

* gender = #male
* birthDate = "1980-05-15"

* managingOrganization = Reference(Organization/department-1)
* managingOrganization.display = "Cardiology Department"


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Example: Deceased Patient                                                   │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: patient-deceased-example
InstanceOf: CodocPatient
Title: "Patient Example - Deceased"
Description: "Example of a deceased patient"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "456"

* identifier[1].use = #usual
* identifier[1].value = "IPP789012"

* name[0].family = "Doe"
* name[0].given[0] = "Jane"

* gender = #female
* birthDate = "1945-03-20"
* deceasedDateTime = "2024-01-15T14:30:00Z"


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Example: Merged Patient                                                     │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: patient-merged-example
InstanceOf: CodocPatient
Title: "Patient Example - Merged"
Description: "Example of a patient that has been merged into another"
Usage: #example

* identifier[0].use = #official
* identifier[0].value = "789"

* identifier[1].use = #usual
* identifier[1].value = "IPP_OLD_001"

* name[0].family = "Smith"
* name[0].given[0] = "John"

* gender = #male
* birthDate = "1980-05-15"

* link[0].other = Reference(Patient/123)
* link[0].type = #replaced-by
