---
title: DocumentReference
---

# DocumentReference - Clinical Documents

The **DocumentReference** resource represents clinical documents (reports, notes, etc.).

## Endpoint

<div class="api-endpoint">
  <span class="http-method post">POST</span>
  <span class="endpoint-path">/v4.3.0/documentreference/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/documentreference/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method put">PUT</span>
  <span class="endpoint-path">/v4.3.0/documentreference/{id}/</span>
</div>
<div class="api-endpoint">
  <span class="http-method delete">DELETE</span>
  <span class="endpoint-path">/v4.3.0/documentreference/{id}/</span>
</div>

## Field Structure

| FHIR Field | Type | Required | Description |
|------------|------|----------|-------------|
| `status` | code | ✅ Yes | current, superseded, entered-in-error |
| `subject` | Reference | ✅ Yes | Related patient |
| `context.encounter[]` | Reference[] | No | Associated stay |
| `author[]` | Reference[] | No | Author(s) - Organization or practitioner |
| `date` | instant | ✅ Yes | Document creation date |
| `content[].attachment.contentType` | code | ✅ Yes | MIME type (text/html, text/plain) |
| `content[].attachment.data` | base64Binary | ✅ Yes | Content encoded in Base64 |
| `content[].attachment.title` | string | No | Document title |

## Create a Document

=== "curl"
    ```bash
    curl -X POST http://localhost:8000/v4.3.0/documentreference/ \
      -H "Content-Type: application/json" \
      -d '{
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": "Patient/123"},
        "context": {
          "encounter": [{"reference": "Encounter/789"}]
        },
        "author": [
          {"display": "Dr. Martin"},
          {"reference": "Organization/5", "display": "Cardiologie"}
        ],
        "date": "2024-01-15T14:30:00Z",
        "content": [
          {
            "attachment": {
              "contentType": "text/html",
              "data": "PHA+Q29tcHRlLXJlbmR1IGRlIGNvbnN1bHRhdGlvbjwvcD4=",
              "title": "Consultation cardiologie"
            }
          }
        ]
      }'
    ```

=== "Python"
    ```python
    import base64
    
    # Encode HTML content in Base64
    html_content = "<p>Consultation report</p>"
    encoded_content = base64.b64encode(html_content.encode()).decode()
    
    document = {
        "resourceType": "DocumentReference",
        "status": "current",
        "subject": {"reference": "Patient/123"},
        "context": {"encounter": [{"reference": "Encounter/789"}]},
        "author": [
            {"display": "Dr. Martin"},
            {"reference": "Organization/5", "display": "Cardiology"}
        ],
        "date": "2024-01-15T14:30:00Z",
        "content": [{
            "attachment": {
                "contentType": "text/html",
                "data": encoded_content,
                "title": "Cardiology consultation"
            }
        }]
    }
    
    response = requests.post("http://localhost:8000/v4.3.0/documentreference/", json=document)
    ```

## Retrieve and Decode a Document

=== "Python"
    ```python
    import base64
    
    # Retrieve the document
    response = requests.get("http://localhost:8000/v4.3.0/documentreference/456/")
    doc = response.json()
    
    # Decode the content
    encoded_content = doc["content"][0]["attachment"]["data"]
    html_content = base64.b64decode(encoded_content).decode()
    
    print(html_content)  # <p>Consultation report</p>
    ```

## Multiple Authors

A document can have multiple authors:

```json
{
  "author": [
    {"display": "Dr. Smith"},
    {"display": "Dr. Martin"},
    {"reference": "Organization/5", "display": "Cardiology Department"}
  ]
}
```

!!! info "Mandatory Reference for Organization"
    If the author is an Organization (Department/Unit), the reference must point to an existing ID.

## Automatic Text Creation

During creation, a Codoc Text object is automatically generated:

- Content: Base64 decoding of the `data` field
- Type: HTML or Plain text according to `contentType`
- Link: Via `document_id`

## Common Errors

### Error 400 - Invalid Base64

```json
{
  "issue": [{
    "severity": "error",
    "diagnostics": "Invalid Base64 encoding in attachment.data"
  }]
}
```

**Solution:** Verify the Base64 encoding of the content.

### Error 400 - Non-existent Patient

```json
{
  "issue": [{
    "severity": "error",
    "diagnostics": "Patient with ID 999 does not exist"
  }]
}
```

### Error 400 - Author Organization Not Found

```json
{
  "issue": [{
    "severity": "error",
    "diagnostics": "Organization with ID 999 does not exist"
  }]
}
```

**Solution:** If `author[]` contains an Organization reference, verify that the ID exists.

## Use Cases

### Document with Plain Text

```python
text_content = "Consultation report\n\nPatient seen on 01/15/2024..."
encoded = base64.b64encode(text_content.encode()).decode()

document = {
    "resourceType": "DocumentReference",
    "status": "current",
    "subject": {"reference": "Patient/123"},
    "date": "2024-01-15T14:30:00Z",
    "content": [{
        "attachment": {
            "contentType": "text/plain",
            "data": encoded,
            "title": "Consultation report"
        }
    }]
}
```

### Complete HTML Document

```python
html = """
<!DOCTYPE html>
<html>
<head><title>Consultation Report</title></head>
<body>
  <h1>Consultation Report</h1>
  <p><strong>Patient:</strong> John Smith</p>
  <p><strong>Date:</strong> 01/15/2024</p>
  <h2>Reason</h2>
  <p>Chest pain</p>
  <h2>Conclusion</h2>
  <p>No abnormality detected</p>
</body>
</html>
"""

encoded = base64.b64encode(html.encode()).decode()
```

## Related Resources

- [Patient](patient.md) - Via `subject`
- [Encounter](encounter.md) - Via `context.encounter`
- [Organization](organization.md) - Via `author` (Department/Unit)
- [Observation-phenotype](observation-phenotype.md) - Phenotypes extracted from document

<div class="quick-links">
  <a href="../observation/">🔬 Observation</a>
  <a href="../../guides/semantic-enrichment/">📖 Guide: Semantic Enrichment</a>
</div>
