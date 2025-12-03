---
title: Implementation Guide
---

# FHIR Implementation Guide

The Codoc FHIR Implementation Guide provides formal definitions of the FHIR profiles, extensions, and terminology used by the Codoc platform.

## What is an Implementation Guide?

A FHIR Implementation Guide (IG) is a set of rules about how FHIR resources are used to solve a particular problem. It includes:

- **Profiles** - Constraints on FHIR resources for specific use cases
- **Extensions** - Custom data elements not in the base specification
- **Value Sets** - Allowed code values for coded elements
- **Code Systems** - Custom terminologies
- **Capability Statement** - Server behavior definition

## Codoc IG Overview

The Codoc IG defines how clinical data is represented in hospital systems, covering:

| Domain | Profiles | Description |
|--------|----------|-------------|
| **Identity** | CodocPatient | Multi-IPP patient identity |
| **Organization** | CodocOrganization | Hospital hierarchy |
| **Clinical** | CodocEncounter, CodocDocumentReference | Stays, documents |
| **Observations** | CodocLabObservation, CodocPhenotypeObservation | Lab results, NLP |
| **Procedures** | CodocProcedure, CodocMedicationRequest | Acts, prescriptions |

## IG Contents

<div class="grid cards" markdown>

-   :material-account:{ .lg .middle } **Profiles**

    ---

    FHIR resource profiles with constraints for Codoc use cases

    [:octicons-arrow-right-24: View Profiles](profiles.md)

-   :material-puzzle:{ .lg .middle } **Extensions**

    ---

    Custom extensions for Codoc-specific data elements

    [:octicons-arrow-right-24: View Extensions](extensions.md)

-   :material-code-tags:{ .lg .middle } **Terminology**

    ---

    Code systems and value sets used by Codoc

    [:octicons-arrow-right-24: View Terminology](terminology.md)

-   :material-server:{ .lg .middle } **Capability Statement**

    ---

    Server capabilities and supported operations

    [:octicons-arrow-right-24: View Capabilities](capability-statement.md)

</div>

## Conformance

Resources claiming conformance to Codoc profiles **MUST**:

1. Include all required elements as defined in the profile
2. Use the correct value set bindings
3. Follow the cardinality constraints
4. Validate against the profile's StructureDefinition

## Related Standards

The Codoc IG is designed to be compatible with:

| Standard | Description | Relationship |
|----------|-------------|--------------|
| **IPS** | International Patient Summary | Patient/Observation patterns |
| **CI-SIS** | French interoperability framework | French healthcare context |
| **OMOP on FHIR** | Research data interoperability | Future extensions |

## Next Steps

- [View Profiles](profiles.md) - Explore Codoc profile definitions
- [API Reference](../api/index.md) - See practical API usage
- [Guides](../guides/index.md) - Step-by-step tutorials
