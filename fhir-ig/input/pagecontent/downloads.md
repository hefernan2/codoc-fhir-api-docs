# Downloads

This page provides downloadable artifacts from the Codoc FHIR Implementation Guide.

## Package Downloads

| Format | Description | Link |
|--------|-------------|------|
| **NPM Package** | FHIR NPM package for use with FHIR tools | [Package](package.tgz) |
| **Full IG** | Complete Implementation Guide as ZIP | [Full IG](full-ig.zip) |

## Definitions

| Format | Description | Link |
|--------|-------------|------|
| **JSON Definitions** | All StructureDefinitions in JSON | [definitions.json.zip](definitions.json.zip) |
| **XML Definitions** | All StructureDefinitions in XML | [definitions.xml.zip](definitions.xml.zip) |

## Examples

| Format | Description | Link |
|--------|-------------|------|
| **JSON Examples** | All examples in JSON format | [examples.json.zip](examples.json.zip) |
| **XML Examples** | All examples in XML format | [examples.xml.zip](examples.xml.zip) |

## Validation

### Using the FHIR Validator

To validate resources against Codoc profiles:

```bash
# Download the FHIR Validator
curl -L https://github.com/hapifhir/org.hl7.fhir.core/releases/latest/download/validator_cli.jar -o validator_cli.jar

# Validate a resource
java -jar validator_cli.jar my-patient.json \
  -ig codoc.fhir.ig#0.1.0 \
  -profile https://codoc.co/fhir/StructureDefinition/CodocPatient
```

### Using SUSHI

To use the Codoc IG as a dependency in your own FSH project:

```yaml
# sushi-config.yaml
dependencies:
  codoc.fhir.ig: 0.1.0
```

## Cross-Version Analysis

This Implementation Guide was built using:

| Tool | Version |
|------|---------|
| SUSHI | 3.x |
| HL7 IG Publisher | Latest |
| FHIR | R4B (4.3.0) |

## Intellectual Property

This Implementation Guide is licensed under [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/).

All artifacts defined herein are © 2025 Codoc.
