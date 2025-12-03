# Security and Privacy Considerations

## Overview

This page describes the security and privacy considerations for implementing the Codoc FHIR Implementation Guide. Given that healthcare data is highly sensitive, proper security measures are essential.

## Regulatory Framework

### GDPR (General Data Protection Regulation)

As a European healthcare system, Codoc must comply with GDPR requirements:

- **Data minimization** - Collect only necessary data
- **Purpose limitation** - Use data only for stated purposes
- **Right to access** - Patients can request their data
- **Right to erasure** - Patients can request deletion (with medical exceptions)
- **Data portability** - Patients can export their data

### CNIL (Commission Nationale de l'Informatique et des Libertés)

French-specific requirements for health data:

- **Hosting** - Health data must be hosted by HDS-certified providers
- **Consent** - Explicit consent for secondary use
- **Anonymization** - Support for de-identification

### HDS (Hébergeur de Données de Santé)

All systems storing health data must use HDS-certified hosting.

## Authentication and Authorization

### Required Authentication

All API endpoints require authentication:

```http
Authorization: Basic base64(username:password)
```

### Recommended: OAuth 2.0

For production systems, OAuth 2.0 with SMART on FHIR is recommended:

```http
Authorization: Bearer <access_token>
```

### Role-Based Access Control

| Role | Patient | Organization | Encounter | Document | Observation |
|------|---------|--------------|-----------|----------|-------------|
| Admin | CRUD | CRUD | CRUD | CRUD | CRUD |
| Clinician | R | R | CRUD | CRUD | CRUD |
| Nurse | R | R | RU | R | CR |
| Data Analyst | R | R | R | R | R |
| Registration | CRU | R | C | - | - |

Legend: C=Create, R=Read, U=Update, D=Delete

## Data Protection

### Encryption

| Layer | Requirement |
|-------|-------------|
| Transport | TLS 1.2+ required |
| Storage | AES-256 encryption at rest |
| Backup | Encrypted backups |

### Sensitive Data Elements

The following elements contain sensitive data and require special handling:

| Resource | Element | Sensitivity | Mitigation |
|----------|---------|-------------|------------|
| Patient | `name` | High | Can be anonymized |
| Patient | `birthDate` | High | Can use year only |
| Patient | `identifier` | High | Access logging |
| Patient | `address` | Medium | Optional element |
| Patient | `telecom` | Medium | Optional element |
| DocumentReference | `content.attachment.data` | Very High | Encrypted storage |

### Anonymization Support

The CodocPatient profile supports anonymization for CNIL compliance:

```json
{
  "resourceType": "Patient",
  "identifier": [{"value": "ANON_001"}],
  "name": [{"family": "Anonymous", "given": ["Patient"]}],
  "gender": "unknown",
  "birthDate": "1970-01-01"
}
```

## Audit Logging

### Required Audit Events

All access to patient data must be logged:

| Event | Data Captured |
|-------|---------------|
| Create | User, timestamp, resource type, resource ID |
| Read | User, timestamp, resource type, resource ID |
| Update | User, timestamp, resource type, resource ID, changed fields |
| Delete | User, timestamp, resource type, resource ID |
| Search | User, timestamp, search parameters |

### Audit Log Retention

- Minimum retention: 10 years (French healthcare requirement)
- Logs must be tamper-evident
- Regular backup required

## Data Integrity

### Validation

All incoming data is validated against:

1. FHIR schema
2. Codoc profile constraints
3. Business rules

### Referential Integrity

References between resources are validated:

- `Patient` must exist before creating `Encounter`
- `Organization` hierarchy must be valid
- `DocumentReference` must reference valid `Patient`

## Incident Response

### Data Breach Procedure

1. **Detection** - Automated monitoring for anomalies
2. **Containment** - Immediate access revocation
3. **Notification** - CNIL notification within 72 hours
4. **Investigation** - Root cause analysis
5. **Remediation** - Security improvements

### Contact

For security issues, contact: security@codoc.co

## Recommendations

### For Implementers

1. ✅ Use HTTPS for all communications
2. ✅ Implement proper authentication
3. ✅ Enable audit logging
4. ✅ Encrypt sensitive data at rest
5. ✅ Regular security assessments
6. ✅ Staff training on data protection

### For Developers

1. ✅ Never log sensitive data
2. ✅ Use parameterized queries
3. ✅ Validate all inputs
4. ✅ Implement rate limiting
5. ✅ Use secure session management
