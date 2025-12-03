# Background

## Introduction

The Codoc FHIR Implementation Guide (IG) defines how clinical data is represented and exchanged within Codoc hospital data platforms. This guide provides a standardized approach to interoperability for French hospital systems.

## Problem Statement

Healthcare institutions face significant challenges in:

1. **Data Fragmentation** - Clinical data is scattered across multiple systems (EHR, LIS, RIS, etc.)
2. **Interoperability Gaps** - Different systems use incompatible data formats
3. **NLP Integration** - Extracting structured information from clinical narratives
4. **Multi-site Coordination** - Managing data across hospital groups with multiple sites

## Use Cases

### UC-1: Patient Identity Management

**Actors:** Registration desk, Clinical staff  
**Description:** Create and manage patient identities with support for multiple IPPs (patient identifiers) from different hospital systems.

**Key Requirements:**
- Support for multiple identifiers per patient
- Patient merging when duplicates are detected
- CNIL-compliant anonymization options

### UC-2: Hospital Hierarchy Management

**Actors:** IT administrators, Department heads  
**Description:** Model the organizational structure of a hospital or hospital group.

**Hierarchy Levels:**
```
Instance (Hospital Group)
└── Site (Hospital Campus)
    └── Department (Medical Service)
        └── Unit (Care Unit)
```

### UC-3: Patient Journey Tracking

**Actors:** Clinical staff, Bed managers  
**Description:** Track patient movements through the hospital, from admission to discharge.

**Key Concepts:**
- **Stay**: Complete hospitalization episode
- **Movement**: Transfer between units within a stay

### UC-4: Clinical Document Management

**Actors:** Physicians, Nurses, Medical secretaries  
**Description:** Store and retrieve clinical documents (reports, notes, letters).

**Supported Formats:**
- HTML (rich text)
- Plain text

### UC-5: NLP Phenotype Extraction

**Actors:** NLP pipeline, Data scientists  
**Description:** Extract medical concepts (phenotypes) from clinical documents using Natural Language Processing.

**Key Features:**
- Link phenotypes to source documents
- Store extraction confidence scores (TF-IDF)
- Track UMLS semantic types

### UC-6: Laboratory Results Management

**Actors:** Laboratory staff, Physicians  
**Description:** Store and retrieve laboratory test results.

**Integration:**
- Filtered by "Biologie" thesaurus
- Linked to patient encounters

## Actors and Systems

| Actor | Role | Interactions |
|-------|------|--------------|
| **Hospital Information System (HIS)** | Primary data source | Creates patients, encounters, documents |
| **Laboratory Information System (LIS)** | Lab data source | Sends observation results |
| **NLP Pipeline** | AI/ML system | Extracts phenotypes from documents |
| **Data Warehouse** | Analytics | Queries all resources |
| **Clinical Portal** | End-user interface | Reads patient data |

## Relationship to Other Standards

### IPS (International Patient Summary)

The Codoc Patient profile is compatible with IPS patient requirements, enabling future exchange of patient summaries.

### CI-SIS (French Interoperability Framework)

This IG aligns with CI-SIS principles for French healthcare interoperability, particularly for:
- Patient identification (INS)
- Organization structure (FINESS)
- Procedure coding (CCAM)

### OMOP on FHIR

The observation profiles support mapping to OMOP CDM for multicentric research use cases.

## Glossary

| Term | Definition |
|------|------------|
| **IPP** | Identifiant Permanent du Patient - Hospital-specific patient identifier |
| **NIP** | Numéro d'Identification du Patient - Alternative term for IPP |
| **Stay** | Complete hospitalization episode (séjour) |
| **Movement** | Intra-hospital transfer (mouvement) |
| **Phenotype** | Medical concept extracted from clinical text |
| **TF-IDF** | Term Frequency-Inverse Document Frequency - relevance score |
