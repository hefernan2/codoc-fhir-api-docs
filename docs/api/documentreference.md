---
title: DocumentReference
---

# DocumentReference - Clinical Documents

The **DocumentReference** resource represents clinical documents (reports, notes, etc.).

## Endpoints

<div class="api-endpoint">
  <span class="http-method get">GET</span>
  <span class="endpoint-path">/v4.3.0/documentreference/</span>
</div>
<div class="api-endpoint">
  <span class="http-method get">GET</span>
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

## Search Parameters

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `patient` | integer | Filter by patient ID | `?patient=123` |
| `encounter` | integer | Filter by stay ID | `?encounter=789` |
| `date` | date | Document date (FHIR prefixes: `ge`, `le`, `gt`, `lt`, `ne`) | `?date=ge2024-01-01` |
| `_lastUpdated` | date | Last update date (FHIR prefixes supported) | `?_lastUpdated=ge2024-01-01` |

## List Documents

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" "{API_URL}/v4.3.0/documentreference/?_count=20"
    ```

=== "Python"
    ```python
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    response = requests.get(
        "{API_URL}/v4.3.0/documentreference/",
        params={"_count": 20},
        headers=headers
    )
    
    bundle = response.json()
    print(f"Total: {bundle['total']} documents")
    for entry in bundle.get("entry", []):
        doc = entry["resource"]
        title = doc["content"][0]["attachment"].get("title", "Untitled")
        print(f"  ID {doc['id']}: {title} - {doc['date']}")
    ```

## Retrieve and Decode a Document

=== "Python"
    ```python
    import base64
    import requests
    
    headers = {"Authorization": "Api-Key {API_KEY}"}
    # Retrieve the document
    response = requests.get("{API_URL}/v4.3.0/documentreference/456/", headers=headers)
    doc = response.json()
    
    # Decode the content
    encoded_content = doc["content"][0]["attachment"]["data"]
    html_content = base64.b64decode(encoded_content).decode()
    
    print(f"Title: {doc['content'][0]['attachment'].get('title', 'N/A')}")
    print(f"Date: {doc['date']}")
    print(f"Content type: {doc['content'][0]['attachment']['contentType']}")
    print(html_content)  # <p>Consultation report</p>
    ```

=== "curl"
    ```bash
    curl -H "Authorization: Api-Key {API_KEY}" {API_URL}/v4.3.0/documentreference/456/
    ```

## Document Content Formats

Documents use Base64-encoded content. Two common formats are supported:

### HTML Document

```json
{
  "content": [{
    "attachment": {
      "contentType": "text/html",
      "data": "<base64 encoded HTML>",
      "title": "Consultation Report"
    }
  }]
}
```

### Plain Text Document

```json
{
  "content": [{
    "attachment": {
      "contentType": "text/plain",
      "data": "<base64 encoded text>",
      "title": "Clinical Note"
    }
  }]
}
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
