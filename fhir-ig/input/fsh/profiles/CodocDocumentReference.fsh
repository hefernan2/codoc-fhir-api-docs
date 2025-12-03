// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Codoc DocumentReference Profile                                             │
// │  Based on FHIR R4B DocumentReference resource                                │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Profile: CodocDocumentReference
Parent: DocumentReference
Id: CodocDocumentReference
Title: "Codoc DocumentReference"
Description: """
Profile for clinical documents in Codoc systems.

**Key Features:**
- Base64-encoded content (HTML or plain text)
- Links to encounter context
- Author can be Organization or practitioner name
- Source for NLP phenotype extraction
"""

* ^version = "0.1.0"
* ^status = #active
* ^publisher = "Codoc"

// ─────────────────────────────────────────────────────────────────────────────
// Status - Required
// ─────────────────────────────────────────────────────────────────────────────
* status 1..1 MS
* status ^short = "current | superseded | entered-in-error"
* status from CodocDocumentStatusVS (required)

// ─────────────────────────────────────────────────────────────────────────────
// Subject - Required
// ─────────────────────────────────────────────────────────────────────────────
* subject 1..1 MS
* subject ^short = "Patient the document is about"
* subject only Reference(CodocPatient)

// ─────────────────────────────────────────────────────────────────────────────
// Date - Required
// ─────────────────────────────────────────────────────────────────────────────
* date 1..1 MS
* date ^short = "Document creation date/time"

// ─────────────────────────────────────────────────────────────────────────────
// Author - Optional
// ─────────────────────────────────────────────────────────────────────────────
* author MS
* author ^short = "Document author(s)"
* author ^definition = "Can be an Organization (department) or a practitioner name in display"
* author only Reference(Organization or Practitioner or PractitionerRole)

// ─────────────────────────────────────────────────────────────────────────────
// Content - Required
// ─────────────────────────────────────────────────────────────────────────────
* content 1..* MS
* content ^short = "Document content"

* content.attachment 1..1 MS
* content.attachment ^short = "Where the document content is found"

* content.attachment.contentType 1..1 MS
* content.attachment.contentType ^short = "MIME type: text/html or text/plain"

* content.attachment.data 1..1 MS
* content.attachment.data ^short = "Base64-encoded document content"

* content.attachment.title MS
* content.attachment.title ^short = "Document title"

// ─────────────────────────────────────────────────────────────────────────────
// Context - Optional
// ─────────────────────────────────────────────────────────────────────────────
* context MS
* context ^short = "Clinical context of the document"

* context.encounter MS
* context.encounter ^short = "Associated encounter(s)"
* context.encounter only Reference(CodocEncounter)


// ╭──────────────────────────────────────────────────────────────────────────────╮
// │  Examples                                                                    │
// ╰──────────────────────────────────────────────────────────────────────────────╯

Instance: document-example
InstanceOf: CodocDocumentReference
Title: "DocumentReference Example - Clinical Report"
Description: "Example of a clinical document with HTML content"
Usage: #example

* status = #current

* subject = Reference(Patient/1)
* subject.display = "John Smith"

* date = "2024-01-15T10:00:00Z"

* author[0].display = "Dr. Smith"

* author[1] = Reference(Organization/department-2)
* author[1].type = "Organization"
* author[1].display = "Emergency Department"

* content[0].attachment.contentType = #text/html
* content[0].attachment.data = "PHA+Q2xpbmljYWwgUmVwb3J0PC9wPg=="
* content[0].attachment.title = "Initial Report"

* context.encounter[0] = Reference(Encounter/1)


Instance: document-plain-text-example
InstanceOf: CodocDocumentReference
Title: "DocumentReference Example - Plain Text"
Description: "Example of a plain text clinical document"
Usage: #example

* status = #current

* subject = Reference(Patient/1)

* date = "2024-01-15T14:30:00Z"

* author[0].display = "Dr. Johnson"

* content[0].attachment.contentType = #text/plain
* content[0].attachment.data = "Q29uc3VsdGF0aW9uIHJlcG9ydA=="
* content[0].attachment.title = "Consultation Report"
