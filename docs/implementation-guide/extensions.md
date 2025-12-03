---
title: Extensions
---

# FHIR Extensions

This page documents all FHIR extensions defined in the Codoc Implementation Guide.

## Organization Extensions

### Unit Period

**URL:** `unit_period`

Defines the activity period for a care unit, indicating when the unit was active or operational.

| Property | Value |
|----------|-------|
| Context | Organization |
| Value Type | Period |
| Cardinality | 0..1 |

#### Usage

```json
{
  "resourceType": "Organization",
  "name": "Intensive Care Unit",
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

!!! info "Component Pattern"
    Phenotype metadata is implemented using the `Observation.component` pattern following FHIR best practices. This provides better tool support and clearer semantic meaning than extensions.

The [CodocPhenotypeObservation](profiles.md#codocphenotypeobservation) profile uses sliced components with codes from the `CodocPhenotypeComponentsCS` code system:

| Component Slice | Code | Value Type | Description |
|-----------------|------|------------|-------------|
| phenotypeFlag | `phenotype` | Integer | Phenotype flag (0 or 1) |
| semanticType | `semantic_type` | String | UMLS semantic type (Disease, Symptom, Finding, etc.) |
| tfidfScore | `tfidf_code_document` | Quantity | TF-IDF relevance score (0.0 - 1.0) |
| countConcept | `count_concept` | Integer | Concept occurrence count in document |
| countStrFound | `count_concept_str_found` | Integer | String fragment occurrence count |

### Example: Phenotype with Metadata

```json
{
  "resourceType": "Observation",
  "status": "final",
  "code": {
    "coding": [{"code": "I10", "display": "Essential hypertension"}]
  },
  "subject": {"reference": "Patient/1"},
  "derivedFrom": [{"reference": "DocumentReference/10"}],
  "valueString": "essential hypertension",
  "component": [
    {
      "code": {"coding": [{"code": "phenotype"}]},
      "valueInteger": 1
    },
    {
      "code": {"coding": [{"code": "semantic_type"}]},
      "valueString": "Disease"
    },
    {
      "code": {"coding": [{"code": "tfidf_code_document"}]},
      "valueQuantity": {"value": 0.85}
    },
    {
      "code": {"coding": [{"code": "count_concept"}]},
      "valueInteger": 2
    },
    {
      "code": {"coding": [{"code": "count_concept_str_found"}]},
      "valueInteger": 1
    }
  ]
}
```

---

## Extension Summary

| Extension | Context | Type | Description |
|-----------|---------|------|-------------|
| `unit_period` | Organization | Period | Activity period for care units |
