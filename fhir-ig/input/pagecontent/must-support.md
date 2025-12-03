# Must Support Definition

## Overview

This page defines what "Must Support" (MS) means in the context of the Codoc FHIR Implementation Guide.

## Definition

In Codoc profiles, elements marked with **Must Support** (MS) have the following meaning:

### For Data Producers (Senders)

A system that produces Codoc-conformant resources **SHALL**:

1. **Populate** the element if the data is available in the source system
2. **Not omit** the element to hide information from receivers
3. **Use the correct data type** and value set bindings

### For Data Consumers (Receivers)

A system that consumes Codoc-conformant resources **SHALL**:

1. **Process** the element meaningfully (not ignore it)
2. **Store** the element if persisting the resource
3. **Display** the element when presenting data to users (where appropriate)
4. **Not reject** a resource because a MS element is absent

## Cardinality vs Must Support

| Cardinality | Must Support | Meaning |
|-------------|--------------|---------|
| 1..1 | Yes | Required, must be populated |
| 1..* | Yes | At least one required |
| 0..1 | Yes | Populate if available, process if present |
| 0..* | Yes | Populate if available, process if present |
| 0..1 | No | Optional, may be ignored |
| 0..* | No | Optional, may be ignored |

## Must Support Elements by Profile

### CodocPatient

| Element | MS | Reason |
|---------|:--:|--------|
| `identifier` | ✅ | Essential for patient matching |
| `identifier.value` | ✅ | The actual IPP value |
| `name` | ✅ | Patient identification |
| `name.family` | ✅ | Required for search |
| `name.given` | ✅ | Required for search |
| `gender` | ✅ | Demographics |
| `birthDate` | ✅ | Demographics and age calculation |
| `deceased[x]` | ✅ | Important clinical status |
| `managingOrganization` | ✅ | Care assignment |
| `link` | ✅ | Patient merging |

### CodocOrganization

| Element | MS | Reason |
|---------|:--:|--------|
| `identifier` | ✅ | Organization code |
| `type` | ✅ | Hierarchy level |
| `name` | ✅ | Display name |
| `partOf` | ✅ | Hierarchy relationship |
| `extension[unitPeriod]` | ✅ | Unit activity period |

### CodocEncounter

| Element | MS | Reason |
|---------|:--:|--------|
| `status` | ✅ | Current state |
| `class` | ✅ | Encounter type (IMP/AMB/EMER) |
| `subject` | ✅ | Patient link |
| `period` | ✅ | Admission/discharge dates |
| `period.start` | ✅ | Admission date |
| `serviceProvider` | ✅ | Responsible unit |
| `partOf` | ✅ | Stay/movement relationship |
| `hospitalization` | ✅ | Admission source/discharge disposition |

### CodocDocumentReference

| Element | MS | Reason |
|---------|:--:|--------|
| `status` | ✅ | Document validity |
| `subject` | ✅ | Patient link |
| `date` | ✅ | Document date |
| `author` | ✅ | Authorship |
| `content` | ✅ | Document content |
| `content.attachment.contentType` | ✅ | MIME type |
| `content.attachment.data` | ✅ | Actual content |
| `context.encounter` | ✅ | Clinical context |

### CodocPhenotypeObservation

| Element | MS | Reason |
|---------|:--:|--------|
| `status` | ✅ | Always "final" |
| `code` | ✅ | Phenotype concept |
| `subject` | ✅ | Patient link |
| `derivedFrom` | ✅ | Source document |
| `valueString` | ✅ | Extracted text |
| `component[semanticType]` | ✅ | UMLS type |
| `component[tfidfScore]` | ✅ | Relevance score |
| `component[countConcept]` | ✅ | Occurrence count |

## Missing Data

### When Data is Absent

If a Must Support element has no value, systems may:

1. **Omit the element** - If cardinality allows (0..x)
2. **Use Data Absent Reason extension** - For required elements
3. **Use null flavor codes** - Where appropriate (e.g., gender = "unknown")

### Data Absent Reason Example

```json
{
  "resourceType": "Patient",
  "birthDate": {
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/data-absent-reason",
      "valueCode": "unknown"
    }]
  }
}
```

## Conformance Testing

Systems claiming conformance to Codoc profiles should:

1. ✅ Populate all Must Support elements when data is available
2. ✅ Process all Must Support elements when present in received resources
3. ✅ Not reject resources with absent optional Must Support elements
4. ✅ Use correct value sets for coded elements

## Summary

| Requirement | Sender | Receiver |
|-------------|--------|----------|
| Must Support = Yes + Required (1..) | **SHALL** populate | **SHALL** process |
| Must Support = Yes + Optional (0..) | **SHALL** populate if available | **SHALL** process if present |
| Must Support = No | MAY populate | MAY process or ignore |
