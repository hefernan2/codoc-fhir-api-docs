# Extensions

This page documents the FHIR extensions defined in the Codoc Implementation Guide.

## Organization Extensions

### Unit Period Extension

**URL:** `unit_period`

Defines the activity period for a care unit (start and end dates).

| Element | Type | Description |
|---------|------|-------------|
| valuePeriod.start | dateTime | **Required.** Unit opening date |
| valuePeriod.end | dateTime | Optional. Unit closing date (if closed) |

**Context:** Organization

**Usage:**
```json
{
  "extension": [
    {
      "url": "unit_period",
      "valuePeriod": {
        "start": "2025-01-01T00:00:00Z",
        "end": "2025-12-31T23:59:59Z"
      }
    }
  ]
}
```

---

## Phenotype Observation Components

> **Note:** Following FHIR best practices, phenotype NLP metadata is implemented using the standard `Observation.component` pattern rather than custom extensions. This approach provides better interoperability and easier querying.

The [CodocPhenotypeObservation](StructureDefinition-CodocPhenotypeObservation.html) profile uses sliced components with codes from the [CodocPhenotypeComponentsCS](CodeSystem-codoc-phenotype-components.html) code system:

| Component Slice | Code | Value Type | Description |
|-----------------|------|------------|-------------|
| phenotypeFlag | `phenotype` | Integer | Phenotype flag (0 or 1) |
| semanticType | `semantic_type` | String | UMLS semantic type (Disease, Symptom, etc.) |
| tfidfScore | `tfidf_code_document` | Quantity | TF-IDF relevance score (0.0 - 1.0) |
| countConcept | `count_concept` | Integer | Concept occurrence count in document |
| countStrFound | `count_concept_str_found` | Integer | String fragment occurrence count |

**Example:**
```json
{
  "resourceType": "Observation",
  "component": [
    {
      "code": {
        "coding": [{
          "system": "https://codoc.co/fhir/CodeSystem/codoc-phenotype-components",
          "code": "semantic_type"
        }]
      },
      "valueString": "Disease"
    },
    {
      "code": {
        "coding": [{
          "system": "https://codoc.co/fhir/CodeSystem/codoc-phenotype-components",
          "code": "tfidf_code_document"
        }]
      },
      "valueQuantity": {
        "value": 0.85
      }
    }
  ]
}
```

---

## Extension Summary

| Extension | Context | Value Type | Description |
|-----------|---------|------------|-------------|
| unit-period | Organization | Period | Activity period for care units |
