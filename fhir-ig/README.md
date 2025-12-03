# Codoc FHIR Implementation Guide

This directory contains the FHIR Implementation Guide (IG) for the Codoc platform, built using [FHIR Shorthand (FSH)](https://fshschool.org/) and the [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher).

## Directory Structure

```
fhir-ig/
├── sushi-config.yaml          # SUSHI/IG configuration
├── ig.ini                      # IG Publisher config
├── _sushi.sh                   # Script to compile FSH only
├── _genonce.sh                 # Script to build full IG
├── input/
│   ├── fsh/
│   │   ├── profiles/          # FHIR profile definitions
│   │   ├── extensions/        # Extension definitions
│   │   ├── terminology/       # CodeSystems and ValueSets
│   │   └── CapabilityStatement.fsh
│   └── pagecontent/           # Narrative markdown pages
└── fsh-generated/             # Generated FHIR resources (after SUSHI)
```

## Prerequisites

### 1. Node.js and SUSHI

```bash
# Install SUSHI globally
npm install -g fsh-sushi
```

### 2. Java (for full IG generation)

Java 17 or higher is required for the IG Publisher.

```bash
# Check Java version
java -version
```

### 3. (Optional) VS Code Extension

```bash
# Install FSH syntax highlighting
code --install-extension MITRE-Health.vscode-language-fsh
```

## Building the IG

### Quick Build (FSH only)

Compile FSH to FHIR JSON resources:

```bash
cd fhir-ig
./sushi.sh
# Or directly:
sushi .
```

This generates resources in `fsh-generated/resources/`.

### Full Build (HTML IG)

Generate the complete HTML Implementation Guide:

```bash
cd fhir-ig
./_genonce.sh
```

This will:
1. Download the IG Publisher (if not present)
2. Run SUSHI to compile FSH
3. Run the IG Publisher to generate HTML
4. Output to `output/`

Open `output/index.html` to view the generated IG.

## Profiles

| Profile | Resource | Description |
|---------|----------|-------------|
| CodocPatient | Patient | Multi-IPP support, patient merging |
| CodocOrganization | Organization | Hospital hierarchy |
| CodocEncounter | Encounter | Stays and movements |
| CodocDocumentReference | DocumentReference | Clinical documents |
| CodocLabObservation | Observation | Lab results |
| CodocPatientDataObservation | Observation | Patient traits |
| CodocPhenotypeObservation | Observation | NLP phenotypes |
| CodocProcedure | Procedure | Medical procedures |
| CodocMedicationRequest | MedicationRequest | Prescriptions |
| CodocDiagnosticReport | DiagnosticReport | Diagnostic reports |

## Extensions

- `UnitPeriod` - Activity period for care units
- `PhenotypeSemanticType` - UMLS semantic type
- `PhenotypeTfidf` - TF-IDF relevance score
- `PhenotypeCountConcept` - Concept count
- `PhenotypeCountStrFound` - String fragment count

## Terminology

### Code Systems
- `CodocOrganizationTypeCS` - Organization types
- `CodocPhenotypeComponentsCS` - Phenotype component codes
- `CodocPhenotypeSemanticTypeCS` - Semantic types

### Value Sets
- `CodocOrganizationTypeVS`
- `CodocObservationStatusVS`
- `CodocEncounterStatusVS`
- `CodocEncounterClassVS`
- `CodocPhenotypeSemanticTypeVS`

## Validation

To validate a resource against Codoc profiles:

```bash
# Download the FHIR Validator
curl -L https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar -o validator_cli.jar

# Validate
java -jar validator_cli.jar my-patient.json \
  -ig fsh-generated/resources/ \
  -profile https://codoc.co/fhir/StructureDefinition/CodocPatient
```

## Links

- [API Documentation](https://hefernan2.github.io/codoc-fhir-api-docs/)
- [FSH School](https://fshschool.org/)
- [HL7 FHIR R4B](https://hl7.org/fhir/R4B/)
