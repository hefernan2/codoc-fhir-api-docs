# Codoc FHIR Implementation Guide

Welcome to the **Codoc FHIR Implementation Guide**. This guide defines the FHIR profiles, extensions, and value sets used by the Codoc hospital data platform.

## Overview

Codoc is a clinical data platform designed to aggregate, normalize, and enrich hospital data from multiple sources. This Implementation Guide provides:

- **FHIR Profiles** constraining standard FHIR resources for Codoc's use cases
- **Extensions** for Codoc-specific data elements
- **Value Sets** and **Code Systems** for controlled vocabularies
- **Capability Statement** defining server behavior

## Scope

This IG covers the following domains:

| Domain | Resources | Description |
|--------|-----------|-------------|
| **Identity** | Patient | Patient demographics with multi-IPP support |
| **Organization** | Organization | Hospital hierarchy (Instance → Site → Department → Unit) |
| **Clinical** | Encounter, DocumentReference | Hospital stays, movements, clinical documents |
| **Observations** | Observation | Lab results, patient data, NLP phenotypes |
| **Procedures** | Procedure, MedicationRequest, DiagnosticReport | Medical acts and prescriptions |

## FHIR Version

This Implementation Guide is based on **FHIR R4B (4.3.0)**.

## Dependencies

- [HL7 FHIR R4B Core](https://hl7.org/fhir/R4B/)

## How to Use This Guide

1. **Profiles** - Review the constrained profiles for each resource type
2. **Extensions** - Understand custom data elements added by Codoc
3. **Terminology** - Explore value sets and code systems
4. **Capability Statement** - See supported operations
5. **API Documentation** - Visit the [Codoc API Docs](https://hefernan2.github.io/codoc-fhir-api-docs/) for detailed usage examples

## Conformance

Resources claiming conformance to Codoc profiles **MUST**:

1. Include all required elements as defined in the profile
2. Use the correct value set bindings
3. Follow the cardinality constraints
4. Validate against the profile's StructureDefinition

## Authors and Contributors

This Implementation Guide is maintained by the Codoc Team.

- Website: [https://codoc.co](https://codoc.co)
- GitHub: [codoc-os](https://github.com/codoc-os)
